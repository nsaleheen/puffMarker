package org.mstream.stream.file;

import java.io.BufferedWriter;

import org.mstream.stream.IStream;
import org.mstream.stream.items.IStreamItem;

import edu.umass.cs.sensors.utils.io.IOUtils;
import edu.umass.cs.sensors.utils.io.Logger;
import edu.umass.cs.sensors.wavelet.Wavelet;
import edu.umass.cs.sensors.wavelet.noise_filter;

/**
 * Implementation of a variety of Low pass filters for EDA stream
 * <p>
 * Refer enum {@link LowPassFilter.Filter} for more details
 * @author aparate
 *
 */
public class LowPassFilter implements IStream<IStreamItem>{




	private boolean verifiedNext = false;
	private boolean hasNext = false;

	private int LEVEL = 7;

	/**
	 * Child SVFileStream
	 */
	private IStream<IStreamItem> child = null;

	private int NUM_FIELDS = 6;
	private static final int WINDOW_SIZE = 1024;
	private int FILTER_INDEX[] = new int[]{5};

	private Object data[][] = null; //Stores all the fields for a given window
	private long times[] = null;
	private double filteredData[][] = null; //Stores filtered values


	//Variables and Class for default wavelet remove high frequency coeff
	private Wavelet wavelet = new Wavelet();
	private int currentIndex = -1; //Also used for Gaussian noise removal

	//Variables needed for Smoothing filter
	private double expectedValue[] =null;
	private static final double INVALID = -20000.0;
	private double SMOOTH_FACTOR = 2.0;

	//Variable indicating if the filtered value should replace original value
	//or it should append filtered value as a new field
	private boolean inPlace = true;

	/**
	 * Indicates Filter type to be used
	 * <p>
	 * @see <a href="http://phrogz.net/js/framerate-independent-low-pass-filter.html"> Low-pass smoothing filter</a><br/>
	 * <a href="http://baumdevblog.blogspot.com/2010/11/butterworth-lowpass-filter-coefficients.html"> Butterworth Filter</a><br/>
	 * <a href="http://www.bearcave.com/software/java/wavelets/haar.html"> Haar-wavelet based gaussian filter</a><br/>
	 * <a href="">Haar-wavelet compression based denoising</a>
	 */
	public enum Filter {WAVELET_COMPRESSION,WAVELET_GAUSSIAN,BUTTERWORTH,SMOOTHING};

	private Filter FILTER_TYPE = Filter.WAVELET_COMPRESSION;


	/**
	 * Constructor for EDALowPassFilter
	 * @param SAMPLE_RATE Sampling rate of input stream
	 * @param filterType 0:wavelet 1:gaussian 2:butterworth
	 * @param waveletLevel Should be set between 0 to 10. Applicable for {@code Filter.WAVELET_COMPRESSION} filter. Lower value has higher smoothing
	 * @param SMOOTH_FACTOR Should be set to at least 2. Applicable for {@code Filter.SMOOTHING} filter. Larger value leads to larger smoothing
	 * @param FILTER_INDEX array containing indices of fields that should be filtered
	 * @param inPlace boolean value if true indicates that the filtered value should replace original raw value, and if false, it appends 
	 * filtered value to the end.
	 * @param NUM_FIELDS number of fields in the input stream items
	 */
	public LowPassFilter(int SAMPLE_RATE, Filter filterType, int waveletLevel,double SMOOTH_FACTOR, int FILTER_INDEX[],
			boolean inPlace,
			int NUM_FIELDS){
		LEVEL = waveletLevel;
		FILTER_TYPE = filterType;
		getLPCoefficientsButterworth2Pole(SAMPLE_RATE, 0.2);
		this.FILTER_INDEX = FILTER_INDEX;
		this.NUM_FIELDS = NUM_FIELDS;
		this.inPlace = inPlace;
		filteredData = new double[FILTER_INDEX.length][];
		expectedValue = new double[FILTER_INDEX.length];
		xv = new double[FILTER_INDEX.length][3];
		yv = new double[FILTER_INDEX.length][3];
		for(int i=0;i<expectedValue.length;i++)
			expectedValue[i] = INVALID;
		this.SMOOTH_FACTOR = SMOOTH_FACTOR;
	}




	/**
	 * Returns next doubleitem
	 * @see org.mstream.stream.IStream#getNextItem()
	 **/
	@Override
	public IStreamItem getNextItem() {
		if(verifiedNext && hasNext){
			verifiedNext = false;
			return createNextItem();
		} 
		else if(!verifiedNext) 
		{
			hasNext = readNext();
			verifiedNext = false;
			if(hasNext)
				return createNextItem();
		}
		return null;
	}

	/** 
	 * Add single EDAFileStream as child
	 * @see org.mstream.stream.IStream#addChildStreams(org.mstream.stream.IStream[])
	 **/
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public void addChildStreams(IStream... streams) {
		for(IStream stream: streams)
		{
			//if(!(stream instanceof EDAFileStream))
			//continue;
			child = (IStream<IStreamItem>)stream;
		}
	}

	@Override
	public boolean hasNext(){
		if(verifiedNext)
			return hasNext;
		hasNext = readNext();
		return hasNext;
	}

	/**
	 * Closes this stream and all the child streams
	 * @see org.mstream.stream.IStream#closeStream()
	 */
	@Override
	public void closeStream() {

		if(child!=null)
			child.closeStream();
		child = null;
		verifiedNext = true;
		hasNext = false;
	}

	private double xv[][] = null;//new double[3];
	private double yv[][] = null;//new double[3];
	/**
	 * Reads the next item, returns true if next item is read successfully
	 * Sets verifiedNext to true only when next item is found
	 * @return true if reads next item successfully
	 */
	private boolean readNext() {
		if(child==null)
		{
			verifiedNext = true;
			return false;
		}
		if(currentIndex!=-1 && currentIndex<WINDOW_SIZE-1)
		{
			verifiedNext = true;
			if(times[currentIndex]!=0)
				return true;
			else return false;
		}
		if(currentIndex==-1 || currentIndex>=WINDOW_SIZE-1)
		{
			if(!child.hasNext())
			{
				verifiedNext = true;
				return false;
			}
			//We expect to read at least 1 value in the next window
			data = new Object[NUM_FIELDS][WINDOW_SIZE];
			times = new long[WINDOW_SIZE];
			filteredData = new double[FILTER_INDEX.length][];//new double[WINDOW_SIZE];

			//Read window
			for(int i=0;i<WINDOW_SIZE;i++)
			{
				//Repeat until we get valid data
				while(true) {
					if(child.hasNext()) 
					{
						IStreamItem item = child.getNextItem();
						try{
							parseItem(item,i);
							break;
						} catch(Exception e){
							Logger.error(e.getLocalizedMessage());
							continue;
						}
					}
					else {
						for(int j=0;j<NUM_FIELDS;j++)
							data[j][i] = 0.0;
						times[i]=0;
						break;
					}
				}
			}
			//All the incoming stream data was read as objects, now we read relevant data to be filtered in a double array
			double dData[][] = new double[FILTER_INDEX.length][WINDOW_SIZE];//NUM_COLUMNS x WINDOW_SIZE
			for(int k=0;k<FILTER_INDEX.length;k++) {
				int fIndex = FILTER_INDEX[k];
				for(int i=0;i<WINDOW_SIZE;i++) {
					if(data[fIndex][i]==null) data[fIndex][i] = 0.0;
					dData[k][i] = Double.parseDouble(data[fIndex][i].toString());
				}
			}
			//Now compute wavelet coefficients and extract smoothed data
			if(FILTER_TYPE == Filter.WAVELET_COMPRESSION){
				for(int k=0;k<FILTER_INDEX.length;k++) {
					double delta[] = new double[WINDOW_SIZE];
					wavelet.calculateCoeff(dData[k], delta);
					for(int j=(int)Math.pow(2, LEVEL);j<WINDOW_SIZE;j++)
						delta[j] = 0;
					filteredData[k] = wavelet.getData((int)(Math.log(WINDOW_SIZE)/Math.log(2)), delta);
				}
			}
			else if(FILTER_TYPE == Filter.WAVELET_GAUSSIAN) 
			{
				for(int k=0;k<FILTER_INDEX.length;k++) {
					filteredData[k] = new double[WINDOW_SIZE];
					for(int i=0;i<WINDOW_SIZE;i++)
						filteredData[k][i] = dData[k][i];
					noise_filter nf = new noise_filter();
					nf.filter_time_series(filteredData[k]);
				}
			} 
			else if(FILTER_TYPE == Filter.BUTTERWORTH) 
			{
				for(int k=0;k<FILTER_INDEX.length;k++) {
					filteredData[k] = new double[WINDOW_SIZE];
					for(int i=0;i<WINDOW_SIZE;i++){
						filteredData[k][i] = getFilteredValue(dData[k][i],k);
					}
				}
			}
			else if(FILTER_TYPE == Filter.SMOOTHING)
			{
				for(int k=0;k<FILTER_INDEX.length;k++) {
					filteredData[k] = new double[WINDOW_SIZE];
					for(int i=0;i<WINDOW_SIZE;i++){
						if(expectedValue[k]==INVALID) {
							expectedValue[k] = dData[k][i];
							filteredData[k][i] = expectedValue[k];
						}
						else {
							expectedValue[k] += (dData[k][i]-expectedValue[k])/SMOOTH_FACTOR;
							filteredData[k][i] = expectedValue[k];
						}
					}
				}
			}
			currentIndex = 0;
			verifiedNext = true;
			return true;
		}
		Logger.error("SHOULD not arrive here");
		verifiedNext = true;
		return false;
		//Loop till we get next item

	}


	private double ax[] = new double[3];
	private double by[] = new double[3];

	/**
	 * Get Butterworth 2 Pole LPC Coefficients
	 * @param SAMPLE_RATE
	 * @param cutoff
	 */
	private void getLPCoefficientsButterworth2Pole(int SAMPLE_RATE, double cutoff)
	{
		double PI      = 3.1415926535897932385;
		double sqrt2 = 1.4142135623730950488;

		double QcRaw  = (2 * PI * cutoff) / SAMPLE_RATE; // Find cutoff frequency in [0..PI]
		double QcWarp = Math.tan(QcRaw); // Warp cutoff frequency

		double gain = 1 / (1+sqrt2/QcWarp + 2/(QcWarp*QcWarp));
		by[2] = (1 - sqrt2/QcWarp + 2/(QcWarp*QcWarp)) * gain;
		by[1] = (2 - 2 * 2/(QcWarp*QcWarp)) * gain;
		by[0] = 1;
		ax[0] = 1 * gain;
		ax[1] = 2 * gain;
		ax[2] = 1 * gain;
	}

	/**
	 * Get filtered value for the most recent sample
	 * @param sample
	 * @return filtered value of the input sample
	 */
	private double getFilteredValue(double sample, int filterIndex) 
	{
		xv[filterIndex][2] = xv[filterIndex][1]; xv[filterIndex][1] = xv[filterIndex][0];
		xv[filterIndex][0] = sample;
		yv[filterIndex][2] = yv[filterIndex][1]; yv[filterIndex][1] = yv[filterIndex][0];

		yv[filterIndex][0] =   (ax[0] * xv[filterIndex][0] + ax[1] * xv[filterIndex][1] + ax[2] * xv[filterIndex][2]
				- by[1] * yv[filterIndex][0]
						- by[2] * yv[filterIndex][1]);

		//sample = yv[0];
		return yv[filterIndex][0];//sample;
	}

	/**
	 * Parses the input item
	 * @param sitem input item
	 * @param dataIndex index in the buffer data array 
	 */
	private void parseItem(IStreamItem sitem, int dataIndex) {
		for(int i=0;i<sitem.values.length;i++)
		{
			Object sval = sitem.getValueAsObject(i);//.getValue(i);
			data[i][dataIndex] = (sval==null?null:sval);
		}
		times[dataIndex] = sitem.timeStamp;
	}

	private IStreamItem createNextItem()
	{
		IStreamItem item;
		long ts = times[currentIndex];
		if(inPlace) {
			//In place replacement of raw values with filtered values
			Object vals[] = new Object[NUM_FIELDS];
			for(int i=0;i<NUM_FIELDS;i++)
				vals[i] = data[i][currentIndex];
			
			for(int i=0;i<FILTER_INDEX.length;i++)
				vals[FILTER_INDEX[i]] = filteredData[i][currentIndex];
			currentIndex++;
			item = new IStreamItem(ts,vals);
		} else {
			//Appending columns instead
			Object vals[] = new Object[NUM_FIELDS+FILTER_INDEX.length];
			for(int i=0;i<NUM_FIELDS;i++)
				vals[i] = data[i][currentIndex];
			//Replace raw values with filtered values
			for(int i=0;i<FILTER_INDEX.length;i++)
				vals[NUM_FIELDS+i] = filteredData[i][currentIndex];
			currentIndex++;
			item = new IStreamItem(ts,vals);
		}
		if(ts==0)
		{
			//Possibly because child finished with the data.
			//Should not proceed any further
			verifiedNext = true;
			hasNext = false;
		}
		return item;
	}




	@Override
	public void saveStreamToFile(String filePath) {
		BufferedWriter bw = IOUtils.getWriter(filePath);
		while(hasNext())
		{
			IStreamItem item = getNextItem();
			IOUtils.writeLine(item.toString(), bw);
		}
		IOUtils.close(bw);
	}

}

package org.mstream.stream.ecg;

import java.io.BufferedWriter;
import java.util.LinkedList;

import org.mstream.stream.IStream;

import edu.umass.cs.sensors.utils.io.IOUtils;
import edu.umass.cs.sensors.utils.io.Logger;

/**
 * Interpolate RR interval in an ECG stream
 * <p>
 * Input Stream: {@link RPeakDetectOperator}<br/>
 * Outputs to {@link RRSmoothOperator} 
 * <p>
 * Algorithm: Piecewise Cubic Hermite Interpolation {@code PCHIP}
 * <p>
 * Refer <a href="http://audition.ens.fr/brette/calculscientifique/lecture3.pdf">Lecture on PCHIP</a> 
 * 
 * @see <a href="http://en.wikipedia.org/wiki/Hermite_interpolation">Hermite Interpolation on Wikipedia</a>
 * @author aparate
 *
 */
public class RRInterpolateOperator implements IStream<ECGItem>{

	/**
	 * Buffer for ECG values
	 */
	private LinkedList<ECGItem> data = new LinkedList<ECGItem>();

	/**
	 * Number of samples to process
	 */
	private int currentIndex = -1;


	//Variables for tracking next item
	private boolean verifiedNext = false;
	private boolean hasNext = false;
	private int validDataPoints = -1;
	private int NSAMPLES = 100;

	private IStream<ECGItem> child = null;



	/**
	 * Constructor for {@link RRInterpolateOperator}
	 * @param NSAMPLES number of interpolated points
	 */
	public RRInterpolateOperator(int NSAMPLES){
		this.NSAMPLES = NSAMPLES;
	}
	
	/**
	 * Default constructor: Interpolates RR interval to 100 samples
	 */
	public RRInterpolateOperator(){
		NSAMPLES = 100;
	}


	/**
	 * Returns next {@link ECGItem}
	 * @see org.mstream.stream.IStream#getNextItem()
	 **/
	@Override
	public ECGItem getNextItem() {
		if(verifiedNext && hasNext){
			verifiedNext = false;
			return seekNextItem();
		} 
		else if(!verifiedNext) 
		{
			hasNext = readNext();
			verifiedNext = false;
			if(hasNext)
				return seekNextItem();
		}
		return null;
	}

	/** 
	 * Add one child stream implementing {@code IStream<ECGItem>}
	 * @throws Exception if stream is not of valid type 
	 * @see org.mstream.stream.IStream#addChildStreams(org.mstream.stream.IStream[])
	 **/
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public void addChildStreams(IStream... streams) {
		for(IStream stream:streams)
			child = (IStream<ECGItem>)stream;
	}

	@Override
	public boolean hasNext(){
		if(verifiedNext)
			return hasNext;
		hasNext = readNext();
		return hasNext;
	}


	@Override
	public void closeStream() {

		if(child!=null)
			child.closeStream();
		verifiedNext = true;
		hasNext = false;
	}

	/**
	 * Reads the next item, returns true if next item is read successfully<p>
	 * Sets verifiedNext to true only when next item is found
	 * @return true if reads next item successfully
	 */
	private boolean readNext() {
		if(child==null)
		{
			verifiedNext = true;
			return false;
		}
		if(currentIndex!=-1 && currentIndex<data.size())
		{
			verifiedNext = true;
			if(data.get(currentIndex)!=null)
				return true;
			else return false;
		}
		if(currentIndex==-1 || currentIndex>=data.size())
		{
			if(!child.hasNext())
			{
				verifiedNext = true;
				return false;
			}

			boolean success = false;
			while(!success) {
				//Clear previous data
				data.clear();
				success = true;
				validDataPoints = 0;
				//Read valid data up to next R peak 
				while(true) {
					if(child.hasNext()) 
					{
						ECGItem item = child.getNextItem();
						try{
							data.addLast(item);
							validDataPoints++;
							//Break on R
							String label = item.getLabel();
							if(label!=null && label.equals("R"))
								break;
						} catch(Exception e){
							e.printStackTrace();
							Logger.error(e.getLocalizedMessage());
							continue;
						}
					}
					else {
						//Exhausted stream, no more data
						success = false;
						//We loose last RR interval here, it's ok as there is no R
						break;
					}
				} //If success, we have data upto next R.
				//Check if we exhausted stream and didn't get any data
				if(!success && validDataPoints==0) {
					verifiedNext = true;
					return false;
				}
				//Got data, check if we can interpolate
				success = rInterpolate();
			}
			//Got out of while loop because we successfully interpolated
			currentIndex = 0;
			verifiedNext = true;
			return success;
		}
		Logger.error("SHOULD not arrive here");
		verifiedNext = true;
		return false;
		//Done
	}



	private ECGItem seekNextItem()
	{
		ECGItem item = data.get(currentIndex);
		currentIndex++;

		if(item==null || item.timeStamp==0)
		{
			//Possibly because child finished with the data.
			//Should not proceed any further
			verifiedNext = true;
			hasNext = false;
		}
		return item;
	}

	/**
	 * Saves {@link ECGItem} containing timestamps, interpolated ecg values along with R and S peak labels.
	 * Each record in the file has timestamp followed by raw ECG value, interpolated ECG value,
	 * and lastly, the label. A label can be R, S or null.
	 * @see org.mstream.stream.IStream#saveStreamToFile(java.lang.String)
	 **/
	@Override
	public void saveStreamToFile(String filePath) {
		BufferedWriter bw = IOUtils.getWriter(filePath);
		while(hasNext())
		{
			ECGItem item = getNextItem();
			IOUtils.writeLine(item.toString(), bw);
		}
		IOUtils.close(bw);
	}


	/**
	 * Interpolates data
	 * @return true if interpolated successfully
	 */
	private boolean rInterpolate() {

		long startTime = data.getFirst().timeStamp;
		long endTime = data.getLast().timeStamp;
		//Valid heart rate test
		double heartRate = (60.0*1000)/(endTime-startTime);
		if(heartRate<=50 || heartRate>150)
			return false;
		
		//Get Time and data array
		long times[] = new long[data.size()];
		double ecg[] = new double[data.size()];
		for(int i=0;i<times.length;i++)
		{
			times[i] = data.get(i).timeStamp;
			ecg[i] = data.get(i).getRawValue();
		}
		//Get LinSpace
		long tLin[] = linspace(startTime,endTime,NSAMPLES);
		double proc[] = new double[tLin.length];//Array to save processed data
		proc[0] = ecg[0]; proc[proc.length-1] = ecg[ecg.length-1];
		
		LinkedList<ECGItem> interpolatedData = new LinkedList<ECGItem>();
		ECGItem item = new ECGItem(tLin[0]);
		item.setValues(ecg[0],proc[0],data.get(0).getLabel());
		interpolatedData.add(item);
		int hIndex = 0;
		for(int i=1;i<tLin.length-1;i++){
			//Get hIndex for current time
			for(int j=hIndex;j<times.length;j++)
			{
				if(tLin[i]<times[j])
				{
					hIndex = j-1; break;
				}
			}
			//interpolate
			proc[i] = getCubicHermiteInterpolation(tLin[i], hIndex, ecg, times);
			item = new ECGItem(tLin[i]);
			item.setValues(ecg[hIndex],proc[i],data.get(hIndex).getLabel());
			interpolatedData.add(item);
		}
		item = new ECGItem(tLin[tLin.length-1]);
		item.setValues(ecg[ecg.length-1],proc[proc.length-1],data.get(ecg.length-1).getLabel()); 
		interpolatedData.add(item);
		
		if(interpolatedData.size()!=100)
			System.out.println("Incorrect interpolated window of length:"+interpolatedData.size());
		data.clear();
		data.addAll(interpolatedData);
		return true;
	}

	
	/**
	 * Get linearly spaced values between start and end
	 * @param startTime
	 * @param endTime
	 * @param N
	 * @return array
	 */
	private long[] linspace(long startTime, long endTime, int N){
		long out[] = new long[N];
		out[N-1] = endTime;//Because fractions may not sum to endtime
		long delta = endTime-startTime;
		for(int i=0;i<N-1;i++)
			out[i] = startTime+(i*delta)/(N-1);
		return out;
	}
	
	/**
	 * Compute Piecewise Cubic Hermite Interpolation at input time 
	 * <p> We compute ecg value using H(time) where times[hIndex]<=time<=times[hIndex+1]. 
	 * @param time at which interpolated ecg value is needed
	 * @param hIndex index for H function
	 * @param ecg signals
	 * @param times time of observations
	 * @return interpolated value
	 */
	private double getCubicHermiteInterpolation(long time,int hIndex, double ecg[], long times[])
	{
		double a = ecg[hIndex]; //y1 value
		long deltax = (times[hIndex+1]-times[hIndex]); //x2-x1
		double deltay = (ecg[hIndex+1]-ecg[hIndex]); //y2-y1
		 
		double yp1 = 0.0;
		if(hIndex>0)
			yp1 = (ecg[hIndex]-ecg[hIndex-1])/(times[hIndex]-times[hIndex-1]);//y1'
		else
			yp1 += (ecg[hIndex+1]-ecg[hIndex])/(times[hIndex+1]-times[hIndex]);//y1'
		//if(hIndex>0) yp1/=2;
		double yp2 = 0.0;
		if(hIndex+2<times.length)
			yp2 = (ecg[hIndex+2]-ecg[hIndex+1])/(times[hIndex+2]-times[hIndex+1]);//y2'
		else
			yp2 += (ecg[hIndex+1]-ecg[hIndex])/(times[hIndex+1]-times[hIndex]);//y2'
		//if(hIndex+2<times.length) yp2/=2;
		double b = yp1;
		double c = (deltay/deltax - yp1)/deltax;
		double d = (yp1+yp2-((2*deltay)/deltax))/(deltax*deltax);
		double x = (time-times[hIndex]);
		double h = a+x*(b+x*(c+d*(time-times[hIndex+1])));
		//System.out.println(h+" "+a+" "+b+" "+c+" "+d+" "+yp1+" "+yp2+" "+x+" "+deltax+" "+deltay+" "+(time-times[hIndex+1]));
		
		return h;
	}

}

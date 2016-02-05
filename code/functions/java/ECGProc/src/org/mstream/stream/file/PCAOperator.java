package org.mstream.stream.file;

import java.io.BufferedWriter;
import java.util.LinkedList;

import org.mstream.stream.IStream;
import org.mstream.stream.items.DoubleValuesItem;
import org.mstream.stream.items.IStreamItem;

import edu.umass.cs.sensors.features.PCAFeature;
import edu.umass.cs.sensors.utils.io.IOUtils;
import edu.umass.cs.sensors.utils.io.Logger;

/**
 * Computes FFT
 * <p>
 * Input Stream: Any stream<br/>
 * 
 * @author Abhinav Parate
 */
public class PCAOperator implements IStream<DoubleValuesItem>{


	private LinkedList<IStreamItem> inData = new LinkedList<IStreamItem>();
	private LinkedList<DoubleValuesItem> outData = new LinkedList<DoubleValuesItem>();

	/**
	 * Number of samples to process
	 */
	private int currentIndex = -1;


	//Variables for tracking next item
	private boolean verifiedNext = false;
	private boolean hasNext = false;
	private int validDataPoints = -1;
	private int WINDOW_IN_SECONDS = 100;
	private int NUM_WINDOWS=20;
	private int INDEX_TO_READ = 0;
	private int DIMENSIONS = 0;
	private int SAMPLE_RATE=8;//in Hz

	private IStream<IStreamItem> child = null;


	/**
	 * Constructor for {@link PCAOperator}
	 * @param WINDOW_IN_SECONDS results in 1 output for each window
	 * @param INDEX_TO_READ index of column where the data is
	 * @param SAMPLE_RATE in hz
	 * @param DIMENSIONS dimensions to be used in PCA
	 */
	public PCAOperator(int WINDOW_IN_SECONDS, int INDEX_TO_READ, int SAMPLE_RATE, int DIMENSIONS){
		this.WINDOW_IN_SECONDS = WINDOW_IN_SECONDS;
		this.INDEX_TO_READ = INDEX_TO_READ;
		this.SAMPLE_RATE = SAMPLE_RATE;
		this.DIMENSIONS = DIMENSIONS;
	}



	/**
	 * Returns next {@link DoubleValuesItem}
	 * @see org.mstream.stream.IStream#getNextItem()
	 **/
	@Override
	public DoubleValuesItem getNextItem() {
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
	 * Add one child stream implementing {@code IStream<DoubleValuesItem>}
	 * @throws Exception if stream is not of valid type 
	 * @see org.mstream.stream.IStream#addChildStreams(org.mstream.stream.IStream[])
	 **/
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public void addChildStreams(IStream... streams) {
		for(IStream stream:streams)
			child = (IStream<IStreamItem>)stream;
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
		if(currentIndex!=-1 && currentIndex<outData.size())
		{
			verifiedNext = true;
			if(outData.get(currentIndex)!=null)
				return true;
			else return false;
		}
		if(currentIndex==-1 || currentIndex>=outData.size())
		{
			if(!child.hasNext())
			{
				verifiedNext = true;
				return false;
			}

			boolean success = false;
			while(!success) {
				//read next N Samples
				success = readNSamples();
				if(!success)
				{	
					//Failed because no items left in stream
					verifiedNext = true;
					return false;
				}

				//Got data, check if we can interpolate
				success = rExtractPCA();
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

	/**
	 * Reads <NSAMPLES> and saves it in a data
	 * @return true if successfully reads N sample
	 */
	private boolean readNSamples(){
		boolean success = true;
		validDataPoints = 0;
		int NSAMPLES_TO_READ = WINDOW_IN_SECONDS*(SAMPLE_RATE)*NUM_WINDOWS;
		IStreamItem items[] = new IStreamItem[NSAMPLES_TO_READ];
		inData.clear();
		for(int i=0;i<NSAMPLES_TO_READ;i++) {
			while(success){
				if(child.hasNext()) 
				{
					IStreamItem item = child.getNextItem();
					try{
						items[i] = item;
						inData.add(item);
						validDataPoints++;
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
					break;
				}
			} //Got one Item
		}//Got N items
		if(validDataPoints != NSAMPLES_TO_READ)
			return false;
		return true;
	}


	private DoubleValuesItem seekNextItem()
	{
		DoubleValuesItem item = outData.get(currentIndex);
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
	 * Saves FFT energy in coefficients stream with timestamps
	 * @see org.mstream.stream.IStream#saveStreamToFile(java.lang.String)
	 **/
	@Override
	public void saveStreamToFile(String filePath) {
		BufferedWriter bw = IOUtils.getWriter(filePath);
		//String header = "RR,QT,QTc,PR,QRS,TH";
		//IOUtils.writeLine(header, bw);
		while(hasNext())
		{
			DoubleValuesItem item = getNextItem();
			IOUtils.writeLine(item.toString(), bw);
		}
		IOUtils.close(bw);
	}


	/**
	 * Extracts PCA features
	 * @return true if smooth successful
	 */
	private boolean rExtractPCA() {

		outData.clear();
		if(inData.size()!=WINDOW_IN_SECONDS*(SAMPLE_RATE)*NUM_WINDOWS) return false;

		Double data[] = new Double[inData.size()];
		for(int i=0;i<data.length;i++){
			data[i] = inData.get(i).getValueAsDouble(INDEX_TO_READ);
		}
		int SAMPLES_PER_WINDOW = WINDOW_IN_SECONDS*SAMPLE_RATE;
		//Now split data into windows
		int maxIndex = data.length-SAMPLES_PER_WINDOW;
		//Total Windows is maxIndex
		double matrix[][] = new double[maxIndex][SAMPLES_PER_WINDOW];
		for(int i=0;i<maxIndex;i++)
			for(int j=0;j<SAMPLES_PER_WINDOW;j++)
				matrix[i][j] = data[i+j];
		//Created SSA data
		PCAFeature pcaFeat = new PCAFeature();

		boolean continuous = true;
		boolean printHeatMap = false;
		//1 Output per record
		if(printHeatMap){
			double output[][] = pcaFeat.getPCAFeature(matrix,DIMENSIONS);
			if(continuous){
				for(int i=0;i<output.length;i++){
					Double vals[] = new Double[output[i].length];
					for(int j=0;j<vals.length;j++)
						vals[j] = output[i][j];
					DoubleValuesItem item = new DoubleValuesItem(inData.get(i).timeStamp,vals);
					outData.add(item);
				}
			}
			//1 output per window
			else {
				maxIndex = output.length/(SAMPLES_PER_WINDOW);//Now, we will get output per window 
				for(int i=0;i<maxIndex;i++){
					Double vals[] = new Double[output[i*SAMPLES_PER_WINDOW].length];
					for(int j=0;j<vals.length;j++)
						vals[j] = output[i*SAMPLES_PER_WINDOW][j];
					DoubleValuesItem item = new DoubleValuesItem(inData.get(i*SAMPLES_PER_WINDOW).timeStamp,vals);
					outData.add(item);
				}
			}
		} else {
			boolean reconstruct = false;
			if(reconstruct){
				//Prints time-series of reconstructed output
				double output[][] = pcaFeat.getRebuiltData(matrix, DIMENSIONS);
				//Prints time series in stead of heat map
				for(int i=0;i<output.length;i++){
					Double vals[] = new Double[]{output[i][0]};
					DoubleValuesItem item = new DoubleValuesItem(inData.get(i).timeStamp,vals);
					outData.add(item);
				}
			} else {
				//Prints dominant components instead
				double output[][][] = pcaFeat.getNDominantComponents2(matrix, DIMENSIONS);
				/*maxIndex = output[0].length/(SAMPLES_PER_WINDOW);//Now, we will get output per window 
				for(int i=0;i<maxIndex;i++){
					int len = output[0][i*SAMPLES_PER_WINDOW].length;
					long delta = WINDOW_IN_SECONDS*1000/len;
					//System.out.println(len+" "+delta);
					for(int j=0;j<len;j++){
						Double vals[] = new Double[DIMENSIONS];
						for(int k=0;k<DIMENSIONS;k++){
							vals[k] = output[k][i*SAMPLES_PER_WINDOW][j];
						}
						DoubleValuesItem item = new DoubleValuesItem(inData.get(i*SAMPLES_PER_WINDOW).timeStamp+j*delta,vals);
						outData.add(item);
					}
				}*/
				
				//for(int i=0;i<output[0].length;i++){
				for(int i=0;i<matrix.length;i++){
					Double vals[] = new Double[DIMENSIONS+1];
					vals[0] = data[i];
					for(int k=0;k<DIMENSIONS;k++) {
						if(i<output[0].length)
							vals[k+1] = output[k][i][0];
						else vals[k+1] = 0.0;
					}
					DoubleValuesItem item = new DoubleValuesItem(inData.get(i).timeStamp,vals);
					outData.add(item);
				}
			}
		}

		//Finished
		return true;
	}

}

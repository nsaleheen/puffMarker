package org.mstream.stream.ecg;

import java.io.BufferedWriter;
import java.util.LinkedList;

import org.mstream.stream.IStream;

import edu.umass.cs.sensors.utils.io.IOUtils;
import edu.umass.cs.sensors.utils.io.Logger;

/**
 * Smooth RR interval over a time window in an ECG stream
 * <p>
 * Input Stream: {@link RRInterpolateOperator}<br/>
 * Outputs to {@link RRAllPeaksDetectOperator} 
 * 
 * @author Abhinav Parate
 */
public class RRSmoothOperator implements IStream<ECGItem>{

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
	private int WINDOW_IN_SECS = 30;
	private int SHIFT_IN_SECS = 1;
	private boolean SHIFT_BY_SAMPLE = false;

	private IStream<ECGItem> child = null;

	private LinkedList<ECGItem[]> rrSamples = new LinkedList<ECGItem[]>();



	/**
	 * Constructor for {@link RRSmoothOperator}
	 * @param NSAMPLES number of interpolated points
	 * @param WINDOW_IN_SECS sliding window in seconds
	 * @param SHIFT_IN_SECS shift between windows
	 */
	public RRSmoothOperator(int NSAMPLES, int WINDOW_IN_SECS, int SHIFT_IN_SECS){
		this.NSAMPLES = NSAMPLES;
		this.WINDOW_IN_SECS = WINDOW_IN_SECS;
		this.SHIFT_IN_SECS = SHIFT_IN_SECS;
		this.SHIFT_BY_SAMPLE = false;
	}

	/**
	 * Default constructor: 100 Samples, 30 sec window, 1 sec shift
	 * @param SHIFT_BY_SAMPLE if true, we shift one sample in stead of a second
	 */
	public RRSmoothOperator(boolean SHIFT_BY_SAMPLE){
		NSAMPLES = 100;
		WINDOW_IN_SECS = 30;
		SHIFT_IN_SECS = 1;
		this.SHIFT_BY_SAMPLE = SHIFT_BY_SAMPLE;
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
			//Shift rrSamples by 1 second
			long startTime = -1;

			//Logic to shift by sample
			if(SHIFT_BY_SAMPLE){
				if(rrSamples.size()!=0){ 
					startTime = rrSamples.peekFirst()[0].timeStamp;
					rrSamples.removeFirst();
				}
				startTime = -1;
				if(rrSamples.size()!=0){ startTime = rrSamples.peekFirst()[0].timeStamp;}
			}
			//End shift by sample

			//Logic to shift samples by 1 second
			else {
				if(rrSamples.size()!=0){ startTime = rrSamples.peekFirst()[0].timeStamp;}
				//Remove samples not in 1 second
				while(rrSamples.size()!=0){
					long ctime = rrSamples.peekFirst()[0].timeStamp;
					if((ctime-startTime)<SHIFT_IN_SECS*1000)
					{
						rrSamples.removeFirst();
						continue;
					} else {
						startTime = ctime; //New start time
						break;
					}
				}
			} //End shift samples by 1 second
			
			boolean success = false;
			while(!success) {
				//read next RR Sample
				success = readRRSample();
				if(!success)
				{	
					//Failed because no items left in stream
					verifiedNext = true;
					return false;
				}

				success = false;// initialize for next test
				if(startTime==-1) startTime = rrSamples.getFirst()[0].timeStamp;
				long ctime = rrSamples.getLast()[0].timeStamp;
				//Read more samples
				if((ctime-startTime)<WINDOW_IN_SECS*1000)
					continue;
				else {
					//Got data, check if we can interpolate
					success = rSmooth();
				}
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

	private boolean readRRSample(){
		boolean success = true;
		validDataPoints = 0;
		ECGItem items[] = new ECGItem[NSAMPLES];
		for(int i=0;i<NSAMPLES;i++) {
			while(success){
				if(child.hasNext()) 
				{
					ECGItem item = child.getNextItem();
					try{
						items[i] = item;
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
			} //Got ECG Item
		}//Got 100 items
		if(validDataPoints != NSAMPLES)
			return false;
		rrSamples.add(items);
		return true;
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
	 * Saves {@link ECGItem} containing timestamps, processed/smooth ecg values along with R and S peak labels.
	 * Each record in the file has timestamp followed by raw ECG value, processed/smooth ECG value,
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
	 * Smoothes RR sample, Gives average RR too!
	 * @return true if smooth successful
	 */
	private boolean rSmooth() {

		if(rrSamples.size()==0) return false;

		//We first identify samples that lie within 30 seconds window
		long startTime = rrSamples.getFirst()[0].timeStamp;
		int validSampleLength = 0;
		for(int i=0;i<rrSamples.size();i++){
			long ctime = rrSamples.get(i)[0].timeStamp;
			if((ctime-startTime)<WINDOW_IN_SECS*1000)
				validSampleLength = i+1;
			else break;
		}

		double ecg[][] = new double[validSampleLength][NSAMPLES];

		//Now, we compute mean of RR waveforms
		double mean[] = new double[validSampleLength];
		for(int i=0;i<validSampleLength;i++)
		{
			ECGItem items[] = rrSamples.get(i);
			for(int j=0;j<NSAMPLES;j++)
			{
				mean[i] += (items[j].getProcessedValue()/NSAMPLES);
				ecg[i][j] = items[j].getProcessedValue();
			}
		}

		//Compute standard deviation
		double std[] = new double[validSampleLength];
		for(int i=0;i<validSampleLength;i++)
			for(int j=0;j<NSAMPLES;j++)
				std[i] += (Math.pow(ecg[i][j]-mean[i],2)/NSAMPLES);
		for(int j=0;j<validSampleLength;j++)
			std[j] = Math.sqrt(std[j]);

		//Standardized ECG samples using mean and standard deviation for DC Offset
		for(int i=0;i<validSampleLength;i++)
		{
			for(int j=0;j<NSAMPLES;j++)
				ecg[i][j] = (ecg[i][j]-mean[i])/std[i];
		}

		//Now, recompute mean over standardized samples
		mean = new double[NSAMPLES];
		for(int i=0;i<validSampleLength;i++)
			for(int j=0;j<NSAMPLES;j++)
				mean[j] += (ecg[i][j]/validSampleLength);

		//Now, recompute std over standardized samples
		std = new double[NSAMPLES];
		for(int i=0;i<validSampleLength;i++)
			for(int j=0;j<NSAMPLES;j++)
				std[j] += (Math.pow(ecg[i][j]-mean[j],2)/validSampleLength);
		for(int j=0;j<NSAMPLES;j++)
			std[j] = Math.sqrt(std[j]);

		//Check for samples that classify and fall within 3 standard deviations
		int nGoodSamples = 0;
		double norm_ecg[] = new double[NSAMPLES];
		@SuppressWarnings("unused")
		double norm_rr = 0.0;
		for(int i=0;i<validSampleLength;i++)
		{
			boolean goodSample = true;
			for(int j=0;j<NSAMPLES && goodSample;j++)
				if(ecg[i][j]<(mean[j]-3*std[j]) || ecg[i][j]>(mean[j]+3*std[j]))
					goodSample = false;
			//See if good sample
			if(goodSample)
			{
				nGoodSamples++;
				for(int j=0;j<NSAMPLES;j++)
					norm_ecg[j] += ecg[i][j];
				ECGItem items[] = rrSamples.get(i);
				norm_rr += (items[NSAMPLES-1].timeStamp-items[0].timeStamp);
			}
		}//Done looking for good samples

		if(nGoodSamples==0) return false;
		//Now, compute mean over this
		norm_rr /= nGoodSamples;
		for(int i=0;i<NSAMPLES;i++)
			norm_ecg[i] /=  nGoodSamples;

		data.clear();
		//Now, package this processed ECG into data array to be used for next item
		ECGItem items[]=rrSamples.getFirst();
		for(int i=0;i<NSAMPLES;i++)
		{
			ECGItem item = new ECGItem(items[i].timeStamp);
			item.setValues(items[i].getRawValue(),norm_ecg[i],items[i].getLabel());
			data.add(item);
		}
		//Finished
		return true;
	}



}

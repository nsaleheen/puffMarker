package org.mstream.stream.ecg;

import java.io.BufferedWriter;
import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedList;

import org.mstream.stream.IStream;
import org.mstream.stream.items.DoubleValuesItem;

import edu.umass.cs.sensors.utils.io.IOUtils;
import edu.umass.cs.sensors.utils.io.Logger;

/**
 * Detects R peaks in an ECG stream
 * <p>
 * Java implementation of matlab code by Gari Clifford. 
 * <p>
 * Refer <a href="http://www.mit.edu/~gari/CODE/ECGtools/">ECGBag Toolbox from Gari Clifford</a>
 * 
 * <p>
 * Input Stream: any {@link org.mstream.stream.IStream} that outputs {@link org.mstream.stream.items.DoubleValuesItem}.<br/> 
 * Outputs to {@link org.mstream.stream.ecg.RRInterpolateOperator}<br/>
 * 
 * @see <a href="http://www.mit.edu/~gari/CODE/ECGtools/">ECGBag Toolbox from Gari Clifford</a>
 * @author aparate
 *
 */
public class RPeakDetectOperator implements IStream<ECGItem>{

	/**
	 * Buffer for ECG values
	 */
	private ECGItem data[] = null;
	
	/**
	 * Sampling rate : 250 Hz in bioharness data
	 */
	private int sampleRate = 250;
	
	/**
	 * Operates algorithm over window of <N> seconds.
	 */
	private static final int WINDOW_IN_SECS = 1000;//1000 seconds
	
	/**
	 * Number of samples to process
	 */
	private int NSAMPLES = sampleRate*WINDOW_IN_SECS; 
	private double threshold = 0.2;
	private int currentIndex = -1;
	

	//Variables for tracking next item
	private boolean verifiedNext = false;
	private boolean hasNext = false;
	private int validDataPoints = -1;
	
	private IStream<DoubleValuesItem> child = null;
	
	
	
	/**
	 * Constructor for {@link RPeakDetectOperator}
	 * @param SAMPLE_RATE sampling rate of the files in Hz
	 */
	public RPeakDetectOperator(int SAMPLE_RATE){
		sampleRate = SAMPLE_RATE;
		NSAMPLES = sampleRate*WINDOW_IN_SECS;
	}
	
	/**
	 * Constructor for {@link RPeakDetectOperator}
	 * @param SAMPLE_RATE sampling rate of the files in Hz
	 * @param threshold value between 0 to 1. A value of 0.2 has been shown to give good results.
	 */
	public RPeakDetectOperator(int SAMPLE_RATE, double threshold){
		sampleRate = SAMPLE_RATE;
		NSAMPLES = sampleRate*WINDOW_IN_SECS;
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
	 * Add one child stream implementing {@code IStream<DoubleValuesItem>}
	 * @throws Exception if stream is not of valid type 
	 * @see org.mstream.stream.IStream#addChildStreams(org.mstream.stream.IStream[])
	 **/
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public void addChildStreams(IStream... streams) {
		for(IStream stream:streams)
		{
			child = (IStream<DoubleValuesItem>)stream;
		}	
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
		if(currentIndex!=-1 && currentIndex<NSAMPLES-1)
		{
			verifiedNext = true;
			if(data[currentIndex]!=null)
				return true;
			else return false;
		}
		if(currentIndex==-1 || currentIndex>=NSAMPLES-1)
		{
			if(!child.hasNext())
			{
				verifiedNext = true;
				return false;
			}
			//We expect to read at least 1 value in the next window
			data = new ECGItem[NSAMPLES];
			validDataPoints = 0;
			//Read window
			for(int i=0;i<NSAMPLES;i++)
			{
				//Repeat until we get valid data
				while(true) {
					if(child.hasNext()) 
					{
						DoubleValuesItem item = child.getNextItem();
						try{
							data[i] = parseItem(item);
							validDataPoints++;
							break;
						} catch(Exception e){
							Logger.error(e.getLocalizedMessage());
							continue;
						}
					}
					else {
						data[i] = null;
						break;
					}
				}
			}
			rPeakDetect();
			currentIndex = 0;
			verifiedNext = true;
			return true;
		}
		Logger.error("SHOULD not arrive here");
		verifiedNext = true;
		return false;
		//Loop till we get next item
		//Done
	}
	
	

	/**
	 * Parse string item from the string
	 * @param ditem
	 * @return parsed ecg item
	 */
	private ECGItem parseItem(DoubleValuesItem ditem) {
		ECGItem item = new ECGItem(ditem.timeStamp);
		//Save Scaled ECG value between 0-5mV
		item.setRawValue(ditem.getValue(0));//*5.0/4095);
		return item;
	}
	
	private ECGItem seekNextItem()
	{
		ECGItem item = data[currentIndex];
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
	 * Saves {@link ECGItem} containing timestamps with R and S peak labels.
	 * Each record in the file has timestamp followed by raw ECG value, processed ECG value (null at this stage),
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
	
	
	private void rPeakDetect() {
		
		//Compute Mean of values
		double mean = 0.0;
		double x[] = new double[validDataPoints];
		for(int i=0;i<x.length;i++)
		{
			double raw = data[i].getRawValue();
			mean+= raw;
			x[i] = raw;
		}
		mean/= x.length;
		//Subtract mean
		for(int i=0;i<x.length;i++)
			x[i] = x[i]-mean;
		//Compute diff
		double diff[] = diff(x);
		//Compute diff*diff
		for(int i=0;i<diff.length;i++)
			diff[i] = diff[i]*diff[i];
		//Create window d
		double d[] = {1,1,1,1,1,1,1};
		//Now compute running sum of diff^2 over window d
		double rsum[] = filter(d,1,diff);
		//Apply median filter of order 10
		rsum = medianFilter1(rsum, 10);
		//Remove filter delay
		int delay = (int)Math.ceil(d.length/2);
		rsum = Arrays.copyOfRange(rsum, delay, rsum.length);
		
		//Segment search area
		double maxH = max(rsum,(int)Math.rint(rsum.length/4),(int)Math.rint(3*rsum.length/4)+1);
		
		//Build an array of segments
		int possReg[] = new int[rsum.length];
		double cmp = threshold*maxH;
		for(int i=0;i<possReg.length;i++)
			possReg[i] = (rsum[i]>cmp?1:0);
		//Find peaks and index into boundaries
		//First pad zeroes
		double f1[] = new double[possReg.length+1];
		double f2[] = new double[possReg.length+1];
		for(int i=0;i<f1.length;i++){
			f1[i] = (i==0?0.0:possReg[i-1]);
			f2[i] = (i==f1.length-1?0.0:possReg[i]);
		}
		f1 = diff(f1);
		f2 = diff(f2);
		Integer left[] = find(f1,1);
		Integer right[] = find(f2,-1);
		
		int maxIndex=0,minIndex=0;
		for(int i=0;i<left.length;i++)
		{
			maxIndex = maxIndex(x,left[i],right[i]);
			minIndex = minIndex(x,left[i],right[i]);
			data[maxIndex].setLabel("R");
			data[minIndex].setLabel("S");
		}
		//Check for lead inversion
		if(minIndex<maxIndex)
		{
			//Does not impact R_index in matlab code for RR interval 
		}
		
		
	}
	
	/**
	 * Computes running sum over window d weighted by a. Similar to SMOOTHING in ({@link org.mstream.stream.file.LowPassFilter.Filter})
	 * <br/>This is not a matlab filter implementation!
	 * @param d
	 * @param a
	 * @param signal
	 */
	private double[] filter(double d[],double a, double signal[]){
		double out[] = new double[signal.length];
		double sum=0.0;
		int win = d.length;
		for(int i=0;i<signal.length;i++)
		{
			sum = sum+a*(signal[i]-(i>=win?signal[i-win]:0.0));
			out[i]=sum;
		}
		return out;
	}
	
	/**
	 * Median filter1 implementation
	 * @param signal array of input values
	 * @param order of the filter
	 * @return array after median filter
	 */
	private double[] medianFilter1(double signal[], int order){
		int len = signal.length;
		double out[] = new double[len];
		if(order%2==0) {
			for(int i=0;i<len;i++)
			{
				int start = (i-order/2);
				start = (start<0?0:start);
				int end = (i+(order/2)-1);
				end = ((end>(len-1))?len-1:end);
				int padding = ((end-start+1)<order?(order-(end-start+1)):0);
				out[i] = median(Arrays.copyOfRange(signal, start, end+1),padding);
			}
		} else {
			for(int i=0;i<len;i++)
			{
				int start = (i-(order-1)/2);
				start = (start<0?0:start);
				int end = (i+((order-1)/2-1));
				end = ((end>(len-1))?len-1:end);
				int padding = ((end-start+1)<order?(order-(end-start+1)):0);
				out[i] = median(Arrays.copyOfRange(signal, start, end+1),padding);
			}
		}
		return out;
	}
	
	/**
	 * Compute median with padding zeroes
	 * @param signal 
	 * @param padding number of zeroes to pad
	 * @return median of values
	 */
	private double median(double signal[],int padding){
		double out = 0.0;
		LinkedList<Double> list = new LinkedList<Double>();
		for(int i=0;i<signal.length;i++)
			list.add(signal[i]);
		for(int i=0;i<padding;i++)
			list.add(0.0);
		Collections.sort(list);
		int len = list.size();
		if(len%2==0)
			out = (list.get(len/2)+list.get(len/2+1))/2;
		else
			out = list.get(len/2);
		return out;
	}
	
	/**
	 * Compute maximum in a given array range
	 * @param signal array of values
	 * @param start start index
	 * @param end end index excluded from search
	 * @return maximum value in array
	 */
	private double max(double signal[], int start, int end)
	{
		double max = -100000.0;
		for(int i=start;i<end && i<signal.length;i++)
			max = (signal[i]>max?signal[i]:max);
		return max;
	}
	
	/**
	 * Compute index of maximum in a given array range
	 * @param signal array of values
	 * @param start start index
	 * @param end end index excluded from search
	 * @return index of maximum value in array
	 */
	private int maxIndex(double signal[], int start, int end)
	{
		double max = -100000.0;
		int index = start;
		for(int i=start;i<end && i<signal.length;i++)
		{
			if(signal[i]>max)
			{
				max = signal[i];
				index = i;
			}
		}
		return index;
	}
	
	@SuppressWarnings("unused")
	private double min(double signal[], int start, int end)
	{
		double min = signal[start];
		for(int i=start;i<end && i<signal.length;i++)
			min = (signal[i]<min?signal[i]:min);
		return min;
	}
	
	private int minIndex(double signal[], int start, int end)
	{
		double min = signal[start];
		int index = start;
		for(int i=start;i<end && i<signal.length;i++)
		{
			if(signal[i]<min)
			{
				min = signal[i];
				index = i;
			}
		}
		return index;
	}
	
	/**
	 * Matlab style diff or shifted difference
	 * @param signal
	 * @return array of consecutive difference value
	 */
	private double[] diff(double signal[]){
		double out[] = new double[signal.length-1];
		for(int i=1;i<signal.length;i++)
			out[i-1] = signal[i]-signal[i-1];
		return out;
	}
	
	/**
	 * Matlab find(): index in array which has same value as {@code cmp}
	 * @param signal
	 * @param cmp
	 * @return array
	 */
	private Integer[] find(double signal[],int cmp)
	{
		LinkedList<Integer> list = new LinkedList<Integer>();
		for(int i=0;i<signal.length;i++)
			if((int)signal[i]==cmp) list.add(i);
		return list.toArray(new Integer[0]);
	}
	
	
	

}

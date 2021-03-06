package org.mstream.stream.ecg;

import java.io.BufferedWriter;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedList;

import org.mstream.stream.IStream;

import edu.umass.cs.sensors.utils.io.IOUtils;
import edu.umass.cs.sensors.utils.io.Logger;

/**
 * Detects PQRST peaks in each RR sample of ECG stream
 * <p>
 * Input Stream: {@link RRSmoothOperator}<br/>
 * Outputs to {@link ClinicalFeaturesOperator} 
 * <p>
 * ECG peak detection algorithm operates over a standard algorithm to detect local
 * maxima and minima. We adapt matlab implementation 
 * <a href="http://www.billauer.co.il/peakdet.html">peakdet.m</a> to Java.
 * 
 * @see <a href="http://www.billauer.co.il/peakdet.html">Local peak detection in Matlab</a>
 * 
 * @author Abhinav Parate
 */
public class RRAllPeaksDetectOperator implements IStream<ECGItem>{

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
	boolean DEBUG = false;


	/**
	 * Constructor for {@link RRAllPeaksDetectOperator}
	 * @param NSAMPLES number of interpolated points in an RR sample
	 */
	public RRAllPeaksDetectOperator(int NSAMPLES){
		this.NSAMPLES = NSAMPLES;
	}

	/**
	 * Default constructor uses 100 ecg samples for 1 RR sample
	 */
	public RRAllPeaksDetectOperator(){
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
		if(!verifiedNext)
			hasNext = readNext();
		if(!hasNext)
			print();
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
				//read next RR Sample
				success = readRRSample();
				if(!success)
				{	
					//Failed because no items left in stream
					verifiedNext = true;
					return false;
				}

				//Got data, check if we can interpolate
				success = rDetectPeaks();
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
	 * Reads <NSAMPLES> ecg samples as 1 RR sample and saves it in a data
	 * @return true if successfully read a sample
	 */
	private boolean readRRSample(){
		boolean success = true;
		validDataPoints = 0;
		ECGItem items[] = new ECGItem[NSAMPLES];
		data.clear();
		for(int i=0;i<NSAMPLES;i++) {
			while(success){
				if(child.hasNext()) 
				{
					ECGItem item = child.getNextItem();
					try{
						items[i] = item;
						data.add(item);
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
	 * Saves {@link ECGItem} containing timestamps with all the peak labels.
	 * Each record in the file has timestamp followed by raw ECG value, processed ECG value,
	 * and lastly, the label. A label can be P, Q, R, S, T or null.
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

	
	int failed[] = new int[6];

	/**
	 * Detects PQRST peaks
	 * @return true if smooth successful
	 */
	private boolean rDetectPeaks() {

		if(data.size()!=NSAMPLES) return false;
		
		
		final double ecg[] = new double[NSAMPLES];
		
		for(int i=0;i<NSAMPLES;i++)
		{
			ECGItem item = data.get(i);
			ecg[i] = item.getProcessedValue();
		}
		
		Integer peaks[][] = getAllPeakIndices(ecg, 0.1);
		//Add last point as maxima
		
		LinkedList<Integer> list = new LinkedList<Integer>();
		//Skip first maxima at index 0 which is R from previous RR sample
		for(int i=0;i<peaks[0].length;i++)
			if(peaks[0][i]!=0) list.add(peaks[0][i]);
		
		if(DEBUG)
			System.out.println(peaks[0].length+" "+peaks[1].length);
		//Add last sample as local maxima
		list.add(NSAMPLES-1);
		//We need at least 3 maxima
		if(list.size()<3){
			failed[0]++;
			return false;
		}
		
		Collections.sort(list, new Comparator<Integer>(){

			@Override
			public int compare(Integer arg0, Integer arg1) {
				Double c0 = ecg[arg0];
				Double c1 = ecg[arg1];
				return c0.compareTo(c1);
			}
		});
		//Select top 3 maximas
		/*while(list.size()>3) list.remove(); Collections.sort(list);*/
		//Alternative with 4 maximas
		//Select top 4 maximas
		while(list.size()>4)
			list.remove();
		
		Collections.sort(list);
		
		if(list.size()==4){
			//The extra maxima can be a small peak S' immediately after S and before T
			//or it can be a U peak.
			//Check if the first maxima is S'. Its height should be smaller than that of T 
			//or it's distance will be less than 10
			if(ecg[list.get(1)]-ecg[list.get(0)]>0.5 || list.get(0)<10)
				list.remove(0);
			else{
			//else second maxima is U between T and P || it is a small peak between P and Q
				if(list.get(2)>=85) //Small peak
					list.remove(2);
				else //U
					list.remove(1);
			}
		}
		
		Integer maxima[] = list.toArray(new Integer[0]);
		
		//Now get minimas
		list.clear();
		//Add all minimas
		for(int i=0;i<peaks[1].length;i++)
			list.add(peaks[1][i]);
		
		//We need exactly 2 minimas
		if(list.size()<2)
			return false;
		
		Collections.sort(list, new Comparator<Integer>(){
			@Override
			public int compare(Integer arg0, Integer arg1) {
				Double c0 = ecg[arg0];
				Double c1 = ecg[arg1];
				return c0.compareTo(c1);
			}
		});
		
		//Select 2 minimas
		while(list.size()>2)
			list.removeLast();
		Collections.sort(list);
		Integer minima[] = list.toArray(new Integer[0]);
		int T=0,P=1,R=2;
		int S=0,Q=1;
		
		//We expect to have 4 maximas: 1 prev R, 1 P, 1 T and 1 R
		//We expect to have 2 minimas: 1 S 1 Q
		//What we should see is R S T P Q R

//		System.out.println("S:"+minima[S]+" T:"+maxima[T]+" P:"+maxima[P]+" Q:"+minima[Q]+" R:"+maxima[R]);
//		String s = "All maxima:";
//		for(int i=0;i<maxima.length;i++)
//			s += (" "+maxima[i]+" "+ecg[maxima[i]]);
//		s+="\nAll minima:";
//		for(int i=0;i<minima.length;i++)
//			s += (" "+minima[i]+" "+ecg[minima[i]]);
//		System.out.println(s);
			
		
		
		//T follows S i.e T>S
		if(maxima[T]<minima[S]) {
			failed[1]++;
			return false;
		}
		//P follows T i.e. P>T
		if(maxima[P]<maxima[T]) {
			failed[2]++;
			return false;
		}
		//Q follows P i.e Q>P
		if(minima[Q]<maxima[P]) {
			failed[3]++;
			return false;
		}
		//R follows Q i.e. R>Q
		if(maxima[R]<minima[Q]) {
			failed[4]++;
			return false;
		}
		//T from previous R >=20 i.e T>=20
		if(maxima[T]<20) {
			failed[5]++;
			return false;
		}
		
		//Now, we only have qualified samples
		//Clear old labels obtained at step 1
		for(int i=0;i<data.size();i++)
			data.get(i).setLabel(null);
		//Set Labels now
		data.get(maxima[P]).setLabel("P");
		data.get(minima[Q]).setLabel("Q");
		data.get(maxima[R]).setLabel("R");
		data.get(minima[S]).setLabel("S");
		data.get(maxima[T]).setLabel("T");
		
		//Finished
		return true;
	}

	private void print(){
		if(!DEBUG) return;
		String s = "";
		for(int i=0;i<failed.length;i++)
			s+= (" Case "+i+" "+failed[i]);
		System.out.println(s);
	}
	
	/**
	 * Get all local maxima and minima indices
	 * @param values array of samples
	 * @param delta minimum threshold
	 * @return m[][] where m[0] has maximas and m[1] has minimas
	 */
	private Integer[][] getAllPeakIndices(double values[], double delta)
	{
		LinkedList<Integer> maxList = new LinkedList<Integer>();
		LinkedList<Integer> minList = new LinkedList<Integer>();
		double min = Double.POSITIVE_INFINITY;
		double max = Double.NEGATIVE_INFINITY;
		
		int minPos=-1,maxPos=-1;
		boolean lookForMax = true;
		
		for(int i=0;i<values.length;i++)
		{
			double val = values[i];
			if(val>max) {
				max = val;
				maxPos = i;
			}
			if(val<min) {
				min = val;
				minPos = i;
			}
			
			if(lookForMax)
			{
				if(val<(max-delta)) {
					maxList.add(maxPos);
					min = val;
					minPos = i;
					lookForMax = false;
				}
			} else {
				if(val>(min+delta)) {
					minList.add(minPos);
					max = val;
					maxPos = i;
					lookForMax = true;
				}
			}
		}
		
		Integer out[][] = new Integer[2][];
		out[0] = maxList.toArray(new Integer[0]);
		out[1] = minList.toArray(new Integer[0]);
		
		if(DEBUG) {
			maxList.addAll(minList);
			Collections.sort(maxList);
			String s = "";
			for(int i=0;i<maxList.size();i++)
				s+= (" "+maxList.get(i)+" "+values[maxList.get(i)]);
			System.out.println(s);
		}
		
		return out;
	}


}

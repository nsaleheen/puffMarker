package org.mstream.stream.eda;

import java.io.BufferedWriter;
import java.util.Collections;
import java.util.LinkedList;

import org.mstream.stream.IStream;
import org.mstream.stream.file.LowPassFilter;
import org.mstream.stream.items.IStreamItem;

import edu.umass.cs.sensors.utils.io.IOUtils;
import edu.umass.cs.sensors.utils.io.Logger;

/**
 * Extracts SCRs from the input EDA stream and computes activity levels if data available
 * <p>
 * Input Stream: {@link LowPassFilter}<br/>
 * <p>
 * EDA SCR extraction algorithm
 * 
 * @author Abhinav Parate
 */
public class EDASCROnsetOperator implements IStream<EDAItem>{

	/**
	 * Buffer for EDA values
	 */
	private LinkedList<IStreamItem> data = new LinkedList<IStreamItem>();
	private EDAItem outData[] = null;

	private int currentIndex = -1;
	private int RAW_EDA_INDEX = 5;
	private int SMOOTH_EDA_INDEX = 6;
	private int X_INDEX = -1;
	private int Y_INDEX = -1;
	private int Z_INDEX = -1;
	private boolean activityAvail = false;
	private int SAMPLE_RATE = 8;


	//Variables for tracking next item
	private boolean verifiedNext = false;
	private boolean hasNext = false;
	private int validDataPoints = -1;
	private int NSAMPLES = 10000;

	private IStream<IStreamItem> child = null;
	boolean DEBUG = false;


	/**
	 * Constructor for {@link EDASCROnsetOperator}
	 * @param SAMPLE_RATE the sampling rate of the EDA stream
	 * @param RAW_EDA_INDEX the index of the column where raw EDA value is available. Set to -1 if unavailable.
	 * @param SMOOTH_EDA_INDEX the index of the column where smooth EDA value is available. Should be &geq; 0
	 * @param X_INDEX index of the column where acceleration along x-axis is available. Set to -1 if unavailable
	 * @param Y_INDEX index of the column where acceleration along y-axis is available. Set to -1 if unavailable
	 * @param Z_INDEX index of the column where acceleration along z-axis is available. Set to -1 if unavailable
	 */
	public EDASCROnsetOperator(int SAMPLE_RATE,int RAW_EDA_INDEX, int SMOOTH_EDA_INDEX, int X_INDEX, int Y_INDEX, int Z_INDEX){
		this.RAW_EDA_INDEX = RAW_EDA_INDEX;
		this.SMOOTH_EDA_INDEX = SMOOTH_EDA_INDEX;
		this.SAMPLE_RATE = SAMPLE_RATE;
		this.X_INDEX = X_INDEX;
		this.Y_INDEX = Y_INDEX;
		this.Z_INDEX = Z_INDEX;
		activityAvail = (X_INDEX!=-1) && (Y_INDEX!=-1) && (Z_INDEX!=-1);
	}




	/**
	 * Returns next {@link IStreamItem}
	 * @see org.mstream.stream.IStream#getNextItem()
	 **/
	@Override
	public EDAItem getNextItem() {
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
	 * Add one child stream implementing {@code IStream<IStreamItem>}
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
		if(!verifiedNext)
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
			if(outData[currentIndex]!=null)
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
				success = readNSamples();
				if(!success)
				{	
					//Failed because no items left in stream
					verifiedNext = true;
					return false;
				}

				//Got data, check if we can interpolate
				success = rDetectOnsets();
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
	private boolean readNSamples(){
		boolean success = true;
		validDataPoints = 0;
		IStreamItem items[] = new IStreamItem[NSAMPLES];
		data.clear();
		for(int i=0;i<NSAMPLES;i++) {
			while(success){
				if(child.hasNext()) 
				{
					IStreamItem item = child.getNextItem();
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


	private EDAItem seekNextItem()
	{
		EDAItem item = outData[currentIndex];
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
	 * Saves interpolated stream with timestamps and R,S peaks
	 * @see org.mstream.stream.IStream#saveStreamToFile(java.lang.String)
	 **/
	@Override
	public void saveStreamToFile(String filePath) {
		BufferedWriter bw = IOUtils.getWriter(filePath);
		while(hasNext())
		{
			EDAItem item = getNextItem();
			IOUtils.writeLine(item.toString(), bw);
		}
		IOUtils.close(bw);
	}



	/**
	 * Detects SCR onsets
	 * @return true if successful
	 */
	private boolean rDetectOnsets() {

		if(data.size()!=NSAMPLES) return false;

		double eda[] = new double[NSAMPLES];
		for(int i=0;i<NSAMPLES;i++)
		{
			IStreamItem item = data.get(i);
			eda[i] = item.getValueAsDouble(SMOOTH_EDA_INDEX);
		}

		LinkedList<Integer> minimaIndices = new LinkedList<Integer>();
		LinkedList<Integer> firstThresholdIndices = new LinkedList<Integer>();

		double THRESHOLD_FIRST = 0.002;
		double THRESHOLD_SECOND = 0.005;

		/**
		 * Steps:
		 * 1. Identify points of local minima and points of inflexion.
		 * 2. Check if the EDA level rises above threshold in 1 sec due to SCR. Mark this point as firstThreshold.
		 * 3. Accept point as the possible onset of SCR.
		 */

		for(int i=1;i<eda.length-1;i++){
			boolean isOnsetPoint = false;

			//Check if it is the point of inflection
			double slope0 = eda[i]-eda[i-1];
			double slope1 = eda[i+1]-eda[i];
			if(2*slope0<slope1 || (slope0<0 && slope1>0))
				isOnsetPoint=true;

			//Criteria 1: Minimum rise in 1sec is THRESHOLD_1SEC
			for(int j=i;j<i+SAMPLE_RATE && j<eda.length && isOnsetPoint;j++)
			{
				if((eda[j]-eda[i])>=THRESHOLD_FIRST)
				{
					minimaIndices.add(i);
					firstThresholdIndices.add(j);
					break;
				}
			}
		}

		Integer minimas[] = minimaIndices.toArray(new Integer[0]);
		Integer firstThresholdIndex[] = firstThresholdIndices.toArray(new Integer[0]);
		Integer amplitudeIndex[] =  new Integer[minimas.length];

		/**
		 * - Now, check if the EDA level increases beyond second threshold 
		 * before next minima and within next INTERVAL seconds.
		 * - If it does not, remove this point as the point of SCR onset
		 */
		int INTERVAL = 8;
		for(int i=0;i<minimas.length;i++) 
		{
			Integer indx1sec = firstThresholdIndex[i]; amplitudeIndex[i] = null;

			//Checking if EDA level rises beyond threshold in INTERVAL seconds
			for(int j=indx1sec;j<minimas[i]+(int)(INTERVAL*SAMPLE_RATE)&&j<eda.length;j++)
			{
				if((eda[j]-eda[minimas[i]])>=THRESHOLD_SECOND)
				{
					amplitudeIndex[i] = j;
					break;
				}
			}
		}
		minimaIndices.clear();
		/**
		 * Re-creating list of on-set/minima points with only points that satisfy second threshold criterion.
		 */
		for(int i=0;i<minimas.length-1;i++)
		{
			//If amp is found after the next minima, discard that amplitude and minima from consideration
			if(amplitudeIndex[i]!=null && amplitudeIndex[i]>=minimas[i+1])
				amplitudeIndex[i]=null;
			if(amplitudeIndex[i]!=null){
				minimaIndices.add(minimas[i]);
			}
		}
		minimas = minimaIndices.toArray(new Integer[0]);

		/**
		 * Find amplitude, rise time and half recovery time.
		 * - Amplitude should appear before next minima and within INTERVAL seconds.
		 * - Rise time is the time it takes to reach amplitude.
		 * - Half recovery time should appear before next minima but may not be seen due to another SCR.
		 * - Extrapolate for HRT if another SCR appears before earlier SCR could recover.
		 */

		Double amplitude[] = new Double[minimas.length];
		amplitudeIndex = new Integer[minimas.length];
		Integer halfRecoveryIndex[] = new Integer[minimas.length];

		INTERVAL = 12;

		for(int i=0;i<minimas.length-1;i++)
		{	
			int start = minimas[i]; int end = minimas[i+1];
			if((end-start)>INTERVAL*SAMPLE_RATE)
				end = start+INTERVAL*SAMPLE_RATE;
			amplitude[i] = Double.NEGATIVE_INFINITY;
			amplitudeIndex[i] = null;
			for(int j=start;j<end;j++)
			{
				if(eda[j]>amplitude[i])
				{
					amplitude[i] = eda[j]; amplitudeIndex[i] = j; 
				}
			}
			if(amplitudeIndex[i]!=null) {
				//Check for half recovery time
				start = amplitudeIndex[i]+1;
				double amp = (amplitude[i]-eda[minimas[i]]);
				halfRecoveryIndex[i] = null;
				for(int j=start; j<end && j<eda.length;j++)
				{
					if(eda[j]<=(eda[minimas[i]]+amp/2))
					{
						halfRecoveryIndex[i] = j;//-minimas[i];
						break;
					}
				}
				amplitude[i] -= eda[minimas[i]];
				if(halfRecoveryIndex[i]==null)
				{
					//y1-y2 = amp/2 = m(x1-x2) => m*x2 = m*x1-amp/2 //Extrapolate to point of half recovery
					//double slope = (eda[end-1]-eda[start])/(end-1-start);
					halfRecoveryIndex[i] = (int)(start-(amp*(end-1-start))/
							(2*(eda[end-1]-eda[start])) 
							);
					if(halfRecoveryIndex[i]<0) halfRecoveryIndex[i] = null;
					//System.out.println(EDA_INDEX+" "+minimas[i]+" "+halfRecoveryIndex[i]);
					//else
					//data.get(halfRecoveryIndex[i]).values[EDA_INDEX] = eda[minimas[i]]+amp/2;
				}
				//amplitudeIndex[i] -= minimas[i];
				//if(halfRecoveryTimeInSamples[i]==null)
				//minimas[i] = null;
			}//else minimas[i]=null;

		}

		EDAItem eitems[] = new EDAItem[data.size()];
		for(int i=0;i<data.size();i++){
			IStreamItem item = data.get(i);
			double smoothEda = item.getValueAsDouble(SMOOTH_EDA_INDEX);
			double rawEda = smoothEda;
			if(RAW_EDA_INDEX!=-1)
				rawEda = item.getValueAsDouble(RAW_EDA_INDEX);
			double activity = 0.0;
			if(activityAvail) {
				try{
					double x = item.getValueAsDouble(X_INDEX);
					double y = item.getValueAsDouble(Y_INDEX);
					double z = item.getValueAsDouble(Z_INDEX);
					activity = Math.sqrt(Math.pow(x,2)
							+ Math.pow(y,2)+ Math.pow(z,2));
				}catch(Exception e){
					System.out.println("WARNING: Null values for activity");
					e.printStackTrace();
					//Exceptions may occur if for some reason values are null.
					//This occurs in raw eda data where ',,,,' is seen sometimes
					activity = 0.0;
				}
			}

			EDAItem eitem = new EDAItem(item.timeStamp);
			eitem.setValues(rawEda, smoothEda, activity,null);
			eitems[i] = eitem;
		}

		for(int i=0;i<minimas.length;i++){
			if(minimas[i]==null)
				continue;
			if(eda[minimas[i]]<=0.09) continue;
			EDAItem onsetItem = eitems[minimas[i]];
			onsetItem.setLabel("O"); if(i==minimas.length-1) onsetItem.setLabel("O1");
			if(i!=minimas.length-1) {
				if(amplitudeIndex[i]!=null)
				{
					eitems[amplitudeIndex[i]].setLabel("P");
					onsetItem.setValue(EDAItem.AMPLITUDE_INDEX, amplitude[i]);
					onsetItem.setValue(EDAItem.RISETIME_INDEX, (amplitudeIndex[i]-minimas[i])*1.0/SAMPLE_RATE);

				}
				Integer halfRecovery = halfRecoveryIndex[i];
				if(halfRecovery!=null && halfRecovery<minimas[i+1]) 
				{
					eitems[halfRecoveryIndex[i]].setLabel("H");
				}
				if(halfRecovery!=null)
					onsetItem.setValue(EDAItem.HALFRECOVERY_INDEX, (halfRecovery-minimas[i])*1.0/SAMPLE_RATE);
			}
		}
		outData = eitems;

		//Finished
		return true;
	}

	/**
	 * Get all local maxima and minima indices
	 * @param values array of samples
	 * @param deltaMax maximum threshold
	 * @param deltaMin minimum threshold
	 * @return m[][] where m[0] has maximas and m[1] has minimas
	 */
	@SuppressWarnings("unused")
	private Integer[][] getAllPeakIndices(double values[], double deltaMax, double deltaMin)
	{
		LinkedList<Integer> maxList = new LinkedList<Integer>();
		LinkedList<Integer> minList = new LinkedList<Integer>();
		double min = Double.POSITIVE_INFINITY;
		double max = Double.NEGATIVE_INFINITY;

		//TODO: delataMax and deltaMin are not used.
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
				if(val<(max-deltaMin)) {
					maxList.add(maxPos);
					min = val;
					minPos = i;
					lookForMax = false;
				}
			} else {
				if(val>(min+deltaMax)) {
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

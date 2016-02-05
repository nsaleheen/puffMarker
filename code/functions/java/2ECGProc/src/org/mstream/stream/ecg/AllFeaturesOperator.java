package org.mstream.stream.ecg;

import java.io.BufferedWriter;
import java.util.LinkedList;

import org.mstream.stream.IStream;
import org.mstream.stream.items.DoubleValuesItem;

import edu.umass.cs.sensors.utils.io.IOUtils;
import edu.umass.cs.sensors.utils.io.Logger;

/**
 * ECG Feature Extractor to get clinical and waveform features in each annotated RR sample.
 * <p>
 * The output stream contains items with NSAMPLES+6 values in it where NSAMPLES has a default value of 100.
 * NSAMPLES is the number of interpolated points in a standardized fixed-size waveform/RR sample. 
 * The first NSAMPLES values in each output item correspond to the Waveform features.
 * The next 6 values are the clinical features in the given order:
 * <ol>
 * <li><b>RR:</b> The RR interval in seconds </li>
 * <li><b>QT:</b> The QT distance is given as difference between index of T and index of Q in the fixed size
 * standardized R-R waveform </li>
 * <li><b>QTc:</b> The QTc feature in seconds </li>
 * <li><b>PR:</b> The PR distance is given as difference between index of R and index of P in the fixed size
 * standardized R-R waveform </li>
 * <li><b>QRS:</b> The QRS distance is given as difference between index of S and index of Q in the fixed size
 * standardized R-R waveform </li>
 * <li><b>TH:</b> The height of peak in T wave of the standardized waveform </li>
 * </ol>
 * 
 * 
 * <p>
 * Input Stream: {@link RRAllPeaksDetectOperator}<br/>
 * 
 * @author Abhinav Parate
 */
public class AllFeaturesOperator implements IStream<DoubleValuesItem>{

	/**
	 * Buffer for ECG values
	 */
	private LinkedList<ECGItem> inData = new LinkedList<ECGItem>();
	private LinkedList<DoubleValuesItem> outData = new LinkedList<DoubleValuesItem>();

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
	 * Constructor for {@link AllFeaturesOperator}
	 * @param NSAMPLES number of interpolated points in an RR sample
	 */
	public AllFeaturesOperator(int NSAMPLES){
		this.NSAMPLES = NSAMPLES;
	}

	/**
	 * Default constructor uses 100 ecg samples for 1 RR sample
	 */
	public AllFeaturesOperator(){
		NSAMPLES = 100;
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
				//read next RR Sample
				success = readRRSample();
				if(!success)
				{	
					//Failed because no items left in stream
					verifiedNext = true;
					return false;
				}

				//Got data, check if we can interpolate
				success = rExtractFeatures();
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
		inData.clear();
		for(int i=0;i<NSAMPLES;i++) {
			while(success){
				if(child.hasNext()) 
				{
					ECGItem item = child.getNextItem();
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
			} //Got ECG Item
		}//Got 100 items
		if(validDataPoints != NSAMPLES)
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
	 * Saves feature vectors with timestamps. The feature vectors contain
	 * <ol> 
	 * <li>waveform features (first NSAMPLES features in the vector) </li>
	 * <li><b>RR:</b> The RR interval in seconds </li>
	 * <li><b>QT:</b> The QT distance is given as difference between index of T and index of Q in the fixed size
	 * standardized R-R waveform </li>
	 * <li><b>QTc:</b> The QTc feature in seconds </li>
	 * <li><b>PR:</b> The PR distance is given as difference between index of R and index of P in the fixed size
	 * standardized R-R waveform </li>
	 * <li><b>QRS:</b> The QRS distance is given as difference between index of S and index of Q in the fixed size
	 * standardized R-R waveform </li>
	 * <li><b>TH:</b> The height of peak in T wave of the standardized waveform </li>
	 * </ol>
	 * @see org.mstream.stream.IStream#saveStreamToFile(java.lang.String)
	 **/
	@Override
	public void saveStreamToFile(String filePath) {
		BufferedWriter bw = IOUtils.getWriter(filePath);
		String header = "W0";
		for(int i=1;i<NSAMPLES;i++)
			header += (",W"+i);
		header += ",RR,QT,QTc,PR,QRS,TH";
		IOUtils.writeLine(header, bw);
		while(hasNext())
		{
			DoubleValuesItem item = getNextItem();
			IOUtils.writeLine(item.toString(), bw);
		}
		IOUtils.close(bw);
	}


	/**
	 * Extracts All Features
	 * @return true if smooth successful
	 */
	private boolean rExtractFeatures() {

		outData.clear();
		if(inData.size()!=NSAMPLES) return false;

		Double vals[] = new Double[NSAMPLES+6];
		long timestamp[]=new long[NSAMPLES+6];
		int P=-1,Q=-1,R=-1,S=-1,T=-1;
		for(int i=0;i<NSAMPLES;i++)
		{
			String label = inData.get(i).getLabel();
			vals[i] = inData.get(i).getProcessedValue();
			timestamp[i]=inData.get(i).timeStamp;
			if(label!=null) {
				if(label.equals("P"))
					P = i;
				else if(label.equals("Q"))
					Q = i;
				else if(label.equals("R"))
					R = i;
				else if(label.equals("S"))
					S = i;
				else if(label.equals("T"))
					T = i;
			}
		}

		//Following is unlikely to happen
		if((P==-1) || (Q==-1) || (R==-1) || (S==-1) || (T==-1))
			return false;

		double RR = (inData.getLast().timeStamp- inData.getFirst().timeStamp)/1000.0;
//		double QT = (R-Q)+T;
//		double QTc = QT*Math.sqrt(RR);
//		double PR = (R-P);
//		double QRS = (R-Q)+S;
		double TH = inData.get(T).getProcessedValue();

		
		double QT = (timestamp[Q]-timestamp[T])/1000.0;
		double QTc = QT*Math.sqrt(RR);
		double PR = (timestamp[R]-timestamp[P])/1000.0;
		double QRS = (timestamp[Q]-timestamp[S])/1000.0;
		
		
		vals[NSAMPLES] = RR;
		vals[NSAMPLES+1] = QT;
		vals[NSAMPLES+2] = QTc;
		vals[NSAMPLES+3] = PR;
		vals[NSAMPLES+4] = QRS;
		vals[NSAMPLES+5] = TH;


		DoubleValuesItem item = new DoubleValuesItem(inData.getFirst().timeStamp,vals);
		outData.add(item);

		//Finished
		return true;
	}

}

package org.mstream.stream.accelerometer;

import java.io.BufferedWriter;
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
public class StepsExtractor implements IStream<IStreamItem>{

	/**
	 * Buffer for EDA values
	 */
	private LinkedList<IStreamItem> data = new LinkedList<IStreamItem>();
	private IStreamItem outData[] = null;

	private int currentIndex = -1;
	private int X_INDEX = -1;
	private int Y_INDEX = -1;
	private int Z_INDEX = -1;


	//Variables for tracking next item
	private boolean verifiedNext = false;
	private boolean hasNext = false;
	private int validDataPoints = -1;
	private int NSAMPLES = 50;

	private IStream<IStreamItem> child = null;
	boolean DEBUG = false;


	/**
	 * Constructor for {@link StepsExtractor}
	 * @param X_INDEX index of the column where acceleration along x-axis is available. Set to -1 if unavailable
	 * @param Y_INDEX index of the column where acceleration along y-axis is available. Set to -1 if unavailable
	 * @param Z_INDEX index of the column where acceleration along z-axis is available. Set to -1 if unavailable
	 */
	public StepsExtractor(int X_INDEX, int Y_INDEX, int Z_INDEX){
		this.X_INDEX = X_INDEX;
		this.Y_INDEX = Y_INDEX;
		this.Z_INDEX = Z_INDEX;
	}




	/**
	 * Returns next {@link IStreamItem}
	 * @see org.mstream.stream.IStream#getNextItem()
	 **/
	@Override
	public IStreamItem getNextItem() {
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
				success = rDetectSteps();
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


	private IStreamItem seekNextItem()
	{
		IStreamItem item = outData[currentIndex];
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
			IStreamItem item = getNextItem();
			IOUtils.writeLine(item.toString(), bw);
		}
		IOUtils.close(bw);
	}


	private boolean searchRegulation = true;
	private int countSteps = 0;
	private long lastStepTime = -1L;

	/**
	 * Detects SCR onsets
	 * @return true if successful
	 */
	private boolean rDetectSteps() {

		if(data.size()!=NSAMPLES) return false;

		double acc[][] = new double[3][NSAMPLES]; //acc[0]=x,acc[1]=y, acc[2]=z
		int X=0,Y=1,Z=2;
		double minX = Double.POSITIVE_INFINITY, minY = Double.POSITIVE_INFINITY, minZ = Double.POSITIVE_INFINITY;
		double maxX = Double.NEGATIVE_INFINITY, maxY = Double.NEGATIVE_INFINITY, maxZ = Double.NEGATIVE_INFINITY;
		for(int i=0;i<NSAMPLES;i++)
		{
			IStreamItem item = data.get(i);
			acc[X][i] = item.getValueAsDouble(X_INDEX);
			acc[Y][i] = item.getValueAsDouble(Y_INDEX);
			acc[Z][i] = item.getValueAsDouble(Z_INDEX);
			minX = (acc[X][i]<minX?acc[X][i]:minX);
			minY = (acc[Y][i]<minY?acc[Y][i]:minY);
			minZ = (acc[Z][i]<minZ?acc[Z][i]:minZ);
			maxX = (acc[X][i]>maxX?acc[X][i]:maxX);
			maxY = (acc[Y][i]>maxY?acc[Y][i]:maxY);
			maxZ = (acc[Z][i]>maxZ?acc[Z][i]:maxZ);
		}
		double deltaX = maxX-minX;
		double deltaY = maxY-minY;
		double deltaZ = maxZ-minZ;
		//Identify max Delta axis and corresponding dynamic threshold
		int maxDeltaAxis = X;
		double maxDelta = (maxX-minX);
		double dynamicThreshold = (maxX+minX)/2;
		if(deltaZ>deltaY && deltaZ>deltaX){ maxDeltaAxis = Z; dynamicThreshold = (maxZ+minZ)/2; maxDelta = maxZ-minZ;}
		else if(deltaY>deltaZ && deltaY>deltaX){ maxDeltaAxis = Y; dynamicThreshold = (maxY+minY)/2; maxDelta = maxY-minY;}
		System.out.println("AXIS: "+maxDeltaAxis+"\t Threshold:"+maxDelta);
		boolean stepIndexList[] = new boolean[NSAMPLES];
		for(int i=0;i<NSAMPLES;i++)
			stepIndexList[i] = false;
		
		
		for(int i=1;i<NSAMPLES;i++) {
			if(acc[maxDeltaAxis][i]<dynamicThreshold && acc[maxDeltaAxis][i-1]>=dynamicThreshold){
				//Potentially a step
				long time = data.get(i).timeStamp;
				if(lastStepTime==-1 || (time-lastStepTime)>5000) 
					lastStepTime=time;
				//Check Time window (0.2s to 2s)
				if((time-lastStepTime)>2000 || (time-lastStepTime)<400) {
					//Failed timing test
					if(searchRegulation) {
						//If already in search regulation mode, discard previous counted steps
						for(int j=i-1;j>=0 && countSteps>0;j--) {
							if(stepIndexList[j] == true) {
								stepIndexList[j] = false;
								countSteps--;
							}
						}
					} else {
						//enter search regulation mode
						searchRegulation = true;
						countSteps = 0;
					}
				} else {
					//valid step as far as we know from current observations
					stepIndexList[i] = true;
					if(searchRegulation && countSteps>=3) {
						searchRegulation = false;
					}
					countSteps++;
					lastStepTime = time;
					//will be discarded later if it is still in search regulation mode
				}
			}
		}
		
		IStreamItem eitems[] = new IStreamItem[data.size()];
		for(int i=0;i<data.size();i++) {
			IStreamItem item = data.get(i);
			IStreamItem eitem = new IStreamItem();
			eitem.setTimestamp(item.timeStamp);
			eitem.setEmptyValues(5);
			eitem.setValue(0, item.getValueAsObject(0));
			eitem.setValue(1, item.getValueAsObject(1));
			eitem.setValue(2, item.getValueAsObject(2));
			String label = (stepIndexList[i]?"X":null);
			eitem.setValue(3, label);
			eitem.setValue(4, dynamicThreshold);
			eitems[i] = eitem;
		}
		outData = eitems;
		//Finished
		return true;
	}


}

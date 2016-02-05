package org.mstream.stream.accelerometer;

import java.io.BufferedWriter;

import org.mstream.stream.IStream;
import org.mstream.stream.file.SVFileStream;
import org.mstream.stream.items.DoubleValuesItem;
import org.mstream.stream.items.StringValuesItem;

import edu.umass.cs.sensors.utils.io.IOUtils;
import edu.umass.cs.sensors.utils.io.Logger;

/**
 * A stream to read accelerometer values and convert to activity level
 * 
 * @author aparate
 */
public class ActivityStream implements IStream<DoubleValuesItem>{


	
	/**
	 * The next item to be returned
	 */
	private DoubleValuesItem nextItem = null;

	/**
	 * Variable to check if there is another item
	 */
	private boolean verifiedNext = false;
	private boolean hasNext = false;
	
	private int xIndex = -1;
	private int yIndex = -1;
	private int zIndex =  -1; 
	private int postureIndex = -1;
	
	/**
	 * Child SVFileStream
	 */
	private IStream<StringValuesItem> child = null;
	

	
	/**
	 * Constructor for ActivityStream
	 */
	public ActivityStream(int xIndex, int yIndex, int zIndex, int postureIndex){
		this.xIndex = xIndex;
		this.yIndex = yIndex;
		this.zIndex = zIndex;
		this.postureIndex = postureIndex;
	}

	
	/**
	 * Returns next {@link DoubleValuesItem} with activity value in it.
	 * @see org.mstream.stream.IStream#getNextItem()
	 **/
	@Override
	public DoubleValuesItem getNextItem() {
		if(verifiedNext && hasNext){
			verifiedNext = false;
			return nextItem;
		} 
		else if(!verifiedNext) 
		{
			hasNext = readNext();
			verifiedNext = false;
			if(hasNext)
				return nextItem;
		}
		return null;
	}

	/** 
	 * Add a single {@link SVFileStream} as child
	 * @see org.mstream.stream.IStream#addChildStreams(org.mstream.stream.IStream[])
	 **/
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public void addChildStreams(IStream... streams) {
		for(IStream stream: streams)
		{
			//if(!(stream instanceof EDAFileStream))
				//continue;
			child = (IStream<StringValuesItem>)stream;
		}
	}

	@Override
	public boolean hasNext(){
		if(verifiedNext)
			return hasNext;
		hasNext = readNext();
		return hasNext;
	}
	
	/* (non-Javadoc)
	 * @see org.istream.stream.IStream#closeStream()
	 */
	@Override
	public void closeStream() {
		
		child.closeStream();
		verifiedNext = true;
		hasNext = false;
		nextItem = null;
	}

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
		if(!child.hasNext())
		{
			verifiedNext = true;
			return false;
		}
		//Loop till we get next item
		while(true) {
			if(child.hasNext()) 
			{
				StringValuesItem item = child.getNextItem();
				try{
					nextItem = parseItem(item);
					verifiedNext = true;
					return true;
				} catch(Exception e){
					Logger.error(e.getLocalizedMessage());
					continue;
				}
			}
			else {
				verifiedNext = true;
				return false;
			}
		}
		//Completed reading next
	}
	
	

	/**
	 * Parse {@link DoubleValuesItem} from the {@link StringValuesItem}
	 * <p>Creates an item array with activity value in it.
	 * @param item input string values item
	 */
	private DoubleValuesItem parseItem(StringValuesItem item) {

		//double vertical = Math.abs(item.getValueAsDouble(xIndex));
		//vertical = Math.abs(1.0-vertical);
		
//		double activity = Math.pow(item.getValueAsDouble(xIndex),2)
//				+ Math.pow(item.getValueAsDouble(yIndex),2)
//				+ Math.pow(item.getValueAsDouble(zIndex),2);
//		activity = Math.sqrt(activity);
//		activity = Math.abs(1-activity);
//		activity = Math.abs(1-Math.abs(item.getValueAsDouble(xIndex))); //Only vertical acceleration
//		activity = Math.min(activity, Math.abs(1-activity));
		double x = Math.max(Math.abs(item.getValueAsDouble(xIndex)), Math.abs(item.getValueAsDouble(xIndex-1)));
		double y = Math.max(Math.abs(item.getValueAsDouble(yIndex)), Math.abs(item.getValueAsDouble(yIndex-1)));
		double z = Math.max(Math.abs(item.getValueAsDouble(zIndex)), Math.abs(item.getValueAsDouble(zIndex-1)));
		double activity = Math.sqrt(x*x+y*y+z*z);
		activity = Math.min(activity, Math.abs(1-activity));
		double posture = item.getValueAsDouble(postureIndex);
		if(Math.abs(posture)>=30.0) activity = 0.0;
		//Vertical
		double gComp = Math.cos(Math.PI*posture/180.0);
		double activityVert = Math.max(Math.abs(item.getValueAsDouble(xIndex)+gComp), Math.abs(item.getValueAsDouble(xIndex-1)+gComp));
		return new DoubleValuesItem(item.timeStamp,new Double[]{activity,activityVert,posture});
	}

	/**
	 * ActivityStream saves stream with timestamps
	 * @see org.mstream.stream.IStream#saveStreamToFile(java.lang.String)
	 **/
	@Override
	public void saveStreamToFile(String filePath) {
		BufferedWriter bw = IOUtils.getWriter(filePath);
		while(hasNext())
		{
			DoubleValuesItem item = getNextItem();
			IOUtils.writeLine(item.toString(), bw);
		}
		IOUtils.close(bw);
		
	}

}

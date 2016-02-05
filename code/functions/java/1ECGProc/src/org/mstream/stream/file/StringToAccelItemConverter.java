package org.mstream.stream.file;

import java.io.BufferedWriter;

import org.mstream.stream.IStream;
import org.mstream.stream.items.AccelValuesItem;
import org.mstream.stream.items.StringValuesItem;

import edu.umass.cs.sensors.utils.io.IOUtils;
import edu.umass.cs.sensors.utils.io.Logger;

/*
 * Operator to convert StringValuesItem stream to AccelValuesItem stream
 */

public class StringToAccelItemConverter implements IStream<AccelValuesItem>{

	/*
	 * Child stream with AccelValuesItem
	 */
	private IStream<StringValuesItem> child = null;
	
	private static int LABEL_INDEX = -1;
	private static int X_INDEX = 0;
	private static int Y_INDEX = 1;
	private static int Z_INDEX = 2;
	private static int ORT_X_INDEX = -1;
	private static int ORT_Y_INDEX = -1;
	private static int ORT_Z_INDEX = -1;
	
	//Variables to track Next item
	private AccelValuesItem nextItem = null;
	private boolean verifiedNext = false;
	private boolean hasNext = false;

	/*
	 * Constructor for StringToAccelItemConverter
	 */
	public StringToAccelItemConverter(){
		
	}
	
	/*
	 * Constructor for StringToAccelItemConverter which allows you to specify the index of
	 * the x, y, and z accelerometer values
	 */
	
	public StringToAccelItemConverter(int xIndex, int yIndex, int zIndex){
		X_INDEX = xIndex;
		Y_INDEX = yIndex;
		Z_INDEX = zIndex;
	}
	
	public StringToAccelItemConverter(int xIndex, int yIndex, int zIndex, int labelIndex){
		X_INDEX = xIndex;
		Y_INDEX = yIndex;
		Z_INDEX = zIndex;
		LABEL_INDEX = labelIndex;
	}
	
	public StringToAccelItemConverter(int xIndex, int yIndex, int zIndex, int ortxIndex,int ortyIndex,int ortzIndex, int labelIndex){
		X_INDEX = xIndex;
		Y_INDEX = yIndex;
		Z_INDEX = zIndex;
		ORT_X_INDEX = ortxIndex;
		ORT_Y_INDEX = ortyIndex;
		ORT_Z_INDEX = ortzIndex;
		LABEL_INDEX = labelIndex;
	}
	
	public void setLabelIndex(int index){
		LABEL_INDEX = index;
	}
	
	/*
	 * Returns next AccelValuesItem
	 * @see org.mstream.stream.IStream#getNextItem()
	 */
	@Override
	public AccelValuesItem getNextItem() {
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

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public void addChildStreams(IStream... streams) {
		for(IStream stream: streams)
		{	
			child = (IStream<StringValuesItem>)stream;
		}
	}

	@Override
	public boolean hasNext() {
		if(verifiedNext)
			return hasNext;
		hasNext = readNext();
		return hasNext;
	}

	/*
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
					parseItem(item);
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

	/*
	 * Parses the StringValuesItem into an AccelValuesItem
	 */
	private void parseItem(StringValuesItem item){
		Object[] vals = null;
		
		if(LABEL_INDEX != -1){
			vals = new Object[LABEL_INDEX+1];
			vals[LABEL_INDEX] = (String)item.values[LABEL_INDEX];
		}
		else{
			vals = new Object[6];
		}
		
		vals[0] = Double.parseDouble((String) item.values[X_INDEX]);
		vals[1] = Double.parseDouble((String) item.values[Y_INDEX]);
		vals[2] = Double.parseDouble((String) item.values[Z_INDEX]);
		if(ORT_X_INDEX!=-1) {
			vals[3] = Double.parseDouble((String) item.values[ORT_X_INDEX]);
			vals[4] = Double.parseDouble((String) item.values[ORT_Y_INDEX]);
			vals[5] = Double.parseDouble((String) item.values[ORT_Z_INDEX]);
		}
		nextItem = new AccelValuesItem(item.timeStamp,vals);
	}
	
	@Override
	public void saveStreamToFile(String filePath) {
		BufferedWriter bw = IOUtils.getWriter(filePath);
		while(hasNext())
		{
			AccelValuesItem item = getNextItem();
			IOUtils.writeLine(item.toString(), bw);
		}
		IOUtils.close(bw);
	}

}

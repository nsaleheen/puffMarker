package org.mstream.stream.file;

import java.io.BufferedWriter;

import org.mstream.stream.IStream;
import org.mstream.stream.items.DoubleValuesItem;
import org.mstream.stream.items.StringValuesItem;

import edu.umass.cs.sensors.utils.io.IOUtils;
import edu.umass.cs.sensors.utils.io.Logger;

/**
 * Operator to convert {@link StringValuesItem} stream to {@link DoubleValuesItem} stream
 * 
 * @author aparate
 *
 */
public class StringToDoubleItemConverter implements IStream<DoubleValuesItem>{


	/**
	 * Child Stream with {@link StringValuesItem}
	 */
	private IStream<StringValuesItem> child = null;

	
	//Variables to track Next item
	private DoubleValuesItem nextItem = null;
	private boolean verifiedNext = false;
	private boolean hasNext = false;


	


	/**
	 * Constructor for {@link StringToDoubleItemConverter}
	 */
	public StringToDoubleItemConverter(){
		
	}




	/**
	 * Returns next {@link DoubleValuesItem}
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
	 * Add a single stream as child. Last added stream will be used.
	 * @see org.mstream.stream.IStream#addChildStreams(org.mstream.stream.IStream[])
	 **/
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public void addChildStreams(IStream... streams) {
		for(IStream stream: streams)
		{	
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

	/**
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
	

	/**
	 * Parses the string item
	 * @param sitem input
	 */
	private void parseItem(StringValuesItem sitem) {
		Double vals[] = new Double[sitem.values.length];
		for(int i=0;i<sitem.values.length;i++)
			vals[i] =  Double.parseDouble(sitem.getValueAsString(i));
		nextItem = new DoubleValuesItem(sitem.timeStamp,vals);
	}

	
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

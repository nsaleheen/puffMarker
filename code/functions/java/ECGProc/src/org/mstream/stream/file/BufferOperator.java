package org.mstream.stream.file;

import java.io.BufferedWriter;

import org.mstream.stream.IStream;
import org.mstream.stream.items.BufferItem;
import org.mstream.stream.items.IStreamItem;

import edu.umass.cs.sensors.utils.io.IOUtils;

/**
 * Buffers a child stream
 * <p>
 * 
 * Input Stream: any {@link org.mstream.stream.IStream}.<br/> 
 * Outputs {@link org.mstream.stream.items.BufferItem}<br/>
 * 
 * @author aparate
 *
 */
public class BufferOperator<T> implements IStream<BufferItem<T>>{

	/**
	 * Buffer for  values
	 */
	private BufferItem<T> bufferItem = null;


	/**
	 * Number of seconds to buffer
	 */
	private int WINDOW_IN_SECS = 1000;//1000 seconds

	/**
	 * Number of samples to buffer
	 */
	private int NSAMPLES = 100;


	//Variables for tracking next item
	private boolean verifiedNext = false;
	private boolean hasNext = false;

	/**
	 * Childstream to buffer
	 */
	private IStream<T> child = null;

	private boolean isFixedWindow = true;



	/**
	 * Constructor for {@link BufferOperator}
	 */
	public BufferOperator(){

	}


	/**
	 * Sets a buffer of size NSAMPLES
	 * @param NSAMPLES
	 */
	public void setBufferSize(int NSAMPLES)
	{
		isFixedWindow = true;
		this.NSAMPLES = NSAMPLES;
	}

	/**
	 * Sets a buffer window of time interval specified in seconds
	 * @param WINDOW_IN_SEC
	 */
	public void setBufferWindow(int WINDOW_IN_SEC)
	{
		isFixedWindow = false;
		this.WINDOW_IN_SECS = WINDOW_IN_SEC;
	}


	/**
	 * Returns next {@link BufferItem}
	 * @see org.mstream.stream.IStream#getNextItem()
	 **/
	@Override
	public BufferItem<T> getNextItem() {
		if(verifiedNext && hasNext){
			verifiedNext = false;
			return bufferItem;
		} 
		else if(!verifiedNext) 
		{
			hasNext = readNext();
			verifiedNext = false;
			if(hasNext)
				return bufferItem;
		}
		return null;
	}

	/** 
	 * Add a child stream to buffer  
	 * @see org.mstream.stream.IStream#addChildStreams(org.mstream.stream.IStream[])
	 **/
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public void addChildStreams(IStream... streams) {
		for(IStream stream:streams)
			child = (IStream<T>)stream;
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
		bufferItem = new BufferItem<T>(); 
		if(isFixedWindow)
		{
			int validPoints = 0;
			for(int i=0;i<NSAMPLES;i++)
			{
				if(child.hasNext()) 
				{
					T item = child.getNextItem();
					bufferItem.addToBuffer(item);
					validPoints++;
					//continue;
				}
				else
					break;
			}
			verifiedNext = true;
			if(validPoints==NSAMPLES)
				return true;
			return false;
		} else 
		{
			T item = null;
			long startTime = -1;
			if(child.hasNext()){
				item = child.getNextItem();
				startTime = ((IStreamItem)item).timeStamp;
				bufferItem.addToBuffer(item);
				while(true)
				{
					if(child.hasNext()){
						item = child.getNextItem();
						long time = ((IStreamItem)item).timeStamp;
						if(time-startTime>WINDOW_IN_SECS*1000)
							break;
						bufferItem.addToBuffer(item);
					} else break;
				}
			}
			verifiedNext = true;
			if(startTime<=0) return false;
			return true;
		}
		//Finished
	}





	/**
	 * 
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







}

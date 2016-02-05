/**
 * 
 */
package org.mstream.stream.items;

import java.util.Collection;
import java.util.LinkedList;

/**
 * BufferItem contains a buffer of stream items.
 * 
 * @author Abhinav Parate
 * 
 */
public class BufferItem<T> extends IStreamItem {
	
	private LinkedList<T> buffer = new LinkedList<T>();
	
	/**
	 * Add an item to buffer
	 * @param item
	 */
	public void addToBuffer(T item)
	{
		if(buffer.size()==0)
			this.timeStamp = ((IStreamItem)item).timeStamp;
		buffer.add(item);
	}
	
	/**
	 * Set Buffer data
	 * @param data
	 */
	public void setBufferData(Collection<T> data)
	{
		buffer.clear();
		buffer.addAll(data);
	}
	
	/**
	 * Get buffered data
	 * @return array containing buffered data
	 */
	public T[] getBufferData(T[] sample){
		
		return buffer.toArray(sample);
	}
	
	
	
}

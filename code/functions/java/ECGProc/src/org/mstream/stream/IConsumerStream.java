package org.mstream.stream;

/**
 * TODO: General Interface to be implemented by consumer streams in iStream framework 
 * 
 * @author aparate
 *
 */
public interface IConsumerStream<T> {

	/**
	 * Retrieve next item in the stream
	 * @return next item in stream
	 */
	public T getNextItem();
	
	/**
	 * Add a child stream in the pipeline
	 */
	@SuppressWarnings("rawtypes")
	public void addChildStreams(IConsumerStream... stream);
	
	/**
	 * Returns true if the iteration has more elements. 
	 * (In other words, returns true if next would return an element rather than throwing an exception.)
	 * @return true if it has more items 
	 */
	public boolean hasNext();
	
	/**
	 * Closes the stream and releases all the resources
	 */
	public void closeStream();
	
}

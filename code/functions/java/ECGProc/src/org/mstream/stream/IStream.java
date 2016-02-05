package org.mstream.stream;

/**
 * General Interface to be implemented by streams in iStream framework 
 * 
 * @author aparate
 *
 */
public interface IStream<T> {

	/**
	 * Retrieve next item in the stream
	 * @return next item in stream
	 */
	public T getNextItem();
	
	/**
	 * Add a child stream in the pipeline
	 */
	@SuppressWarnings("rawtypes")
	public void addChildStreams(IStream... stream);
	
	/**
	 * Returns true if the stream has more elements. 
	 * (In other words, returns true if next would return an element rather than throwing an exception.)
	 * @return true if it has more items 
	 */
	public boolean hasNext();
	
	/**
	 * Close this stream and all the child streams, release resources
	 */
	public void closeStream();
	
	/**
	 * Reads the entire stream and saves it to the file path specified
	 * @param filePath path where to save the stream
	 */
	public void saveStreamToFile(String filePath);
	
}

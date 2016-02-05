package org.mstream.stream;

/**
 * Stream Operator to merge streams 
 * @author aparate
 *
 */
public interface IMergeOperator<T> extends IStream<T>{

	/**
	 * Merges all the input streams
	 * @param iStreams input streams to merge
	 */
	@SuppressWarnings("rawtypes")
	public void merge(IStream... iStreams );
	
}

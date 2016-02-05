package org.mstream.stream.items;

/**
 * The {@code StringValuesItem} class wraps an array of string values in a single item.
 * <p> 
 * A CSV record is an example of such an item.
 * @author aparate
 *
 */
public class StringValuesItem extends IStreamItem{
	
	
	
	/**
	 * Constructor for an item
	 * @param time time of record
	 * @param vals array of string values
	 */
	public StringValuesItem(long time, String[] vals) {
		timeStamp = time;
		values = new Object[vals.length];
		for(int i=0;i<vals.length;i++)
			values[i] = vals[i];
	}
	
	/**
	 * Get value at specified index 
	 * @param index
	 * @return string value
	 */
	public String getValue(int index){
		return (String)values[index];
	}
}

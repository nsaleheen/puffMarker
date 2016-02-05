package org.mstream.stream.items;

/**
 * The {@code DoubleValuesItem} class wraps an array of double values in a single item.
 * <p>  
 * @author aparate
 *
 */
public class DoubleValuesItem extends IStreamItem{
	
	
	/**
	 * Constructor for an item
	 * @param time time of record
	 * @param vals array of string values
	 */
	public DoubleValuesItem(long time, Double[] vals) {
		timeStamp = time;
		values = new Object[vals.length];
		for(int i=0;i<vals.length;i++)
			values[i] = vals[i];
	}
	
	/**
	 * Get value at specified index 
	 * @param index
	 * @return double value
	 */
	public Double getValue(int index){
		return (Double)values[index];
	}
	
	/**
	 * Returns all values
	 * @return array of values
	 */
	public Double[] getValues(){
		Double[] vals = new Double[values.length];
		for(int i=0;i<vals.length;i++)
			vals[i] = (Double)values[i];
		return vals;//(Double[])values;
	}
	
}

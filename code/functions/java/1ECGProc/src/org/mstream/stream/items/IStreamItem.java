package org.mstream.stream.items;

import java.util.HashMap;

/**
 * Super class to be implemented by stream items
 * <p>
 * This class supports saving a record consisting of an array of values and timestamp.
 * The value can be accessed using index in array or the name of the field (if schema is available).
 * The value can be obtained as Object, Double, Float, Long, Integer, Byte, Short, Boolean and String. Any extension
 * of this class that requires values to be obtained in any other format must implement {@code getValueAs<Format>} method
 * or do it's own type-casting.    
 * @author aparate
 *
 */
public class IStreamItem {

	/**
	 * Timestamp is the time associated with the item and is a must requirement
	 */
	public long timeStamp = 0L;
	
	/**
	 * Array of values for the stream item
	 */
	public Object[] values = null;
	
	
	/**
	 * Default constructor should be used carefully
	 */
	public IStreamItem(){
		
	}
	
	/**
	 * Constructor for an item
	 * @param time time of record
	 * @param vals array of string values
	 */
	public IStreamItem(long time, Object[] vals) {
		timeStamp = time;
		values = new Object[vals.length];
		for(int i=0;i<vals.length;i++)
			values[i] = vals[i];
	}
	
	/**
	 * Schema for this item
	 */
	private HashMap<String,Integer> schema = new HashMap<String,Integer>();
	
	/**
	 * Set Schema where the input hashmap has "fieldName" to "index" in array mapping
	 * @param schema
	 */
	public void setSchema(HashMap<String,Integer> schema)
	{
		this.schema = schema;
	}
	
	/**
	 * Returns schema for this item
	 * @return hashmap containing schema <string,integer>
	 */
	public HashMap<String,Integer> getSchema() {
		return schema;
	}
	
	/**
	 * Set timestamp for this stream item
	 * @param timestamp
	 */
	public void setTimestamp(long timestamp)
	{
		this.timeStamp = timestamp;
	}
	
	/**
	 * Sets an empty values array of length len
	 * @param len
	 */
	public void setEmptyValues(int len)
	{
		values = new Object[len];
	}
	
	/**
	 * Set Values for this stream item
	 * @param vals
	 */
	public void setValues(Object[] vals){
		this.values = vals;
	}
	
	/**
	 * Sets a given value at specified index in values array
	 * @param index
	 * @param val
	 * @return false if value can't be set because array is null or index is out of bounds 
	 */
	public boolean setValue(int index, Object val) {
		if(values!=null)
		{
			if(index>=values.length)
				return false;
			values[index] = val;
		}
		return false;
	}
	
	/**
	 * Sets a given value for specified fieldname in values array
	 * @param fieldName
	 * @param val
	 * @return false if value can't be set because array is null or field not found 
	 */
	public boolean setValue(String fieldName, Object val) {
		Integer index = schema.get(fieldName);
		if(index!=null)
		{
			return setValue(index,val);
		}
		return false;
	}
	
	/**
	 * Return value at index as Object
	 * @param index
	 * @return null if there are no stored value or there is an invalid index
	 */
	public Object getValueAsObject(int index){
		if(values!=null)
		{
			if(index>=values.length)
				return null;
			return values[index];
		}
		return null;
	}
	
	/**
	 * Return value at index as Double
	 * @param index
	 * @return null if the stored value format is unknown or values are null
	 */
	public Double getValueAsDouble(int index){
		if(values!=null)
		{
			if(index>=values.length)
				return null;
			if(values[index] instanceof Double)
				return (Double)values[index];
			else if(values[index] instanceof String)
				return Double.parseDouble((String)values[index]);
			else if(values[index] instanceof Number)
				return ((Number)values[index]).doubleValue();
			else return null; //Do not understand the format
		}
		return null;
	}
	
	/**
	 * Return value at index as Long
	 * @param index
	 * @return null if the stored value format is unknown or values are null
	 */
	public Long getValueAsLong(int index){
		if(values!=null)
		{
			if(index>=values.length)
				return null;
			if(values[index] instanceof Long)
				return (Long)values[index];
			else if(values[index] instanceof String)
				return Long.parseLong((String)values[index]);
			else if(values[index] instanceof Number)
				return ((Number)values[index]).longValue();
			else return null; //Do not understand the format
		}
		return null;
	}
	
	/**
	 * Return value at index as Float
	 * @param index
	 * @return null if the stored value format is unknown or values are null
	 */
	public Float getValueAsFloat(int index){
		if(values!=null)
		{
			if(index>=values.length)
				return null;
			if(values[index] instanceof Float)
				return (Float)values[index];
			else if(values[index] instanceof String)
				return Float.parseFloat((String)values[index]);
			else if(values[index] instanceof Number)
				return ((Number)values[index]).floatValue();
			else return null; //Do not understand the format
		}
		return null;
	}
	
	/**
	 * Return value at index as Integer
	 * @param index
	 * @return null if the stored value format is unknown or values are null
	 */
	public Integer getValueAsInteger(int index){
		if(values!=null)
		{
			if(index>=values.length)
				return null;
			if(values[index] instanceof Integer)
				return (Integer)values[index];
			else if(values[index] instanceof String)
				return Integer.parseInt((String)values[index]);
			else if(values[index] instanceof Number)
				return ((Number)values[index]).intValue();
			else return null; //Do not understand the format
		}
		return null;
	}
	
	/**
	 * Return value at index as Short
	 * @param index
	 * @return null if the stored value format is unknown or values are null
	 */
	public Short getValueAsShort(int index){
		if(values!=null)
		{
			if(index>=values.length)
				return null;
			if(values[index] instanceof Short)
				return (Short)values[index];
			else if(values[index] instanceof String)
				return Short.parseShort((String)values[index]);
			else if(values[index] instanceof Number)
				return ((Number)values[index]).shortValue();
			else return null; //Do not understand the format
		}
		return null;
	}
	
	/**
	 * Return value at index as Byte
	 * @param index
	 * @return null if the stored value format is unknown or values are null
	 */
	public Byte getValueAsByte(int index){
		if(values!=null)
		{
			if(index>=values.length)
				return null;
			if(values[index] instanceof Byte)
				return (Byte)values[index];
			else if(values[index] instanceof String)
				return Byte.parseByte((String)values[index]);
			else if(values[index] instanceof Number)
				return ((Number)values[index]).byteValue();
			else return null; //Do not understand the format
		}
		return null;
	}
	
	/**
	 * Return value at index as Boolean
	 * @param index
	 * @return null if the stored value format is unknown or values are null
	 */
	public Boolean getValueAsBoolean(int index){
		if(values!=null)
		{
			if(index>=values.length)
				return null;
			if(values[index] instanceof Boolean)
				return (Boolean)values[index];
			else if(values[index] instanceof String)
				return Boolean.parseBoolean((String)values[index]);
			else if(values[index] instanceof Number)
				return (((Number)values[index]).doubleValue()!=0.0);
			else return null; //Do not understand the format
		}
		return null;
	}
	
	/**
	 * Return value at index as String
	 * @param index
	 * @return null if the stored value format is unknown or values are null
	 */
	public String getValueAsString(int index){
		if(values!=null)
		{
			if(index>=values.length)
				return null;
			if(values[index] instanceof String)
				return (String)values[index];
			else return values[index].toString(); 
		}
		return null;
	}
	
	/**
	 * Return value of field as Double
	 * @param fieldName
	 * @return null if fieldname is unknown or values are null
	 */
	public Double getValueAsDouble(String fieldName){
		Integer index = schema.get(fieldName);
		if(index==null)
			return null;
		return getValueAsDouble(index);
	}
	
	/**
	 * Return value of field as Long
	 * @param fieldName
	 * @return null if fieldname is unknown or values are null
	 */
	public Long getValueAsLong(String fieldName){
		Integer index = schema.get(fieldName);
		if(index==null)
			return null;
		return getValueAsLong(index);
	}
	
	/**
	 * Return value of field as Float
	 * @param fieldName
	 * @return null if fieldname is unknown or values are null
	 */
	public Float getValueAsFloat(String fieldName){
		Integer index = schema.get(fieldName);
		if(index==null)
			return null;
		return getValueAsFloat(index);
	}
	
	/**
	 * Return value of field as Short
	 * @param fieldName
	 * @return null if fieldname is unknown or values are null
	 */
	public Short getValueAsShort(String fieldName){
		Integer index = schema.get(fieldName);
		if(index==null)
			return null;
		return getValueAsShort(index);
	}
	
	/**
	 * Return value of field as Integer
	 * @param fieldName
	 * @return null if fieldname is unknown or values are null
	 */
	public Integer getValueAsInteger(String fieldName){
		Integer index = schema.get(fieldName);
		if(index==null)
			return null;
		return getValueAsInteger(index);
	}
	
	/**
	 * Return value of field as Byte
	 * @param fieldName
	 * @return null if fieldname is unknown or values are null
	 */
	public Byte getValueAsByte(String fieldName){
		Integer index = schema.get(fieldName);
		if(index==null)
			return null;
		return getValueAsByte(index);
	}
	
	/**
	 * Return value of field as Boolean
	 * @param fieldName
	 * @return null if fieldname is unknown or values are null
	 */
	public Boolean getValueAsBoolean(String fieldName){
		Integer index = schema.get(fieldName);
		if(index==null)
			return null;
		return getValueAsBoolean(index);
	}
	
	/**
	 * Return value of field as String
	 * @param fieldName
	 * @return null if fieldname is unknown or values are null
	 */
	public String getValueAsString(String fieldName){
		Integer index = schema.get(fieldName);
		if(index==null)
			return null;
		return getValueAsString(index);
	}
	
	/**
	 * Return value of field as Object
	 * @param fieldName
	 * @return null if fieldname is unknown or values are null
	 */
	public Object getValueAsObject(String fieldName){
		Integer index = schema.get(fieldName);
		if(index==null)
			return null;
		return getValueAsObject(index);
	}
	
	/**
	 * Returns all values
	 * @return array of values
	 */
	public Object[] getValues(){
		return values;
	}
	
	/** 
	 * Returns a csv string
	 * @see java.lang.Object#toString()
	 */
	public String toString() {
		String s = timeStamp+"";
		for(Object val:values)
			s += (","+(val==null?null:val.toString()));
		return s;
	}
}

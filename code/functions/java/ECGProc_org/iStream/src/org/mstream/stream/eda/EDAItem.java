package org.mstream.stream.eda;

import java.util.HashMap;

import org.mstream.stream.items.IStreamItem;

/**
 * The {@link org.mstream.stream.eda.EDAItem} class wraps an EDA value.
 * <p>
 * This is a wrapper around {@link IStreamItem} class and provides utility methods to access raw,processed,activity and label values.
 * This has its own inbuilt schema.
 * 
 * @author aparate
 *
 */
public class EDAItem extends IStreamItem{
	
	public static final int RAW_INDEX=0;
	public static final int PROC_INDEX=1;
	public static final int LABEL_INDEX=3;
	public static final int ACTIVITY_INDEX=2;
	public static final int AMPLITUDE_INDEX=4;
	public static final int RISETIME_INDEX=5;
	public static final int HALFRECOVERY_INDEX=6;
	
	/**
	 * Constructor for an item
	 * @param time time of record
	 */
	public EDAItem(long time) {
		timeStamp = time;
		values = new Object[7];
		HashMap<String,Integer> schema = getSchema();
		schema.put("RAW",RAW_INDEX);
		schema.put("PROC",PROC_INDEX);
		schema.put("LABEL",LABEL_INDEX);
		schema.put("ACTIVITY",ACTIVITY_INDEX);
		schema.put("AMPLITUDE", AMPLITUDE_INDEX);
		schema.put("RISETIME", RISETIME_INDEX);
		schema.put("HALFRECOVERYTIME", HALFRECOVERY_INDEX);
	}
	
	/**
	 * Set Values
	 * @param raw
	 * @param proc
	 * @param label
	 */
	public void setValues(double raw, double proc,double activity, String label) {
		values[RAW_INDEX] = raw;
		values[PROC_INDEX] = proc;
		values[ACTIVITY_INDEX] = activity;
		values[LABEL_INDEX] = label;
	}
	
	/**
	 * Set Raw noisy value
	 * @param raw
	 */
	public void setRawValue(double raw){
		values[RAW_INDEX] = raw;
	}
	
	/**
	 * Get noisy value of ECG
	 * @return raw : noisy ecg value
	 */
	public Double getRawValue(){
		return (Double)values[RAW_INDEX];
	}
	
	/**
	 * Set processed value
	 * @param proc
	 */
	public void setProcessedValue(double proc){
		values[PROC_INDEX] = proc;
	}
	
	/**
	 * Get processed value
	 * @return proc processed value
	 */
	public Double getProcessedValue(){
		return (Double)values[PROC_INDEX];
	}
	
	/**
	 * Set activity level
	 * @param act
	 */
	public void setActivityLevel(double act){
		values[ACTIVITY_INDEX] = act;
	}
	
	/**
	 * Get Activity level value
	 * @return activity level
	 */
	public Double getActivityLevel(){
		return (Double)values[ACTIVITY_INDEX];
	}
	
	/**
	 * Set Labels
	 * @param label
	 */
	public void setLabel(String label){
		values[LABEL_INDEX] = label;
	}
	
	/**
	 * Get peak label
	 * @return null if value is not for any peak or trough
	 */
	public String getLabel(){
		if(values[LABEL_INDEX]==null) return null;
		return (String)values[LABEL_INDEX];
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

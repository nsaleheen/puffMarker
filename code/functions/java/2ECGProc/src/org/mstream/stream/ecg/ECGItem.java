package org.mstream.stream.ecg;

import java.util.HashMap;

import org.mstream.stream.items.IStreamItem;

/**
 * The {@link org.mstream.stream.ecg.ECGItem} class wraps an ECG value.
 * <p>
 * This is a wrapper around {@link IStreamItem} class and provides utility methods to access raw,processed and label values.
 * This has its own inbuilt schema.
 * 
 * @author aparate
 *
 */
public class ECGItem extends IStreamItem{
	
	private static final int RAW_INDEX=0;
	private static final int PROC_INDEX=1;
	private static final int LABEL_INDEX=2;
	
	
	/**
	 * Constructor for an item
	 * @param time time of record
	 */
	public ECGItem(long time) {
		timeStamp = time;
		values = new Object[3];
		HashMap<String,Integer> schema = getSchema();
		schema.put("RAW",RAW_INDEX);
		schema.put("PROC",PROC_INDEX);
		schema.put("LABEL",LABEL_INDEX);
	}
	
	/**
	 * Set Values
	 * @param raw
	 * @param proc
	 * @param label
	 */
	public void setValues(double raw, double proc,String label) {
		values[RAW_INDEX] = raw;
		values[PROC_INDEX] = proc;
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
	 * Set P,Q,R,S,T Label
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
	
}

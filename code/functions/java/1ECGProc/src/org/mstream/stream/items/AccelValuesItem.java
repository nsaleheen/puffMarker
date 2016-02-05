package org.mstream.stream.items;

/*
 * AccelValuesItem class. This is the main class processed by the accelerometer stream.
 */

public class AccelValuesItem extends IStreamItem{
	
	private static final int X_INDEX = 0;
	private static final int Y_INDEX = 1;
	private static final int Z_INDEX = 2;
	private static final int ORIENTX_INDEX = 3;
	private static final int ORIENTY_INDEX = 4;
	private static final int ORIENTZ_INDEX = 5;
	//private static final int LABEL_INDEX = 6;
	
	/*
	 * Constructor for the AccelValuesItem
	 * Probably need to change this to include the schema portion
	 * @param time of record
	 * @param array of values
	 */
	
public AccelValuesItem(long time, Object[] vals){
		timeStamp = time;
		values = new Object[vals.length];
		for(int i = 0; i < vals.length; i++){
			values[i] = vals[i];
		}
	}
	
	/*
	 * Another possible constructor for the AccelValuesItem, probably pointless because of how converter
	 * works
	 * @param time of record
	 */
	
	public AccelValuesItem(long time){
		timeStamp = time;
		values = new Object[7];
	}
	
	/*
	 * Method to set the x acceleration
	 * @param raw x acceleration
	 */
	
	public void setX(double x){
		values[X_INDEX] = x;
	}
	
	/*
	 * Method to get the x acceleration
	 * @return Double value
	 */
	
	public Double getX(){
		return (Double)values[X_INDEX];
	}
	
	/*
	 * Method to set the y acceleration
	 * @param raw y acceleration
	 */
	
	public void setY(double y){
		values[Y_INDEX] = y;
	}
	
	/*
	 * Method to get the y acceleration
	 * @return Double value
	 */
	
	public Double getY(){
		return (Double)values[Y_INDEX];
	}
	
	/*
	 * Method to set the z acceleration
	 * @param raw z acceleration
	 */
	
	public void setZ(double z){
		values[Z_INDEX] = z;
	}
	
	/*
	 * Method to get the z acceleration
	 * @return Double value
	 */
	
	public Double getZ(){
		return (Double)values[Z_INDEX];
	}
	
	/*
	 * Method to set the oriented x acceleration
	 * @param ox oriented x acceleration
	 */
	
	public void setOrientX(double ox){
		values[ORIENTX_INDEX] = ox;
	}
	
	/*
	 * Method to get the oriented x acceleration
	 * @return Double value
	 */
	
	public Double getOrientX(){
		return (Double) values[ORIENTX_INDEX];
	}
	
	/*
	 * Method to set the oriented y acceleration
	 * @param oy oriented y acceleration
	 */
	
	public void setOrientY(double oy){
		values[ORIENTY_INDEX] = oy;
	}
	
	/*
	 * Method to get the oriented y acceleration
	 * @return Double value
	 */
	
	public Double getOrientY(){
		return (Double)values[ORIENTY_INDEX];
	}
	
	/*
	 * Method to set oriented z acceleration
	 * @param oz oriented z acceleration
	 */
	
	public void setOrientZ(double oz){
		values[ORIENTZ_INDEX] = oz;
	}
	
	/*
	 * Method to get the oriented z acceleration
	 * @return Double value
	 */
	
	public Double getOrientZ(){
		return (Double)values[ORIENTZ_INDEX];
	}
	
	/*
	 * Method to get the label
	 * @return String value
	 */
	
	public String getLabel(){
		if(values[values.length-1].equals("WALK") || values[values.length-1].equals("STATIONARY"))
			return (String)values[values.length-1];
		else
			return null;
	}

	/*
	 * Method to set the label
	 * @param label
	 */
	
	public void setLabel(String label){
		values[values.length-1] = label;
	}
	
	/*
	 * Return all values
	 * @return array of Double
	 */
	
	public Object[] getValues(){
		return values;
	}
	
	/*
	 * Set all values
	 * @param raw x acceleration
	 * @param raw y acceleration
	 * @param raw z acceleration
	 * @param oriented x acceleration
	 * @param oriented y acceleration
	 * @param oriented z acceleration
	 * @param label
	 */
	
	public void setAllValues(double x, double y, double z, double ox, double oy, double oz, String label){
		values[X_INDEX] = x;
		values[Y_INDEX] = y;
		values[Z_INDEX] = z;
		values[ORIENTX_INDEX] = ox;
		values[ORIENTY_INDEX] = oy;
		values[ORIENTZ_INDEX] = oz;
		values[values.length-1] = label;
	}
}


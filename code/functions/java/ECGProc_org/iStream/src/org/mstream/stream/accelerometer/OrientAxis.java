package org.mstream.stream.accelerometer;

import java.io.BufferedWriter;
import java.util.Arrays;
import java.util.LinkedList;

import org.mstream.stream.IStream;
import org.mstream.stream.items.AccelValuesItem;

import edu.umass.cs.sensors.utils.io.IOUtils;
import edu.umass.cs.sensors.utils.io.Logger;


public class OrientAxis implements IStream<AccelValuesItem>{

	/* Variables for accelerometer tracking and buffer */
	private static boolean accState = false;
	private static int readCounter = 0;
	private static final int READ_LIMIT = 400;
	private static double[][] accReadings =  new double[READ_LIMIT][3];
	private static double[][] orientReadings = new double[READ_LIMIT][3];
	private static double aggAX = 0.0f;
	private static double aggAY = 0.0f;
	private static double aggAZ = 0.0f;
	private static double orientAggAX = 0.0f;
	private static double orientAggAY = 0.0f;
	private static double orientAggAZ = 0.0f;
	
	
	
	private IStream<AccelValuesItem> child = null;
	private boolean verifiedNext = false;
	private boolean hasNext = false;
	
	//tentative variable to track the window size (might need to be an int), value subject to change
	private long WINDOW = 5000;
	//variable to keep track of the index in the array/LinkedList
	private int currentIndex = -1;
	//need to decide if I want to keep this an array or switch it to a LinkedList
	private AccelValuesItem[] data = null;
	//possible data structure for storing processed data
	private LinkedList<AccelValuesItem> processed = new LinkedList<AccelValuesItem>();
	//tentative variable for tracking valid data for processing
	private int validDataPoints = 0;
	
	/*
	public void orientFile(String inputFile, String outputFile) throws Exception{
		BufferedReader br = new BufferedReader(new FileReader(inputFile));
		BufferedWriter bw = new BufferedWriter(new FileWriter(outputFile));
		while(true){
			String s = br.readLine();
			if(s== null)
				break;
			if(s.trim().equals(""))
				continue;
			String tokens[] = s.split(",");
			try{
				long timestamp = Long.parseLong(tokens[1]);
				double acc_x = Double.parseDouble(tokens[5]);
				double acc_y = Double.parseDouble(tokens[6]);
				double acc_z = Double.parseDouble(tokens[7]);
				String output = orientAxis(timestamp,acc_x,acc_y,acc_z);
				if(output!=null){
					bw.write(output+"\n");
					bw.flush();
				}
			}catch(Exception e){
				e.printStackTrace();
				continue;
			}
		}
		br.close();
		bw.close();
	}*/

	public String orientAxis(long timestamp, double acc_x,double acc_y,double acc_z,String label){
		if(readCounter == READ_LIMIT){
			//Now, we are ready to orient axis
			//reset counter
			readCounter = 0;
		}
		
		accState = true; 

		aggAX = aggAX +acc_x - accReadings[readCounter][0];
		aggAY = aggAY +acc_y - accReadings[readCounter][1];
		aggAZ = aggAZ +acc_z - accReadings[readCounter][2];

		accReadings[readCounter][0] = acc_x;
		accReadings[readCounter][1] = acc_y;
		accReadings[readCounter][2] = acc_z;

		String output = null;

		if(accState){
			//Now get the oriented axis and corresponding readings
			double g = 9.81;
			double acc_z_o = aggAZ/(READ_LIMIT*g);
			double acc_y_o = aggAY/(READ_LIMIT*g);
			double acc_x_o = aggAX/(READ_LIMIT*g);
			
			acc_z_o = (acc_z_o>1.0?1.0:acc_z_o);
			acc_z_o = (acc_z_o<(-1.0)?-1.0:acc_z_o);
			acc_x = acc_x/g;
			acc_y = acc_y/g;
			acc_z = acc_z/g;
			double theta_tilt = Math.acos(acc_z_o);
			double phi_pre = Math.atan2(acc_y_o, acc_x_o);
			double tan_psi = ( (-1)*acc_x_o*Math.sin(phi_pre) + acc_y_o*Math.cos(phi_pre))/
			((acc_x_o*Math.cos(phi_pre)+acc_y_o*Math.sin(phi_pre))*Math.cos(theta_tilt)+(-1)*acc_z_o*Math.sin(theta_tilt));
			double psi_post = Math.atan(tan_psi);
			double acc_x_pre = acc_x*Math.cos(phi_pre)+ acc_y*Math.sin(phi_pre);
			double acc_y_pre = (-1)*acc_x*Math.sin(phi_pre)+ acc_y*Math.cos(phi_pre);
			double acc_x_pre_tilt = acc_x_pre*Math.cos(theta_tilt)+ (-1)*acc_z*Math.sin(theta_tilt);
			double acc_y_pre_tilt = acc_y_pre;
			double orient_acc_x = (acc_x_pre_tilt*Math.cos(psi_post)+ acc_y_pre_tilt*Math.sin(psi_post))*g;
			double orient_acc_y =( (-1)*acc_x_pre_tilt*Math.sin(psi_post)+ acc_y_pre_tilt*Math.cos(psi_post))*g;
			double orient_acc_z = acc_z*g/(Math.cos(theta_tilt));
			//System.out.println("ORT:"+orient_acc_x+","+orient_acc_y+","+orient_acc_z);
			orient_acc_z = (orient_acc_z>3*g?3*g:orient_acc_z);
			orient_acc_z = (orient_acc_z<(-1)*3*g?(-1)*3*g:orient_acc_z);
			orient_acc_z = Math.sqrt((Math.pow(acc_x, 2)+Math.pow(acc_y, 2)+Math.pow(acc_z, 2))*Math.pow(g, 2)
					-(Math.pow(orient_acc_x, 2)+Math.pow(orient_acc_y, 2)));

			orientAggAX = orientAggAX +orient_acc_x - orientReadings[readCounter][0];
			orientAggAY = orientAggAY +orient_acc_y - orientReadings[readCounter][1];
			orientAggAZ = orientAggAZ +orient_acc_z - orientReadings[readCounter][2];

			orientReadings[readCounter][0] = orient_acc_x;
			orientReadings[readCounter][1] = orient_acc_y;
			orientReadings[readCounter][2] = orient_acc_z;

			Object[] vals = null;
			
			if(label != null){
				vals = new Object[7];
				vals[6] = label;
			}
			else{
				vals = new Object[6];
			}
			
			vals[0] = acc_x*g;
			vals[1] = (-1)*acc_z*g;
			vals[2] = acc_y*g;
			vals[3] = orient_acc_x;
			vals[4] = orient_acc_y;
			vals[5] = orient_acc_z;
			
			
			processed.add(new AccelValuesItem(timestamp, vals));
			
			output = timestamp+","+acc_x+","+acc_y+","+acc_z
			+","+orient_acc_x+","+orient_acc_y+","+orient_acc_z;//+","+theta_tilt+","+phi_pre+","+tan_psi;
			//+","+orientAggAX/READ_LIMIT+","+orientAggAY/READ_LIMIT+","+orientAggAZ/READ_LIMIT;
		}
		readCounter++;
		return output;
	}

	public double median(double[] m) {
		Arrays.sort(m); 
		int middle = m.length/2;  // subscript of middle element
		if (m.length%2 == 1) {
			// Odd number of elements -- return the middle one.
			return m[middle];
		} else {
			// Even number -- return average of middle two
			// Must cast the numbers to double before dividing.
			return (m[middle-1] + m[middle]) / 2.0;
		}
	}//end method median


/*
	public static void main(String args[]) throws Exception{
		boolean brake = false;
		if(!brake){
			String inputFile = "/Users/aparate/data/activity/day1/tingxin.log";
			String outputFile = "/Users/aparate/data/activity/day1/T-acc-oriented.log";
			OrientAxis oa = new OrientAxis();
			oa.orientFile(inputFile, outputFile);
		} else{
			String inputFile = "/Users/aparate/data/brake/acc.csv";
			//String outputFile = "/Users/aparate/data/transformZBrakes.csv";
			//OrientAxis oa = new OrientAxis();
			//oa.orientFile(inputFile, outputFile);
		}
	}*/

	@Override
	public AccelValuesItem getNextItem() {
		if(verifiedNext && hasNext){
			verifiedNext = false;
			return seekNextItem();
		} 
		else if(!verifiedNext) 
		{
			hasNext = readNext();
			verifiedNext = false;
			if(hasNext)
				return seekNextItem();
		}
		return null;
	}
	
	private AccelValuesItem seekNextItem(){
		AccelValuesItem item = processed.poll();
		currentIndex++;
		
		if(item==null || item.timeStamp==0)
		{
			//Possibly because child finished with the data.
			//Should not proceed any further
			verifiedNext = true;
			hasNext = false;
		}
		return item;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public void addChildStreams(IStream... streams) {
		for(IStream stream:streams)
		{
			child = (IStream<AccelValuesItem>)stream;
		}	
	}

	@Override
	public boolean hasNext() {
		if(verifiedNext)
			return hasNext;
		hasNext = readNext();
		return hasNext;
	}
	
	private boolean readNext(){
		if(child==null){
			verifiedNext = true;
			return false;
		}
		if(currentIndex!=-1 && currentIndex<validDataPoints-1)
		{
			verifiedNext = true;
			if(data[currentIndex]!=null)
				return true;
			else return false;
		}
		if(currentIndex==-1 || currentIndex>=validDataPoints-1)
		{
			if(!child.hasNext())
			{
				verifiedNext = true;
				return false;
			}
			//We expect to read at least 1 value in the next window
			data = new AccelValuesItem[READ_LIMIT];
			validDataPoints = 0;
			//Read window
			AccelValuesItem item = null;
			int i = 0;
			
			do{
				while(true){
					if(child.hasNext()){
						item = child.getNextItem();
						try{
							//this is rather sloppy, should improve later
							data[i] = item;
							i++;
							validDataPoints++;
							break;
						} catch(Exception e){
							Logger.error(e.getLocalizedMessage());
							continue;
						}
					}
					else{
						data[i] = null;
						break;
					}
				}
				//breaks the loop if the child doesn't have a next value
				if(!child.hasNext()){
					break;
				}
			} while(item.timeStamp - data[0].timeStamp < WINDOW);
			
			//this is where the call to process the data will be (method under construction)
			reorient();
			
			currentIndex = 0;
			verifiedNext = true;
			return true;
		}
		Logger.error("SHOULD not arrive here");
		verifiedNext = true;
		return false;
		//Loop till we get next item
		//Done
	}
	
	private void reorient(){
		for(int i=0; i< validDataPoints; i++){
			orientAxis(data[i].timeStamp, data[i].getX(), data[i].getZ(), (-1)*data[i].getY(), data[i].getLabel());
		}
	}
	
	@Override
	public void closeStream() {
		if(child!=null)
			child.closeStream();
		verifiedNext = true;
		hasNext = false;
	}

	@Override
	public void saveStreamToFile(String filePath) {
		BufferedWriter bw = IOUtils.getWriter(filePath);
		while(hasNext())
		{
			AccelValuesItem item = getNextItem();
			IOUtils.writeLine(item.toString(), bw);
		}
		IOUtils.close(bw);
	}
}

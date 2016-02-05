package org.mstream.stream.eda;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.Arrays;


public class OrientAxis {

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
				long timestamp = Long.parseLong(tokens[0]);
				double acc_x = Double.parseDouble(tokens[5]);
				double acc_y = Double.parseDouble(tokens[6]);
				double acc_z = Double.parseDouble(tokens[7]);
				String output = orientAxis(timestamp,acc_x,acc_z,(-1)*acc_y);
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
	}

	public String orientAxis(long timestamp, double acc_x,double acc_y,double acc_z){
		if(readCounter == READ_LIMIT){
			//Now, we are ready to orient axis
			accState = true;
			//reset counter
			readCounter = 0;
		}




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
			double acc_y_o = aggAY/READ_LIMIT;
			double acc_x_o = aggAX/READ_LIMIT;
			/*double x[] = new double[READ_LIMIT];
			double y[] = new double[READ_LIMIT];
			double z[] = new double[READ_LIMIT];
			for(int i=0;i<x.length;i++){
				x[i] = accReadings[i][0];
				y[i] = accReadings[i][1];
				z[i] = accReadings[i][2];
			}
			double acc_z_o = median(z);
			double acc_y_o = median(y);
			double acc_x_o = median(x);*/

			acc_z_o = (acc_z_o>1.0?1.0:acc_z_o);
			acc_z_o = (acc_z_o<(-1.0)?-1.0:acc_z_o);

			double theta_tilt = Math.acos(acc_z_o);
			double phi_pre = Math.atan2(acc_y_o, acc_x_o);
			double tan_psi = ( (-1)*acc_x_o*Math.sin(phi_pre) + acc_y_o*Math.cos(phi_pre))/
			(acc_x_o*Math.cos(phi_pre)+acc_y_o*Math.sin(phi_pre)+(-1)*g*acc_z_o*Math.sin(theta_tilt));
			double psi_post = Math.atan(tan_psi);
			double acc_x_pre = acc_x*Math.cos(phi_pre)+ acc_y*Math.sin(phi_pre);
			double acc_y_pre = (-1)*acc_x*Math.sin(phi_pre)+ acc_y*Math.cos(phi_pre);
			double acc_x_pre_tilt = acc_x_pre*Math.cos(theta_tilt)+ (-1)*acc_z*Math.sin(theta_tilt);
			double acc_y_pre_tilt = acc_y_pre;
			double orient_acc_x = acc_x_pre_tilt*Math.cos(psi_post)+ acc_y_pre_tilt*Math.sin(psi_post);
			double orient_acc_y = (-1)*acc_x_pre_tilt*Math.sin(psi_post)+ acc_y_pre_tilt*Math.cos(psi_post);
			double orient_acc_z = acc_z/(Math.cos(theta_tilt));
			orient_acc_z = (orient_acc_z>3*g?3*g:orient_acc_z);
			orient_acc_z = (orient_acc_z<(-1)*3*g?(-1)*3*g:orient_acc_z);

			orientAggAX = orientAggAX +orient_acc_x - orientReadings[readCounter][0];
			orientAggAY = orientAggAY +orient_acc_y - orientReadings[readCounter][1];
			orientAggAZ = orientAggAZ +orient_acc_z - orientReadings[readCounter][2];

			orientReadings[readCounter][0] = orient_acc_x;
			orientReadings[readCounter][1] = orient_acc_y;
			orientReadings[readCounter][2] = orient_acc_z;

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



	public static void main(String args[]) throws Exception{
		boolean brake = false;
		if(brake){
			String inputFile = "/Users/aparate/data/activity/day1/tingxin.log";
			String outputFile = "/Users/aparate/data/activity/day1/T-acc-oriented.log";
			OrientAxis oa = new OrientAxis();
			oa.orientFile(inputFile, outputFile);
		} else{
			String inputFile = "/Users/aparate/Documents/RA/data/activity/data/All-filtered.log";
			String outputFile = "/Users/aparate/test.log";
			OrientAxis oa = new OrientAxis();
			oa.orientFile(inputFile, outputFile);
		}
	}
}

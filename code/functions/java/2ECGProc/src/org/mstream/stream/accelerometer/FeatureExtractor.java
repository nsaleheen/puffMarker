package org.mstream.stream.accelerometer;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.LinkedList;



public class FeatureExtractor {

	//LinkedLists to keep accelerometer readings for a period
	LinkedList<Double> xVector = new LinkedList<Double>();
	LinkedList<Double> yVector = new LinkedList<Double>();
	LinkedList<Double> zVector = new LinkedList<Double>();
	LinkedList<Double> speedVector = new LinkedList<Double>();
	double max = 0.0;

	//Add an accelerometer reading
	public void addValues(double acc_x, double acc_y, double acc_z, double vectorial_speed){
		xVector.add(acc_x);
		yVector.add(acc_y);
		zVector.add(acc_z);
		speedVector.add(vectorial_speed);
	}

	//Clear values for next round of feature extraction
	public void clearValues(){
		xVector.clear();
		yVector.clear();
		zVector.clear();
		speedVector.clear();
	}

	//return null if vectors are empty
	public double[] extractFeatures(){

		if(xVector.isEmpty())
			return null;
		double[] features = new double[16];

		Double[] values = xVector.toArray(new Double[0]);
		double mean = computeMean(values);
		double dev = computeStdDev(values,mean);
		double peak = computePeakFrequency(values);
		features[0] = mean;
		features[1] = dev;
		features[2] = peak;
		features[3] = max;

		values = yVector.toArray(new Double[0]);
		mean = computeMean(values);
		dev = computeStdDev(values,mean);
		peak = computePeakFrequency(values);
		features[4] = mean;
		features[5] = dev;
		features[6] = peak;
		features[7] = max;
		values = zVector.toArray(new Double[0]);
		mean = computeMean(values);
		dev = computeStdDev(values,mean);
		peak = computePeakFrequency(values);
		features[8] = mean;
		features[9] = dev;
		features[10] = peak;
		features[11] = max;
		values = speedVector.toArray(new Double[0]);
		mean = computeMean(values);
		dev = computeStdDev(values,mean);
		peak = computePeakFrequency(values);
		features[12] = mean;
		features[13] = dev;
		features[14] = peak;
		features[15] = max;
		return features;
	}

	public double computeMean(Double values[]){
		double mean = 0.0;
		for(int i=0;i<values.length;i++)
			mean += values[i];
		return mean/values.length;
	}

	public double computeStdDev(Double values[],double mean){
		double dev = 0.0;
		double diff = 0.0;
		for(int i=0;i<values.length;i++){
			diff = values[i]-mean;
			dev += diff*diff;
		}
		return Math.sqrt(dev/values.length);
	}
	
	public double[] computeSkew(Double values[],double mean, double dev){
		double skew = 0.0;
		double diff = 0.0;
		double kurt = 0.0;
		double t = 0.0;
		for(int i=0;i<values.length;i++){
			diff = values[i]-mean;
			t = Math.pow(diff,3);
			skew += t;
			kurt += t*diff;
		}
		t = Math.pow(dev, 3); 
		skew = skew/(values.length*t);
		kurt = kurt/(values.length*t*dev) -3;
		return new double[]{skew,kurt};
	}

	public void readFile(String file) throws Exception {
		BufferedReader br = new BufferedReader(new FileReader(file));
		long startTime = -1;
		long window = 5000;
		String s;
		while((s=br.readLine())!=null){
			if(s.trim().equals(""))
				continue;
			String tokens[] = s.split(",");
			long ct = Long.parseLong(tokens[0]);
			if(startTime == -1)
				startTime = ct;
			if((ct-startTime)>=window) {
				double feature[] = extractFeatures();
				String out = feature[0]+"";
				for(int i=1;i<feature.length;i++)
					out +=(","+feature[i]);
				out += ","+tokens[tokens.length-1];
				System.out.println(out);
				clearValues();
				startTime = ct;
			}
			addValues(Double.parseDouble(tokens[8]), Double.parseDouble(tokens[9]), Double.parseDouble(tokens[10]), Double.parseDouble(tokens[11]));
		}
		br.close();
	}

	
	public double computePeakFrequency(Double values[]){
		/***************************************************************
		 * fft.c
		 * Douglas L. Jones 
		 * University of Illinois at Urbana-Champaign 
		 * January 19, 1992 
		 * http://cnx.rice.edu/content/m12016/latest/
		 * 
		 *   fft: in-place radix-2 DIT DFT of a complex input 
		 * 
		 *   input: 
		 * n: length of FFT: must be a power of two 
		 * m: n = 2**m 
		 *   input/output 
		 * x: double array of length n with real part of data 
		 * y: double array of length n with imag part of data 
		 * 
		 *   Permission to copy and use this program is granted 
		 *   as long as this header is included. 
		 ****************************************************************/
		int i,j,k,n1,n2,a;
		double c,s,t1,t2;

		int n = 1,m=0;
		for(m=0;;m++){
			if(n>=values.length)
				break;
			n = n*2;
		}
		
		
		double x[] = new double[n];
		double y[] = new double[n];

		for(i=0;i<values.length;i++)
			x[i] = values[i];

		double cos[] = new double[n/2];
		double sin[] = new double[n/2];

		for(i =0;i<n/2;i++) {
			cos[i] = Math.cos(-2*Math.PI*i/n);
			sin[i] = Math.sin(-2*Math.PI*i/n);
		}
		// Bit-reverse
		j = 0;
		n2 = n/2;
		for (i=1; i < n - 1; i++) {
			n1 = n2;
			while ( j >= n1 ) {
				j = j - n1;
				n1 = n1/2;
			}
			j = j + n1;

			if (i < j) {
				t1 = x[i];
				x[i] = x[j];
				x[j] = t1;
				t1 = y[i];
				y[i] = y[j];
				y[j] = t1;
			}
		}

		// FFT
		n1 = 0;
		n2 = 1;

		for (i=0; i < m; i++) {
			n1 = n2;
			n2 = n2 + n2;
			a = 0;

			for (j=0; j < n1; j++) {
				c = cos[a];
				s = sin[a];
				a +=  1 << (m-i-1);

				for (k=j; k < n; k=k+n2) {
					t1 = c*x[k+n1] - s*y[k+n1];
					t2 = s*x[k+n1] + c*y[k+n1];
					x[k+n1] = x[k] - t1;
					y[k+n1] = y[k] - t2;
					x[k] = x[k] + t1;
					y[k] = y[k] + t2;
				}
			}
		}
		int index = 0;
		max = Math.hypot(x[0], y[0]);
		
		for(i=0;i<values.length;i++) {
			if(Math.hypot(x[i], y[i])>max){
				index = i;
				max = Math.hypot(x[i], y[i]);
			}
		}
		return (360.0*index)/values.length;

	}

	public static void main(String args[]) throws Exception{
		FeatureExtractor fe = new FeatureExtractor();
		String file= "/Users/aparate/data/activity/data/All-filtered.log";
		//String file= "/Users/aparate/data/activity/acc-day2-2.log";
		fe.readFile(file);

	}
}

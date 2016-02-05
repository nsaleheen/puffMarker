package org.mstream.stream.accelerometer;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.Arrays;
import java.util.LinkedList;

import org.mstream.stream.IStream;
import org.mstream.stream.items.AccelValuesItem;
import org.mstream.stream.items.IStreamItem;

import edu.umass.cs.sensors.utils.io.IOUtils;
import edu.umass.cs.sensors.utils.io.Logger;



public class FFTExtractor extends FeatureExtractor implements IStream<IStreamItem>{

	//LinkedLists to keep accelerometer readings for a period
	LinkedList<Double> xVector = new LinkedList<Double>();
	LinkedList<Double> yVector = new LinkedList<Double>();
	LinkedList<Double> zVector = new LinkedList<Double>();
	LinkedList<Double> speedVector = new LinkedList<Double>();
	LinkedList<Double> energyVector = new LinkedList<Double>();
	LinkedList<Double> energyXYVector = new LinkedList<Double>();
	LinkedList<Long> timeVector = new LinkedList<Long>();
	LinkedList<String> labelVector = new LinkedList<String>();
	double max = 0.0;

	//private static boolean READY_FOR_ORIENTATION = false;
	//private static int readCounter = 0;
	private static final int READ_LIMIT = 1000;
	//private static double[][] accReadings =  new double[READ_LIMIT][3];
	//private static double aggAX = 0.0f;
	//private static double aggAY = 0.0f;
	//private static double aggAZ = 0.0f;

	private IStream<AccelValuesItem> child = null;
	private boolean hasNext = false;
	private boolean verifiedNext = false;

	private long WINDOW = 5000;
	private int currentIndex = -1;
	private LinkedList<IStreamItem> output = new LinkedList<IStreamItem>();
	private AccelValuesItem[] data = null;
	private int validDataPoints = -1;

	
	//pass oriented x, y, and z acceleration as well as magnitude of the vector
	//Add an accelerometer reading
	public void addValues(double acc_x, double acc_y, double acc_z, double vectorial_speed){
		xVector.add(acc_x);
		yVector.add(acc_y);
		zVector.add(acc_z);
		speedVector.add(vectorial_speed);
		energyXYVector.add(Math.sqrt(acc_x*acc_x+acc_y*acc_y));
	}

	//pass oriented x, y, and z accelerations
	public void addEnergyValues(double acc_x, double acc_y, double acc_z){
		energyVector.add(Math.sqrt(acc_x*acc_x+acc_y*acc_y+acc_z*acc_z));
	}
	

	public void addTime(long time){
		timeVector.add(time);
	}

	//Clear values for next round of feature extraction
	public void clearValues(){
		xVector.clear();
		yVector.clear();
		zVector.clear();
		speedVector.clear();
		energyVector.clear();
		energyXYVector.clear();
		timeVector.clear();
	}

	
	public double[] extractFeatures3(){

		if(xVector.isEmpty()||xVector.size()<2)
			return null;
		double[] features = new double[43];

		Long[] times = timeVector.toArray(new Long[0]);
		times[times.length-1] = times[0]+5000;


		//features of the x acceleration
		Double[] values = xVector.toArray(new Double[0]);

		double mean = computeMean(values);
		double dev = computeStdDev(values,mean);
		double result[] = computeFFTFeatures(values);

		features[0] = mean;
		features[1] = dev;
		features[2] = computeCrossingRate(values,mean);
		//FFT
		for(int i=3;i<7;i++)
			features[i] = result[i-3];//0-3
		//might change where these values go in the array
		for(int i=1;i<values.length;i++){
			//change in x velocity from time i-1 to time i
			features[7] += (values[i-1]*(times[i]-times[i-1]));
			//two times the x distance from time i-1 to time i
			features[8] += Math.abs(values[i-1]*Math.pow(times[i]-times[i-1],2));
		}

		//features of the y acceleration
		values = yVector.toArray(new Double[0]);

		mean = computeMean(values);
		dev = computeStdDev(values,mean);
		result = computeFFTFeatures(values);
		features[9] = mean;
		features[10] = dev;
		features[11] = computeCrossingRate(values,mean);
		for(int i=12;i<16;i++)
			features[i] = result[i-12];
		//might change where these values go in the array
		for(int i=1;i<values.length;i++){
			//change in y velocity from time i-1 to time i
			features[16] += values[i-1]*(times[i]-times[i-1]);
			//two times the y distance from time i-1 to time i
			features[17]  += Math.abs(values[i-1]*Math.pow(times[i]-times[i-1],2));
		}

		//features of the z acceleration
		values = zVector.toArray(new Double[0]);

		mean = computeMean(values);
		dev = computeStdDev(values,mean);
		result = computeFFTFeatures(values);
		features[18] = mean;
		features[19] = dev;
		features[20] = computeCrossingRate(values,mean);
		for(int i=21;i<25;i++)
			features[i] = result[i-21];
		//may change where these values go in the array
		for(int i=1;i<values.length;i++){
			//change in z velocity from time i-1 to time i
			features[25] += values[i-1]*(times[i]-times[i-1]);
			//two times the z distance from time i-1 to time i
			features[26] += Math.abs(values[i-1]*(times[i]-times[i-1]));
		}

		//features of the speed
		values = speedVector.toArray(new Double[0]);
		mean = computeMean(values);
		dev = computeStdDev(values,mean);
		result = computeFFTFeatures(values);
		features[27] = mean;
		features[28] = dev;
		features[29] = computeCrossingRate(values,mean);
		for(int i=30;i<33;i++)
			features[i] = result[i-30];

		//features of the energy
		values = energyVector.toArray(new Double[0]);
		mean = computeMean(values);
		dev = computeStdDev(values,mean);
		result = computeFFTFeatures(values);
		features[33] = mean;
		features[34] = dev;
		features[35] = computeCrossingRate(values,mean);
		for(int i=36;i<40;i++)
			features[i] = result[i-36];

		//features of energyXY
		values = energyXYVector.toArray(new Double[0]);
		mean = computeMean(values);
		dev = computeStdDev(values,mean);
		features[40] = mean;
		features[41] = dev;
		features[42] = computeCrossingRate(values,mean);

		
		return features;
	}

	public double computeCorrelation(Double x[], Double y[], double xmean, double ymean,
			double xstd, double ystd) {
		double corr = 0;
		for(int i=0;i<x.length && i<y.length;i++)
			corr += (x[i]-xmean)*(y[i]-ymean);
		double len = (x.length<y.length?x.length:y.length);
		corr = corr/len;
		if(xstd!=0.0 && ystd!=0.0)
			return corr/(xstd*ystd);
		return 0.0;
	}

	public double computeCrossingRate(Double values[], double mean){
		if(values.length<=1)
			return 0.0;
		double rate = 0.0;
		for(int i=0;i<values.length;i++){
			if(i>0 && ((values[i]>mean && values[i-1]<mean)|| (values[i]<mean && values[i]>mean)))
				rate = rate +1;
		}
		rate = rate/(values.length-1);
		return rate;

	}

	public double[] computeMinMax(Double values[]){
		double result[] = new double[2];
		result[0] = -1.0e7;
		result[1] = 1.0e7;
		for(int i=0;i<values.length;i++){
			if(values[i]>result[0])
				result[0] = values[i];
			if(values[i]<result[1])
				result[1] = values[i];
		}
		return result;
	}

	public double[] computeFFTFeatures(Double values[]){
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

		Coefficient coeffs[] = new Coefficient[x.length];
		for(i=0;i<coeffs.length;i++)
			coeffs[i] = new Coefficient(x[i],y[i],(360.0*i)/coeffs.length);
		Arrays.sort(coeffs);

		Coefficient coeffs2[] = new Coefficient[x.length];
		for(i=0;i<x.length;i++)
			coeffs2[i] = coeffs[x.length-1-i];
		double result[] = new double[10];
		int len = (coeffs2.length>5?5:coeffs2.length);
		boolean NEW = false;
		for(i=0,j=0;i<len;i++,j++){
			if(NEW && i>0 && j<coeffs2.length && Math.abs(coeffs2[j].abs-coeffs2[j-1].abs)<=0.00001){
				i--;
				continue;
			}
			if(NEW && j>=coeffs2.length)
				break;
			result[2*i] = coeffs2[j].abs;
			result[2*i+1] = coeffs2[j].freq;

		}
		return result;

	}

	class Coefficient implements Comparable<Coefficient>{
		double re;
		double im;
		double freq;
		double abs;

		Coefficient(double x, double y, double frequency){
			re = x;
			im = y;
			freq = frequency;
			abs = Math.hypot(x, y);
		}

		public int compareTo(Coefficient c){
			if((this.abs - c.abs)>0.0)//0001)
				return 1;
			/*else if(Math.abs(this.abs-c.abs)<0.00001) {
				if(this.freq<c.freq)
					return 1;
				else
					return -1;
			}*/
			else return -1;
		}
	}

	public void calculateCoeff(Double data[], double delta[]){
		int size = data.length;
		int loop = (int)(StrictMath.log(size)/StrictMath.log(2));
		double avg[] = new double[size];

		int start = size/2;
		double max = -1000000;
		double min = 1000000;
		for(int i=0;i<start;i++){
			delta[start+i] = (data[2*i]-data[2*i+1])/2;
			avg[start+i] = (data[2*i]+data[2*i+1])/2;
			if(delta[start+i]>max)
				max = delta[start+i];
			if(delta[start+i]<min)
				min = delta[start+i];
		}
		int finish = start;
		for(int j=1;j<loop;j++){
			finish = start;
			start = start/2;
			for(int i=0;i<start;i++){
				delta[start+i] = (avg[2*i+finish]-avg[2*i+1+finish])/2;
				avg[start+i] = (avg[2*i+finish]+avg[2*i+1+finish])/2;

			}
		}
		delta[0] = avg[1];
		for(int i=0;i<delta.length;i++){
			if(delta[i]<0.5*max && delta[i]>0.5*min)
				delta[i] =0.0;
		}
	}

	public Double[] getData(int level, double delta[]){
		Double data[] = new Double[(int)Math.pow(2, level)];
		int start = (int)Math.pow(2,level);
		for(int i=0;i<data.length;i++){
			data[i] = delta[0];
			for(int j=0;j<level;j++)
				data[i] += signum((start+i)/(int)Math.pow(2, j+1),(start+i)/(int)Math.pow(2, j))
				*delta[(start+i)/(int)Math.pow(2, j+1)];
		}
		return data;
	}

	int signum(int parent,int child){
		if(2*parent==child)
			return 1;
		else 
			return -1;
	}

	@Override
	public IStreamItem getNextItem() {
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


	private boolean readNext() {
		if(child==null)
		{
			verifiedNext = true;
			return false;
		}
		if(currentIndex!=-1 && currentIndex<output.size())
		{
			verifiedNext = true;
			if(output.get(currentIndex)!=null)
				return true;
			else return false;
		}
		if(currentIndex==-1 || currentIndex>=output.size())
		{
			if(!child.hasNext())
			{
				verifiedNext = true;
				return false;
			}

			boolean success = false;
			//read next Accel Window
			success = readAccelWindow();
			if(!success)
			{	
				//Failed because no items left in stream
				verifiedNext = true;
				return false;
			}
			
			//Data read, now extract features
			double[] next = extractFeatures3();
			//Clear old values in output
			output.clear();

			//Add new values in output
			Object outputVals[] = new Object[next.length+1];
			
			for(int j=0; j<next.length; j++){
				outputVals[j] = next[j];
			}
			IStreamItem outItem = null;
			//The following condition will always be true because we verified this in readAccelWindow
			if(validDataPoints>0){
				outputVals[next.length] = data[0].getLabel();
				outItem = new IStreamItem(data[0].timeStamp,outputVals);
			}
			currentIndex = 0;
			output.add(outItem);
			
			verifiedNext = true;
			return true;
		}
		Logger.error("SHOULD not arrive here");
		verifiedNext = true;
		return false;
		//Done
	}
	
	private boolean readAccelWindow(){
		boolean success = true;
		data = new AccelValuesItem[READ_LIMIT];
		clearValues();
		validDataPoints = 0;
		
		AccelValuesItem item = null;
		int i = 0;
		
		do{
			while(success){
				if(child.hasNext()){
					item = child.getNextItem();
					//if(i == 0 && item.getLabel() == null)
						//label = item.getLabel();
					try{
						//this is rather sloppy, should improve later
						data[i] = item;
						parseItem(item);
						i++;
						validDataPoints++;
						break;
					} catch(Exception e){
						e.printStackTrace();
						Logger.error("Error in parsing item:"+e.getLocalizedMessage());
						continue;
					}
				}
				else{
					//Exhausted Stream
					success = false;
					data[i] = null;
					break;
				}
			}
			//breaks the loop if the child doesn't have a next value
			if(!child.hasNext()){
				success = false;
				break;
			}
		} while(item!=null && data[0]!=null && item.timeStamp - data[0].timeStamp < WINDOW && i<READ_LIMIT);
		
		//Return true if at least 1 sample was read
		if(validDataPoints>0) return true;
		return false;
	}
	
	private void parseItem(AccelValuesItem item){
		addTime(item.timeStamp);
		double speed = Math.sqrt(Math.pow(item.getOrientX(),2)+Math.pow(item.getOrientY(),2)+Math.pow(item.getOrientZ(),2));
		addValues(item.getOrientX(), item.getOrientY(), item.getOrientZ(), speed);
		addEnergyValues(item.getOrientX(),item.getOrientY(),item.getOrientZ());
	}

	private IStreamItem seekNextItem(){
		IStreamItem item = output.get(currentIndex);
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
			IStreamItem item = getNextItem();
			IOUtils.writeLine(item.toString(), bw);
		}
		IOUtils.close(bw);
	}
}

package edu.umass.cs.sensors.wavelet;


public class Wavelet {

	
	public Wavelet(){
	}
	
	
	public void calculateCoeff(double data[], double delta[]){
		//double data[] = new double[]{9,3,6,2,8,4,5,7};
		int size = data.length;
		int loop = (int)(StrictMath.log(size)/StrictMath.log(2));
		double avg[] = new double[size];
		
		int start = size/2;
		for(int i=0;i<start;i++){
			delta[start+i] = (data[2*i]-data[2*i+1])/2;
			avg[start+i] = (data[2*i]+data[2*i+1])/2;

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
	}
	
	public double[] getData(int level, double delta[]){
		double data[] = new double[(int)Math.pow(2, level)];
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
	
	
}

package edu.umass.cs.sensors.features;

import java.util.Arrays;



public class FFTFeature{

	private int SAMPLE_RATE = 8; //in Hz
	
	public FFTFeature(int SAMPLE_RATE){
		this.SAMPLE_RATE = SAMPLE_RATE;
	}
	
	/**
	 * Get FFT coefficients in sorted order
	 * @param values
	 * @return
	 */
	public Coefficient[] getSortedFFT(Double values[]) {
		Coefficient coeffs[] = getFFT(values);
		Arrays.sort(coeffs);
		return coeffs;
	}
	
	/**
	 * Convert coefficient array to double array
	 * @param coeffs
	 * @return
	 */
	public double[] convertCoeffsToDoubleArray(Coefficient coeffs[]) {
		double result[] = new double[coeffs.length*2];
		int len = coeffs.length;
		int i=0,j=0;
		for(i=0,j=0;i<len;i++,j++){
			result[2*i] = coeffs[j].abs;
			result[2*i+1] = coeffs[j].freq;
		}
		return result;
	}
	
	
	
	
	/**
	 * Get FFT Coefficients
	 * @param values
	 * @return
	 */
	public Coefficient[] getFFT(Double values[]){
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
			coeffs[i] = new Coefficient(x[i],y[i],(1.0*i*SAMPLE_RATE)/coeffs.length);
		//coeffs[i] = new Coefficient(x[i],y[i],(360.0*i*SAMPLE_RATE)/coeffs.length);
		return coeffs;

	}

	public class Coefficient implements Comparable<Coefficient>{
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
		
		public double getFrequency(){
			return freq;
		}
		
		public double getEnergy(){
			return abs;
		}
	}

	

}

/**
 * 
 */
package edu.umass.cs.sensors.cluster;

import Jama.Matrix;

/**
 * Clustering algorithm for k soft GMM clusters based on Expectation-Maximization. 
 * @author Abhinav Parate
 * 
 */
public class GaussianCluster {

	/**
	 * Training data points
	 */
	private double[][] dataPoints = null;
	
	/**
	 * Number of components
	 */
	private int k = 1;
	/**
	 * Array containing mixing coefficients for the k GMM components
	 */
	private double pi[] = null; // mix coefficients
	/**
	 * Array containing k GMM components
	 */
	private MixtureComponent components[] = null;
	/**
	 * Number of iterations to perform in training
	 */
	private int nIter = 1;

	/**
	 * Constructor for this class
	 * @param k Number of components to generate
	 * @param dataPoints Training data: array of n-dimension data points
	 * @param nIterations Number of iterations to perform
	 */
	public GaussianCluster(int k, double[][] dataPoints, int nIterations) {
		this.dataPoints = dataPoints;
		this.k = k;
		this.nIter = nIterations;
	}

	/**
	 * Learn GMM components
	 */
	public void learnComponents() {
		long st = System.currentTimeMillis();
		//Initialize by setting initial components using K-Means
		initialize();
		long et = System.currentTimeMillis();
		System.out.println("Finished GMM components initialization in "+(et-st)/1000+" secs");
		et = st;

		for(int i=0;i<nIter;i++) {
			iterateGMMComponents();
			if(i%100==0) {
				et = System.currentTimeMillis();
				System.out.println("Finished iterations:"+i+" in "+(et-st)/1000+" secs");
			}
		}
	}
	
	/**
	 * Get Gaussian Mixture components
	 * @return array of k mixture components
	 */
	public MixtureComponent[] getGMMComponents() {
		return components;
	}
	
	/**
	 * Returns prior probabilities of the mixture components
	 * @return array of prior-probabilities for k components
	 */
	public double[] getPriorComponentProbabilities() {
		return pi;
	}

	/**
	 * Prints the GMM components
	 */
	public void printGMMComponents() {
		System.out.println("#index weight coordinates covariance");
		for(int i=0;i<components.length;i++) {
			double mean[] = components[i].getMean();
			String x = mean[0]+"";
			for(int j=1;j<mean.length;j++)
				x+= (","+mean[j]);
			Matrix cov = components[i].getCovarianceMatrix();

			int row = cov.getRowDimension();
			int col = cov.getColumnDimension();
			for(int j=0;j<row;j++)
				for(int k=0;k<col;k++)
					x += (","+cov.get(j, k));
			System.out.println(i+","+pi[i]+","+x);
		}
	}

	/**
	 * Initialize GMM components
	 */
	private void initialize() {
		//Initialize GMMs
		//We use output of k-means clustering algorithm to set initial components
		KMeansCluster cluster = new KMeansCluster(k, nIter, dataPoints);
		cluster.startAnalysis();
		Centroid centroid[] = cluster.getCentroids();
		if(centroid.length!=k){
			System.err.println("ERROR: Number of centroids:"+centroid.length+" obtained is not equal to k="
					+k+" in initialization phase");
			System.exit(1);
		}
		MixtureComponent gc[] = new MixtureComponent[k];
		pi = new double[k];
		for(int i=0;i<k;i++) {
			Centroid c = centroid[i];
			c.calculateMeanAndCovariance();
			double mean[] = c.getMean();
			String out = i+"";
			for(int j=0;j<mean.length;j++) {
				out += (","+mean[j]);
			}
			System.out.println(out);
			double cov[][] = c.getCovariance();
			Matrix covMatrix = new Matrix(cov);

			pi[i] = (1.0*c.getCluster().getNumDataPoints())/dataPoints.length;
			MixtureComponent g = new MixtureComponent();
			g.setValues(mean, covMatrix);
			gc[i] = g;
		}
		this.components = gc;
	}

	/**
	 * Iteratively correct GMM component parameters
	 */
	private void iterateGMMComponents() {
		
		//For each data point, we compute its weight contribution to each centroid
		//gamma is also called responsibility of k^th GMM component for vector/data point x_i
		double gamma[][] = new double[dataPoints.length][k];
		
		//Sum of contributions to k-components from vector x_i
		double sumGamma[] = new double[dataPoints.length];
		
		//Iterate on each data point
		for(int i=0;i<dataPoints.length;i++) {
			double x[] = dataPoints[i];
			//Iterate on each component, getting contribution of i^th data point
			for(int j=0; j<k; j++) {
				gamma[i][j] = pi[j]*components[j].getProbabilityDensity(x); //pi_j*pdf(x_i| mu_j,Sigma_j)
				sumGamma[i] += gamma[i][j];
			}
		}

		double N[] = new double[k]; 
		//N_k gives the effective number of vectors/data points assigned to k^th GMM component
		//N_k = Sum_i gamma_i,k where gamma_i,k is normalized using sumgamma_i
		for(int i=0;i<k;i++) {
			for(int j=0; j<dataPoints.length;j++) {
				//Looking for contribution of j^th data point in i^th component
				N[i] += (gamma[j][i]/sumGamma[j]);
			}
		}

		//Now, compute new weighted mean for each component
		int nDims = dataPoints[0].length;
		double mean[][] = new double[k][nDims]; //Each mean vector has nDims dimensions
		for(int i=0;i<dataPoints.length;i++) {
			double x[] = dataPoints[i];
			//Compute mean vector for each component
			for(int j=0;j<k; j++) {
				//Compute l^th dimension of mean vector
				for(int l=0;l<nDims;l++) {
					//mean for j^th component/ l^th dimension
					mean[j][l] += ((1.0/N[j]) * (gamma[i][j]*x[l]/sumGamma[i]));
				}
			}
			//Added contribution of i^th data point to mean
		}
		//Re-estimation of mean complete
		//Estimate covariance now
		for(int i=0; i<k; i++) {
			double cov[][] = new double[nDims][nDims];
			Matrix covMatrix = new Matrix(cov);
			for(int j=0; j<dataPoints.length;j++ ) {
				double x[] = dataPoints[j];
				double norm[][] = new double[1][x.length];
				for(int l=0;l<norm[0].length;l++)
					norm[0][l] = x[l] - mean[i][l];
				Matrix normMatrix = new Matrix(norm);
				Matrix tmp = (normMatrix.transpose().times(normMatrix)).times(gamma[j][i]/(sumGamma[j]*N[i]));
				covMatrix = covMatrix.plus(tmp);
			}
			components[i].setValues(mean[i], covMatrix);
		}

		//Re-estimate pi
		for(int i=0;i<k;i++)
			pi[i] = N[i]/dataPoints.length;
	}

}



/**
 * @author Abhinav Parate
 * 
 */
class MixtureComponent {

	/**
	 * Mean vector of the component
	 */
	private double mean[] = null;

	/**
	 * Inverse of a covariance matrix for this component.
	 */
	private Matrix invMatrix  = null;

	/**
	 * Determinant of the covariance matrix
	 */
	private double det = 0.0;

	/**
	 * Assign parameters for this component
	 * @param mean
	 * @param covariance
	 */
	public void setValues(double mean[], Matrix covariance) {

		Matrix tmp = invMatrix;
		try {
			this.invMatrix = covariance.inverse();
		} catch(Exception e){
			//Possibly we have met a singular matrix that cannot be inverted
			System.out.println("ERROR:"+e.getLocalizedMessage());
			System.out.println("Dimensions:"+covariance.getRowDimension()+"x"+covariance.getColumnDimension() + " Determinant:"+covariance.det());
			//Retain the old component values in this case
			this.invMatrix = tmp;
			return;
		}
		this.mean = mean;
		this.det = covariance.det();
	}

	/**
	 * Compute PDF for a given input vector x
	 * @param x
	 * @return probability density
	 */
	public double getProbabilityDensity(double x[]) {
		double density = 0.0;
		//Norm matrix containing [x-mu]
		double norm[][] = new double[1][x.length];
		for(int i=0;i<norm[0].length;i++)
			norm[0][i] = x[i] - mean[i];
		Matrix normMatrix = new Matrix(norm);
		double exponent = ((normMatrix.times(invMatrix) ).times(normMatrix.transpose())).get(0, 0)*(-0.5);
		double denom = Math.sqrt(Math.pow(2*Math.PI, mean.length)*det);
		density = (1.0/denom)*Math.pow(Math.E, exponent);
		return density;
	}

	/**
	 * Get mean of this component
	 * @return array containing n-values corresponding to n-dimensions
	 */
	public double[] getMean() {
		return mean;
	}

	/**
	 * Get covariance matrix of this component
	 * @return matrix of size nxn where n is the number of dimensions
	 */
	public Matrix getCovarianceMatrix() {
		return invMatrix.inverse();
	}
}



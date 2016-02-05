package edu.umass.cs.sensors.cluster;

import java.util.Iterator;
import java.util.Vector;


public class KMeansCluster {
	
	public static void main (String args[]){
		Vector<DataPoint> dataPoints = new Vector<DataPoint>();
		dataPoints.add(new DataPoint(new double[]{22,21},"c53"));
		dataPoints.add(new DataPoint(new double[]{22,21},"d53"));
		dataPoints.add(new DataPoint(new double[]{22,21},"e53"));
		dataPoints.add(new DataPoint(new double[]{22,21},"b53"));
		dataPoints.add(new DataPoint(new double[]{22,21},"p53"));
		dataPoints.add(new DataPoint(new double[]{19,20},"bcl2"));
		dataPoints.add(new DataPoint(new double[]{18,22},"fas"));
		dataPoints.add(new DataPoint(new double[]{1,3},"amylase"));
		dataPoints.add(new DataPoint(new double[]{3,2},"maltase"));

		KMeansCluster jca = new KMeansCluster(2,100,dataPoints);
		jca.startAnalysis();

		Vector<DataPoint>[] v = jca.getClusterOutput();
		for (int i=0; i<v.length; i++){
			Vector<DataPoint> tempV = v[i];
			System.out.println("-----------Cluster"+i+"---------");
			Iterator<DataPoint> iter = tempV.iterator();
			while(iter.hasNext()){
				DataPoint dpTemp = iter.next();
				String xs = "";
				double x[] = dpTemp.getX();
				for(int j=0;j<x.length;j++)
					xs += ((j>0?",":"")+x[j]);
				System.out.println(dpTemp.getObjName()+
						"["+xs+"]");
			}
		}
	}
	
	private Cluster[] clusters;
	private int miter;
	private Vector<DataPoint> mDataPoints = new Vector<DataPoint>();
	private double mSWCSS;

	/**
	 * Constructor
	 * @param k number of clusters desired
	 * @param iter number of iterations to perform
	 * @param dataPoints vector containing data points
	 */
	public KMeansCluster(int k, int iter, Vector<DataPoint> dataPoints) {
		clusters = new Cluster[k];
		for (int i = 0; i < k; i++) {
			clusters[i] = new Cluster("Cluster" + i);
		}
		this.miter = iter;
		this.mDataPoints = dataPoints;
	}
	
	/**
	 * Constructor
	 * @param k number of clusters desired
	 * @param iter number of iterations to perform
	 * @param dataPoints array containing data vectors
	 */
	public KMeansCluster(int k, int iter, double dataPoints[][]) {
		clusters = new Cluster[k];
		for (int i = 0; i < k; i++) {
			clusters[i] = new Cluster("Cluster" + i);
		}
		this.miter = iter;
		for (int i=0; i<dataPoints.length;i++) {
			DataPoint dp = new DataPoint(dataPoints[i],i+"");
			mDataPoints.add(dp);
		}
		//this.mDataPoints = dataPoints;
	}

	private void calcSWCSS() {
		double temp = 0;
		for (int i = 0; i < clusters.length; i++) {
			temp = temp + clusters[i].getSumSqr();
		}
		mSWCSS = temp;
	}

	/**
	 * Learns the clusters
	 */
	public void startAnalysis() {
		//set Starting centroid positions - Start of Step 1
		setInitialCentroids();
		int n = 0;
		//assign DataPoint to clusters
		loop1: while (true) {
			for (int l = 0; l < clusters.length; l++) 
			{
				clusters[l].addDataPoint(mDataPoints.elementAt(n));
				n++;
				if (n >= mDataPoints.size())
					break loop1;
			}
		}

		//calculate E for all the clusters
		calcSWCSS();

		//recalculate Cluster centroids - Start of Step 2
		for (int i = 0; i < clusters.length; i++) {
			clusters[i].getCentroid().calcCentroid();
		}

		//recalculate E for all the clusters
		calcSWCSS();

		for (int i = 0; i < miter; i++) {
			//enter the loop for cluster 1
			for (int j = 0; j < clusters.length; j++) {
				for (int k = 0; k < clusters[j].getNumDataPoints(); k++) {

					//pick the first element of the first cluster
					//get the current Euclidean distance
					double tempEuDt = clusters[j].getDataPoint(k).getCurrentEuDt();
					Cluster tempCluster = null;
					boolean matchFoundFlag = false;
					
					//call testEuclidean distance for all clusters
					for (int l = 0; l < clusters.length; l++) {
						if(l==j) continue;
						//if testEuclidean < currentEuclidean then
						if (tempEuDt > clusters[j].getDataPoint(k).testEuclideanDistance(clusters[l].getCentroid())) {
							tempEuDt = clusters[j].getDataPoint(k).testEuclideanDistance(clusters[l].getCentroid());
							tempCluster = clusters[l];
							//System.out.println(i+" "+j+" "+" "+k+" "+l+" "+tempEuDt);
							matchFoundFlag = true;
						}
						//if statement - Check whether the Last EuDt is > Present EuDt 

					}
					//for variable 'l' - Looping between different Clusters for matching a Data Point.
					//add DataPoint to the cluster and calcSWCSS

					if (matchFoundFlag) {
						tempCluster.addDataPoint(clusters[j].getDataPoint(k));
						clusters[j].removeDataPoint(clusters[j].getDataPoint(k));
						k--;
						for (int m = 0; m < clusters.length; m++) {
							clusters[m].getCentroid().calcCentroid();
						}

						//for variable 'm' - Recalculating centroids for all Clusters

						calcSWCSS();
					}

					//if statement - A Data Point is eligible for transfer between Clusters.
				}
				//for variable 'k' - Looping through all Data Points of the current Cluster.
			}//for variable 'j' - Looping through all the Clusters.
		}//for variable 'i' - Number of iterations.
	}

	/**
	 * Returns clustering output
	 * @return array of vector containing {@link DataPoints} corresponding for each cluster 
	 */
	public Vector<DataPoint>[] getClusterOutput() {
		@SuppressWarnings("unchecked")
		Vector<DataPoint> v[] = new Vector[clusters.length];
		for (int i = 0; i < clusters.length; i++) {
			v[i] = clusters[i].getDataPoints();
		}
		return v;
	}


	private void setInitialCentroids() {
		//kn = (round((max-min)/k)*n)+min where n is from 0 to (k-1).
		int nCoords = mDataPoints.elementAt(0).getX().length;
		
		for (int n = 1; n <= clusters.length; n++) {
			double cx[] = new double[nCoords];
			double max[] = getMaxValues();
			double min[] = getMinValues();
			for(int j=0;j<nCoords;j++) {
				cx[j] = (((max[j]-min[j])/ (clusters.length + 1) * n) + min[j]);
			}
			
			Centroid c1 = new Centroid(cx);
			clusters[n - 1].setCentroid(c1);
			c1.setCluster(clusters[n - 1]);
		}
	}

	private double[] getMaxValues() {
		double temp[];
		temp = new double[mDataPoints.elementAt(0).getX().length];
		int nCoord = temp.length;

		for (int i = 0; i < mDataPoints.size(); i++) {
			DataPoint dp = mDataPoints.elementAt(i);
			for(int j=0;j<nCoord;j++) {
				temp[j] = (dp.getX()[j] > temp[j]) ? dp.getX()[j] : temp[j];
			}
		}
		return temp;
	}

	private double[] getMinValues() {
		double temp[];
		temp = new double[mDataPoints.elementAt(0).getX().length];
		int nCoord = temp.length;

		for (int i = 0; i < mDataPoints.size(); i++) {
			DataPoint dp = mDataPoints.elementAt(i);
			for(int j=0;j<nCoord;j++) {
				temp[j] = (dp.getX()[j] < temp[j]) ? dp.getX()[j] : temp[j];
			}
		}
		return temp;
	}

		

	/**
	 * Returns number of clusters
	 * @return number k
	 */
	public int getKValue() {
		return clusters.length;
	}

	/**
	 * Return number of iterations performed
	 * @return number of iterations
	 */
	public int getIterations() {
		return miter;
	}

	/**
	 * Returns total number of data points used in learning
	 * @return number of data points
	 */
	public int getTotalDataPoints() {
		return mDataPoints.size();
	}

	public double getSWCSS() {
		return mSWCSS;
	}

	/**
	 * Returns cluster at k-th position
	 * @param pos
	 * @return k-th cluster
	 */
	public Cluster getCluster(int pos) {
		return clusters[pos];
	}

	/**
	 * Returns centroids corresponding to clusters
	 * @return array of centroids
	 */
	public Centroid[] getCentroids() {
		Centroid centroids[] = new Centroid[clusters.length];
		for(int i=0;i<centroids.length;i++)
			centroids[i] = clusters[i].getCentroid();
		return centroids;
	}
	
	/**
	 * Returns the cluster closest to a given data point
	 * @param x vector representing a data point
	 * @return index of the cluster
	 */
	public int getClosestCluster(double x[]) {
		double dist = Double.POSITIVE_INFINITY;
		int min = -1;
		DataPoint dp = new DataPoint(x, "t");
		for(int i=0;i<clusters.length;i++) {
			double testDist = dp.testEuclideanDistance(clusters[i].getCentroid());
			if(testDist <dist) {
				dist = testDist;
				min = i;
			}
		}
		return min;
	}
}



/**
 * This class represents a Cluster in a Cluster Analysis Instance. A Cluster is associated
 * with one and only one JCA Instance. A Cluster is related to more than one DataPoints and
 * one centroid.
 * @author Shyam Sivaraman
 * @version 1.1
 * @see DataPoint
 * @see Centroid
 */



class Cluster {
	private String mName;
	private Centroid mCentroid;
	private double mSumSqr;
	private Vector<DataPoint> mDataPoints;

	/**
	 * Constructor
	 * @param name name of the cluster
	 */
	public Cluster(String name) {
		this.mName = name;
		this.mCentroid = null; //will be set by calling setCentroid()
		mDataPoints = new Vector<DataPoint>();
	}

	/**
	 * Sets centroid for this cluster
	 * @param c
	 */
	public void setCentroid(Centroid c) {
		mCentroid = c;
	}

	/**
	 * Get centroid for this cluster.
	 * @return Centroid
	 */
	public Centroid getCentroid() {
		return mCentroid;
	}

	/**
	 * Add a data point to this cluster
	 * @param dp
	 */
	public void addDataPoint(DataPoint dp) { //called from CAInstance
		dp.setCluster(this); //initiates a inner call to
		//calcEuclideanDistance() in DP.
		this.mDataPoints.addElement(dp);
		calcSumOfSquares();
	}

	/**
	 * Remove a data point from this cluster
	 * @param dp
	 */
	public void removeDataPoint(DataPoint dp) {
		this.mDataPoints.removeElement(dp);
		calcSumOfSquares();
	}

	/**
	 * Number of data points in this cluster
	 * @return number of data points
	 */
	public int getNumDataPoints() {
		return this.mDataPoints.size();
	}

	/**
	 * Returns i-th data point
	 * @param pos
	 * @return data point instance
	 */
	public DataPoint getDataPoint(int pos) {
		return this.mDataPoints.elementAt(pos);
	}

	public void calcSumOfSquares() { //called from Centroid
		int size = this.mDataPoints.size();
		double temp = 0;
		for (int i = 0; i < size; i++) {
			temp = temp + this.mDataPoints.elementAt(i).getCurrentEuDt();
		}
		this.mSumSqr = temp;
	}

	public double getSumSqr() {
		return this.mSumSqr;
	}

	public String getName() {
		return this.mName;
	}

	/**
	 * Returns data points in this cluster
	 * @return vector containing data points
	 */
	public Vector<DataPoint> getDataPoints() {
		return this.mDataPoints;
	}

}


/**
 * This class represents the Centroid for a Cluster. The initial centroid is calculated
 * using a equation which divides the sample space for each dimension into equal parts
 * depending upon the value of k.
 * @author Shyam Sivaraman
 * @version 1.0
 * @see Cluster
 */
class Centroid {
	private double mCx[];
	private Cluster mCluster;

	/**
	 * Constructor
	 * @param cx vector representing coordinates of the centroid
	 */
	public Centroid(double cx[]) {
		this.mCx = cx;
	}

	/**
	 * Re-calculate centroid position based on the data points associated with the cluster. 
	 */
	public void calcCentroid() { //only called by CAInstance
		int numDP = this.mCluster.getNumDataPoints();
		
		int i;
		int nCoordinates = this.mCx.length;
		double tempX[] = new double[nCoordinates];
		//caluclating the new Centroid
		for (i = 0; i < numDP; i++) {
			double pX[] = mCluster.getDataPoint(i).getX();
			for(int j=0;j<pX.length;j++) {
				tempX[j] = tempX[j] + pX[j];
			} 
			//total for each coordinate
		}
		for(int j=0;j<nCoordinates;j++) {
			this.mCx[j] = tempX[j] / numDP;
		}
		//calculating the new Euclidean Distance for each Data Point
		tempX = null;
		for (i = 0; i < numDP; i++) {
			mCluster.getDataPoint(i).calcEuclideanDistance();
		}
		//calculate the new Sum of Squares for the Cluster
		mCluster.calcSumOfSquares();
	}

	/**
	 * Assign this centroid to a given cluster
	 * @param c cluster
	 */
	public void setCluster(Cluster c) {
		this.mCluster = c;
	}

	/**
	 * Gets centroid coordinates
	 * @return array containing coordinates
	 */
	public double[] getCx() {
		return this.mCx;
	}

	private double meanValues[] = null;
	private double cov[][] = null;
	
	/**
	 * Returns mean vector corresponding to the data points in the associated cluster.
	 * <p>Use calculateMeanAndCovariance() prior to calling this method.
	 * @return array containing means
	 */
	public double[] getMean() {
		return meanValues;
	}
	
	/**
	 * Returns covariance matrix for the data points in the associated cluster
	 * <p>Use calculateMeanAndCovariance() prior to calling this method.
	 * @return 2-dimensional array containing covariance values
	 */
	public double[][] getCovariance() {
		return cov;
	}
	
	/**
	 * Calculate mean and Covariance.
	 */
	public void calculateMeanAndCovariance() {
		int numDP = this.mCluster.getNumDataPoints();
		
		int nCoordinates = this.mCx.length;
		double input[][] = new double[numDP][];
		//caluclating the new Centroid
		for (int i = 0; i < numDP; i++) {
			double pX[] = mCluster.getDataPoint(i).getX();
			input[i] = pX;
		}
		meanValues = new double[nCoordinates];
		int numDataVectors = input.length;
		int n = input[0].length;

		double[] sum = new double[n];
		double[] mean = new double[n];
		for (int i = 0; i < numDataVectors; i++) {
			double[] vec = input[i];
			for (int j = 0; j < n; j++) {
				sum[j] = sum[j] + vec[j];
			}
		}
		for (int i = 0; i < sum.length; i++) {
			mean[i] = sum[i] / numDataVectors;
		}

		double[][] ret = new double[n][n];
		for (int i = 0; i < n; i++) {
			for (int j = i; j < n; j++) {
				double v = calcCovariance(input, i, j, mean);
				ret[i][j] = v;
				ret[j][i] = v;
			}
		}
		if (meanValues != null) {
			System.arraycopy(mean, 0, meanValues, 0, mean.length);
		}
		cov = ret;
	}
	
	/**
	 * Gives covariance between vectors in an n-dimensional space. The two input arrays store values
	 * with the mean already subtracted. Read the code.
	 */
	private double calcCovariance(double[][] matrix, int colA, int colB, double[] mean) {
		double sum = 0;
		for (int i = 0; i < matrix.length; i++) {
			double v1 = matrix[i][colA] - mean[colA];
			double v2 = matrix[i][colB] - mean[colB];
			sum = sum + (v1 * v2);
		}
		int n = matrix.length;
		double ret = (sum / (n - 1));
		return ret;
	}

	/**
	 * Get cluster associated with this Centroid
	 * @return Cluster
	 */
	public Cluster getCluster() {
		return mCluster;
	}

}


/**
    This class represents a candidate for Cluster analysis. A candidate must have
    a name and two independent variables on the basis of which it is to be clustered.
    A Data Point must have two variables and a name. A Vector of  Data Point object
    is fed into the constructor of the JCA class. JCA and DataPoint are the only
    classes which may be available from other packages.
    @author Shyam Sivaraman
    @version 1.0
    @see KMeansCluster
    @see Cluster
 */

class DataPoint {
	private double X[];
	private String mObjName;
	private Cluster mCluster;
	private double mEuDt;

	public DataPoint(double x[], String name) {
		this.X = x;
		this.mObjName = name;
		this.mCluster = null;
	}

	public void setCluster(Cluster cluster) {
		this.mCluster = cluster;
		calcEuclideanDistance();
	}
		

	public double euclideanDistance(double x1[], double x2[]) {
		double ret = 0.0;
		for(int i=0;i<x1.length;i++)
			ret += Math.pow(x1[i]-x2[i], 2);
		return Math.sqrt(ret);
	}

	public void calcEuclideanDistance() { 

		mEuDt = euclideanDistance(X,mCluster.getCentroid().getCx());
		//called when DP is added to a cluster or when a Centroid is recalculated.
	}

	public double testEuclideanDistance(Centroid c) {
		return euclideanDistance(X,c.getCx());
	}

	public double[] getX() {
		return X;
	}


	public Cluster getCluster() {
		return mCluster;
	}

	public double getCurrentEuDt() {
		return mEuDt;
	}

	public String getObjName() {
		return mObjName;
	}

	public int getBestCentroid(Centroid centroids[]) {
		double best = -1.0;
		int index = 0; 
		for(int i=0;i<centroids.length;i++) {
			double dist = testEuclideanDistance(centroids[i]);
			if(best==-1.0 || dist<best)
			{
				best = dist;
				index = i;
			}
		}
		return index;
	}
}


/**
 * Created by IntelliJ IDEA.
 * User: shyam.s
 * Date: Apr 18, 2004
 * Time: 4:26:06 PM
 */
class PrgMain {
	
}
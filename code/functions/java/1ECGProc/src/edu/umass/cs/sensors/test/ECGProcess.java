/**
 * 
 */
package edu.umass.cs.sensors.test;

import org.mstream.stream.ecg.AllFeaturesOperator;
import org.mstream.stream.ecg.RPeakDetectOperator;
import org.mstream.stream.ecg.RRAllPeaksDetectOperator;
import org.mstream.stream.ecg.RRInterpolateOperator;
import org.mstream.stream.ecg.RRSmoothOperator;
import org.mstream.stream.file.SVFileStream;
import org.mstream.stream.file.StringToDoubleItemConverter;

/**
 * @author Abhinav Parate
 * 
 */
public class ECGProcess {

	public void process(String infile, String outfile,int level) {
		
		//Set up processing pipeline
		// CSV file reader
		/**
		 * CSV file has a record per line where each record has a timestamp and an ecg value.
		 * Example record: 2012-06-14 12:32:37.649,509
		 * The timestamp can have a format YYYY-MM-DD HH:MM:SS[.fff] or it can be an epoch timestamp in milliseconds
		 * Example record: 1339677157000,509 
		 */
		SVFileStream svf = new SVFileStream(",");
		svf.addFileToStream(infile, true);
		
		// Covert string values read from file to Double values
		StringToDoubleItemConverter std = new StringToDoubleItemConverter();
		std.addChildStreams(svf);

		// Detect R peaks
		int SAMPLE_RATE = 64; // input data has sampling frequency of 250Hz
		RPeakDetectOperator r = new RPeakDetectOperator(SAMPLE_RATE);
		r.addChildStreams(std);
		if(level==1){r.saveStreamToFile(outfile);r.closeStream();return;}
		
		// Now interpolate R-R waveform data to 100 points
		int NUM_INTERPOLATED_POINTS = 100;
		RRInterpolateOperator ri = new RRInterpolateOperator(NUM_INTERPOLATED_POINTS);
		ri.addChildStreams(r);
		if(level==2){ri.saveStreamToFile(outfile);ri.closeStream();return;}

		// Smoothing the interpolated waveform
		//Default constructor: Do not use if NUM_INTERPOLATED_POINTS is not equal to 100
		//or if you want sliding window of size different then 30 seconds
		RRSmoothOperator rs = new RRSmoothOperator(true);
		//Alternative constructor to specify window size used for smoothing and how the sliding-window shifts
		//int WINDOW_IN_SECS = 30; //30 seconds sliding window
		//int SHIFT_IN_SECS = 5;// 5 seconds shift while sliding
		//RRSmoothOperator rs = new RRSmoothOperator(NUM_INTERPOLATED_POINTS, WINDOW_IN_SECS, SHIFT_IN_SECS);
		rs.addChildStreams(ri);
		if(level==3){rs.saveStreamToFile(outfile);rs.closeStream();return;}
		
		//Detect all peaks P Q R S T
		RRAllPeaksDetectOperator rap = new RRAllPeaksDetectOperator();
		rap.addChildStreams(rs);
		if(level==4){rap.saveStreamToFile(outfile);rap.closeStream();return;}
		//Compute all the features
		AllFeaturesOperator rf = new AllFeaturesOperator(NUM_INTERPOLATED_POINTS);
		rf.addChildStreams(rap);
		if(level==5){rf.saveStreamToFile(outfile);rf.closeStream();return;}
		
		//Save features to file
//		rf.saveStreamToFile("./sample/feature.csv");
//		rf.closeStream();
		
		/**You can save output of any stage to the file, For example to save output of all-peak detection
		/* Use:
		 */
		//rap.saveStreamToFile("./samples/output.csv");
		//rap.closeStream();
		//The above lines will save timestamp, raw-ecg value, processed-value, peak-label
		/**
		 * CAUTION: Output from only one operator can be saved to the file. Any later invocation of 
		 * saveStreamToFile will be ignored. Also, the pipeline execution stops at the operator that
		 * invoked saveStreamToFile. For example, in the above case, if peak detector invokes
		 * rap.saveStreamToFile(...), the next operator AllFeaturesOperator won't be executed.
		 */
		
	}
	
	public static void main(String args[]) {
		if (args.length!=3){
			System.out.println("Number of Arg!=3 (indir,pid,sid)");
			return;
		}
		ECGProcess processor = new ECGProcess();
		String infile=args[0]+"/"+args[1]+"_"+args[2]+"_infile.csv";
		String rpeak=args[0]+"/"+args[1]+"_"+args[2]+"_rpeak.csv";
		String interpolate=args[0]+"/"+args[1]+"_"+args[2]+"_interpolate.csv";
		String smooth=args[0]+"/"+args[1]+"_"+args[2]+"_smooth.csv";
		String peak=args[0]+"/"+args[1]+"_"+args[2]+"_peak.csv";
		String feature=args[0]+"/"+args[1]+"_"+args[2]+"_feature.csv";

		processor.process(infile,rpeak,1);
		processor.process(infile,interpolate,2);
		processor.process(infile,smooth,3);
		processor.process(infile,peak,4);
		processor.process(infile,feature,5);
	}	
}

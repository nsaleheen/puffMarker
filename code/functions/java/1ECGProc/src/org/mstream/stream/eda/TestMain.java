package org.mstream.stream.eda;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Comparator;
import java.util.GregorianCalendar;

import org.mstream.stream.accelerometer.ActivityStream;
import org.mstream.stream.accelerometer.StepsExtractor;
import org.mstream.stream.ecg.ClinicalFeaturesOperator;
import org.mstream.stream.ecg.RPeakDetectOperator;
import org.mstream.stream.ecg.RRAllPeaksDetectOperator;
import org.mstream.stream.ecg.RRInterpolateOperator;
import org.mstream.stream.ecg.RRSmoothOperator;
import org.mstream.stream.file.AggregateOperator;
import org.mstream.stream.file.AggregateOperator.AggregateType;
import org.mstream.stream.file.AggregateOperator.AggregateWindow;
import org.mstream.stream.file.FFTOperator;
import org.mstream.stream.file.LowPassFilter;
import org.mstream.stream.file.LowPassFilter.Filter;
import org.mstream.stream.file.SVFileStream;
import org.mstream.stream.file.StringToDoubleItemConverter;
import org.mstream.stream.items.DoubleValuesItem;

import edu.umass.cs.sensors.cluster.GaussianCluster;
import edu.umass.cs.sensors.cluster.KMeansCluster;
import edu.umass.cs.sensors.utils.io.IOUtils;

/**
 * Temporary Test Class
 * 
 * @author aparate
 * 
 */
public class TestMain {

	public static void convertFFTToHeatMapData(FFTOperator fft, BufferedWriter bw){
		int WINDOW =10;
		int i=0;
		DoubleValuesItem items[] = new DoubleValuesItem[WINDOW];
		while(fft.hasNext()){
			DoubleValuesItem item = fft.getNextItem();
			items[i] = item;
			i++;
			if(i==WINDOW){
				int rows = item.values.length/2;
				int cols = WINDOW;
				Object output[][] = new Object[rows][cols+1];
				for(int j=0;j<item.values.length/2;j++){
					output[j][0] = item.values[2*j];
				}
				for(int j=0;j<WINDOW;j++){
					for(int k=0;k<item.values.length/2;k++){
						output[k][j+1] = items[j].values[2*k+1];
					}
				}
				for(int j=0;j<output.length;j++){
					String s = j*10000+"";
					if(j==output.length-1)
						s = -1*100000+"";
					for(int k=0;k<output[j].length;k++)
						s+=(","+output[j][k]);
					IOUtils.writeLine(s, bw);
				}
				i=0;
			}
		}
		IOUtils.close(bw);
	}

	public static void processECG(){
		@SuppressWarnings("unused")
		String logFile, rootDir, testFile;

		// File
		SVFileStream svf = new SVFileStream(",");
		String file = "/Users/aparate/Downloads/docs/demo/demo_ECG.csv";
		svf.addFileToStream(file, true);

		// File to Double
		StringToDoubleItemConverter std = new StringToDoubleItemConverter();
		std.addChildStreams(svf);

		// Double to Peak
		RPeakDetectOperator r = new RPeakDetectOperator(250);
		r.addChildStreams(std);

		// Peak to interpolate
		RRInterpolateOperator ri = new RRInterpolateOperator();
		ri.addChildStreams(r);

		// Interpolate to smooth
		RRSmoothOperator rs = new RRSmoothOperator(true);
		rs.addChildStreams(ri);

		RRAllPeaksDetectOperator rap = new RRAllPeaksDetectOperator();
		rap.addChildStreams(rs);

		ClinicalFeaturesOperator rf = new ClinicalFeaturesOperator();
		rf.addChildStreams(rap);
		rap.saveStreamToFile("/Users/aparate/tmp.csv");
		rs.closeStream();
	}

	public static void generateData(){
		String testFile = "/Users/aparate/syndata.txt";
		BufferedWriter bw = IOUtils.getWriter(testFile);
		long time = System.currentTimeMillis();
		long delta = 1000/8;
		int T = 8000;//period in milliseconds
		for(int i=0;i<60000;i++){
			String s = (time+delta*i)+"";
			int j = (int)((delta*i)%T);
			String data = Math.sin(Math.PI*2*j/T)+"";
			IOUtils.writeLine(s+","+data, bw);
		}
		IOUtils.close(bw);
	}


	public static void processEDA(){

		EDAFileStream rawStream = new EDAFileStream(8);
		rawStream.addFileToStream("/Users/aparate/Downloads/docs/demo/aspmeetingeda.raw.csv");

		SVFileStream svStream = new SVFileStream(",");
		svStream.addFileToStream("/Users/aparate/aspmeetingeda.csv",true);
		//svStream.addFileToStream("/Users/aparate/Downloads/docs/demo/demo_BR.csv",true);
		//svStream.addFileToStream("/Users/aparate/syndata.txt",true);

		int waveletLevel = 7;
		int smoothFactor = 60;
		LowPassFilter smooth = new LowPassFilter(8, Filter.BUTTERWORTH, waveletLevel, smoothFactor, new int[]{5}, false, 6); 
		smooth.addChildStreams(rawStream);

		EDASCROnsetOperator scr = new EDASCROnsetOperator(8, 5, 6, 2, 1, 0);
		scr.addChildStreams(smooth);

		String testFile = "/Users/aparate/tmp.csv";
		scr.saveStreamToFile(testFile);
		scr.closeStream();

		//		FFTOperator fft = new FFTOperator(30, 0,8);
		//		fft.addChildStreams(scr);
		//		fft.saveStreamToFile(testFile);
		//		fft.closeStream();
		//
		/*PCAOperator pca = new PCAOperator(30, 0, 8, 50);//window size, column index, sample rate, pca-dimensions
		pca.addChildStreams(scr);
		pca.saveStreamToFile(testFile);
		pca.closeStream();*/

		//convertFFTToHeatMapData(fft, IOUtils.getWriter(testFile));

	}

	@SuppressWarnings("unused")
	public static void processGeneral(){
		String user = "61";
		String rootDir = "/Users/aparate/Downloads/projects/mph/"+user+"/";
		File dir = new File(rootDir);
		File files[] = dir.listFiles();
		Arrays.sort(files, new Comparator<File>(){
			@Override
			public int compare(File arg0, File arg1) {
				return arg0.getName().compareTo(arg1.getName());
			}
		});
		SVFileStream svf = new SVFileStream(",");
		for(int i=0;i<files.length;i++){
			if(files[i].getName().contains("meta.xml"))
				continue;
			else{
				svf.addFileToStream(files[i].getAbsolutePath(), false);
			}
		}

		ActivityStream acts = new ActivityStream(10,12,14,3);
		acts.addChildStreams(svf);

		AggregateOperator wao = new AggregateOperator(AggregateWindow.HOUR, new int[]{0,1,2},AggregateType.AVERAGE);
		wao.addChildStreams(acts);

		String waoFile = "/Users/aparate/Downloads/projects/mph/"+user+"-wao-all.csv";
		String actsFile =  "/Users/aparate/Downloads/projects/mph/"+user+"-acts-all.csv";
		wao.saveStreamToFile(waoFile);
		//acts.saveStreamToFile(actsFile);
	}

	public static void processINVEN(){
		SVFileStream svStream = new SVFileStream(",");
		//svStream.addFileToStream("/Users/aparate/aspmeetingeda.csv",true);
		svStream.addFileToStream("/Users/aparate/Downloads/INVN_PARSED_FILE.csv",true);
		//svStream.addFileToStream("/Users/aparate/syndata.txt",true);

		int waveletLevel = 7;
		int smoothFactor = 60;
		LowPassFilter smooth = new LowPassFilter(46, Filter.BUTTERWORTH,
				waveletLevel, smoothFactor,new int[]{1},false,7);
		smooth.addChildStreams(svStream);

		String testFile = "/Users/aparate/tmp.csv";
		smooth.saveStreamToFile(testFile);
		smooth.closeStream();
	}

	public static void test() {
		String file = "/Users/aparate/Downloads/new6.csv";
		BufferedReader br = IOUtils.getReader(file);
		String s = null;
		long previous = -1L;
		int count = 0;
		while((s=IOUtils.readLine(br))!=null) {
			String toks[] = s.split(",");
			long current = Long.parseLong(toks[0]);
			Calendar c = GregorianCalendar.getInstance();
			c.setTimeInMillis(current);
			int MIN = c.get(Calendar.MINUTE);
			count++;
			if(current<previous || (MIN<37 && MIN>=36)) {
				System.out.println(count+" "+c.get(Calendar.MINUTE)+" "+c.get(Calendar.SECOND)+" "+c.get(Calendar.MILLISECOND)+" "+c.get(Calendar.HOUR_OF_DAY)+" "+current);
			}
			previous = current;
		}
	}

	public static void getDBNTestTrain(){

		int BITE_INDEX = 3;
		int SESS_INDEX = 4;
		int TRAIN_INDEX = BITE_INDEX;
		String inTrain = "/Users/aparate/Downloads/training_dbn_0412_1.csv";
		String outTrain = "/Users/aparate/Downloads/dbn-cmb-train.arff";
		BufferedReader br = IOUtils.getReader(inTrain);
		ArrayList<double[]> list = new ArrayList<double[]>();
		String s = null;
		long st = System.currentTimeMillis();
		int count = 0;
		while((s=IOUtils.readLine(br))!=null) {
			String tokens[] = s.split(",");
			double x[] = new double[3];
			x[0] = Double.parseDouble(tokens[0]);
			x[1] = Double.parseDouble(tokens[1]);
			x[2] = Double.parseDouble(tokens[2]);
			list.add(x);
			count++;
		}
		IOUtils.close(br);
		long et = System.currentTimeMillis();
		System.out.println("Finished Reading "+count+" records in:" + (et-st)/1000+" secs");
		st = et;

		int k = 10; int iter = 10000;
		KMeansCluster cluster = new KMeansCluster(k, iter, list.toArray(new double[0][]));
		list.clear();
		cluster.startAnalysis();

		et = System.currentTimeMillis();
		System.out.println("Finished Clustering in:" + (et-st)/1000+" secs");
		st = et;

		br = IOUtils.getReader(inTrain);
		BufferedWriter bw = IOUtils.getWriter(outTrain);
		IOUtils.writeLine("@relation train", bw);
		IOUtils.writeLine("@attribute state0 {S0,S1,S2,S3,S4,S5,S6,S7,S8,S9}", bw);
		IOUtils.writeLine("@attribute bite0 {true,false}",bw);
		IOUtils.writeLine("@attribute state1 {S0,S1,S2,S3,S4,S5,S6,S7,S8,S9}", bw);
		IOUtils.writeLine("@attribute bite1 {true,false}",bw);
		IOUtils.writeLine("@data", bw);
		String prev = null;
		while((s=IOUtils.readLine(br))!=null) {
			String tokens[] = s.split(",");
			double x[] = new double[3];
			x[0] = Double.parseDouble(tokens[0]);
			x[1] = Double.parseDouble(tokens[1]);
			x[2] = Double.parseDouble(tokens[2]);
			int clusterId = cluster.getClosestCluster(x);
			String bite = tokens[TRAIN_INDEX].toLowerCase();
			String curr = "S"+clusterId+","+bite;
			if(prev!=null)
				IOUtils.writeLine(prev+","+curr, bw);
			prev = curr;
		}
		IOUtils.close(br);
		IOUtils.close(bw);
		et = System.currentTimeMillis();
		System.out.println("Finished Writing in:" + (et-st)/1000+" secs");
		st = et;

		String inTest = "/Users/aparate/Downloads/testing_dbn_0412_1.csv";
		String outTest = "/Users/aparate/Downloads/dbn-cmb-test.arff";
		br = IOUtils.getReader(inTest);
		bw = IOUtils.getWriter(outTest);
		IOUtils.writeLine("@relation test", bw);
		IOUtils.writeLine("@attribute timestamp", bw);
		IOUtils.writeLine("@attribute state {S0,S1,S2,S3,S4,S5,S6,S7,S8,S9}", bw);
		IOUtils.writeLine("@attribute bite {true,false}",bw);
		IOUtils.writeLine("@data", bw);
		count = 0;
		while((s=IOUtils.readLine(br))!=null) {
			count++;
			String tokens[] = s.split(",");
			double x[] = new double[3];
			x[0] = Double.parseDouble(tokens[0]);
			x[1] = Double.parseDouble(tokens[1]);
			x[2] = Double.parseDouble(tokens[2]);
			int clusterId = cluster.getClosestCluster(x);
			String conf = "";
			for(int i=0;i<10;i++){
				conf += (","+(i==clusterId?"1.0":"0.0"));
			}

			String bite = tokens[TRAIN_INDEX].toLowerCase();
			if(bite.trim().equals("true"))
				conf += (",1.0,0.0");
			else conf += (",0.0,1.0");
			String curr = "S"+clusterId+","+bite;
			IOUtils.writeLine((st+count)+conf+","+curr, bw);
		}
		IOUtils.close(br);
		IOUtils.close(bw);
		et = System.currentTimeMillis();
		System.out.println("Finished Writing Test in:" + (et-st)/1000+" secs");
		st = et;
	}

	public static void getDBNTestTrainMultiple(){
		int BITE_INDEX = 3;
		int SESS_INDEX = 4;
		int TRAIN_INDEX = BITE_INDEX;
		String inTrain = "/Users/aparate/Downloads/training_dbn_0412_1.csv";
		String outTrain = "/Users/aparate/Downloads/dbn-cmb-train-mult.arff";
		BufferedReader br = IOUtils.getReader(inTrain);
		ArrayList<double[]> list1 = new ArrayList<double[]>();
		ArrayList<double[]> list2 = new ArrayList<double[]>();
		ArrayList<double[]> list3 = new ArrayList<double[]>();
		String s = null;
		long st = System.currentTimeMillis();
		int count = 0;
		while((s=IOUtils.readLine(br))!=null) {
			String tokens[] = s.split(",");
			double x1[] = new double[1];
			double x2[] = new double[1];
			double x3[] = new double[1];
			x1[0] = Double.parseDouble(tokens[0]);
			x2[0] = Double.parseDouble(tokens[1]);
			x3[0] = Double.parseDouble(tokens[2]);
			list1.add(x1);
			list2.add(x2);
			list3.add(x3);
			count++;
		}
		IOUtils.close(br);
		long et = System.currentTimeMillis();
		System.out.println("Finished Reading "+count+" records in:" + (et-st)/1000+" secs");
		st = et;

		int k = 10; int iter = 2000;
		KMeansCluster cluster1 = new KMeansCluster(k, iter, list1.toArray(new double[0][]));
		list1.clear();
		cluster1.startAnalysis();

		et = System.currentTimeMillis();
		System.out.println("Finished Clustering in:" + (et-st)/1000+" secs");
		st = et;

		KMeansCluster cluster2 = new KMeansCluster(k, iter, list2.toArray(new double[0][]));
		list2.clear();
		cluster2.startAnalysis();

		et = System.currentTimeMillis();
		System.out.println("Finished Clustering in:" + (et-st)/1000+" secs");
		st = et;

		KMeansCluster cluster3 = new KMeansCluster(k, iter, list3.toArray(new double[0][]));
		list3.clear();
		cluster3.startAnalysis();

		et = System.currentTimeMillis();
		System.out.println("Finished Clustering in:" + (et-st)/1000+" secs");
		st = et;

		br = IOUtils.getReader(inTrain);
		BufferedWriter bw = IOUtils.getWriter(outTrain);
		IOUtils.writeLine("@relation train", bw);
		IOUtils.writeLine("@attribute stone0 {S0,S1,S2,S3,S4,S5,S6,S7,S8,S9}", bw);
		IOUtils.writeLine("@attribute sttwo0 {S0,S1,S2,S3,S4,S5,S6,S7,S8,S9}", bw);
		IOUtils.writeLine("@attribute stthree0 {S0,S1,S2,S3,S4,S5,S6,S7,S8,S9}", bw);
		IOUtils.writeLine("@attribute bite0 {true,false}",bw);
		IOUtils.writeLine("@attribute stone1 {S0,S1,S2,S3,S4,S5,S6,S7,S8,S9}", bw);
		IOUtils.writeLine("@attribute sttwo1 {S0,S1,S2,S3,S4,S5,S6,S7,S8,S9}", bw);
		IOUtils.writeLine("@attribute stthree1 {S0,S1,S2,S3,S4,S5,S6,S7,S8,S9}", bw);
		IOUtils.writeLine("@attribute bite1 {true,false}",bw);
		IOUtils.writeLine("@data", bw);
		String prev = null;
		while((s=IOUtils.readLine(br))!=null) {
			String tokens[] = s.split(",");
			double x[] = new double[1];
			x[0] = Double.parseDouble(tokens[0]);
			int clusterId = cluster1.getClosestCluster(x);
			String curr = "S"+clusterId;
			x[0] = Double.parseDouble(tokens[1]);
			clusterId = cluster2.getClosestCluster(x);
			curr += (",S"+clusterId);
			x[0] = Double.parseDouble(tokens[2]);
			clusterId = cluster3.getClosestCluster(x);
			curr += (",S"+clusterId);
			String bite = tokens[TRAIN_INDEX].toLowerCase();
			curr = curr +","+bite;
			if(prev!=null)
				IOUtils.writeLine(prev+","+curr, bw);
			prev = curr;
		}
		IOUtils.close(br);
		IOUtils.close(bw);
		et = System.currentTimeMillis();
		System.out.println("Finished Writing in:" + (et-st)/1000+" secs");
		st = et;

		String inTest = "/Users/aparate/Downloads/testing_dbn_0412_1.csv";
		String outTest = "/Users/aparate/Downloads/dbn-cmb-test-mult.arff";
		br = IOUtils.getReader(inTest);
		bw = IOUtils.getWriter(outTest);
		IOUtils.writeLine("@relation test", bw);
		IOUtils.writeLine("@attribute timestamp", bw);
		IOUtils.writeLine("@attribute stone {S0,S1,S2,S3,S4,S5,S6,S7,S8,S9}", bw);
		IOUtils.writeLine("@attribute sttwo {S0,S1,S2,S3,S4,S5,S6,S7,S8,S9}", bw);
		IOUtils.writeLine("@attribute stthree {S0,S1,S2,S3,S4,S5,S6,S7,S8,S9}", bw);
		IOUtils.writeLine("@attribute bite {true,false}",bw);
		IOUtils.writeLine("@data", bw);
		count = 0;
		while((s=IOUtils.readLine(br))!=null) {
			count++;
			String tokens[] = s.split(",");
			double x[] = new double[1];
			x[0] = Double.parseDouble(tokens[0]);
			int clusterId = cluster1.getClosestCluster(x);
			String conf = "";
			for(int i=0;i<10;i++){
				conf += (","+(i==clusterId?"1.0":"0.0"));
			}
			String curr = "S"+clusterId;

			x[0] = Double.parseDouble(tokens[1]);
			clusterId = cluster2.getClosestCluster(x);
			for(int i=0;i<10;i++){
				conf += (","+(i==clusterId?"1.0":"0.0"));
			}
			curr += (",S"+clusterId);

			x[0] = Double.parseDouble(tokens[2]);
			clusterId = cluster3.getClosestCluster(x);
			for(int i=0;i<10;i++){
				conf += (","+(i==clusterId?"1.0":"0.0"));
			}
			curr += (",S"+clusterId);

			String bite = tokens[TRAIN_INDEX].toLowerCase();
			if(bite.trim().equals("true"))
				conf += (",1.0,0.0");
			else conf += (",0.0,1.0");
			curr = curr+","+bite;
			IOUtils.writeLine((st+count)+conf+","+curr, bw);
		}
		IOUtils.close(br);
		IOUtils.close(bw);
		et = System.currentTimeMillis();
		System.out.println("Finished Writing Test in:" + (et-st)/1000+" secs");
		st = et;
	}

	public static void testGMMCluster(){

		int BITE_INDEX = 3;
		String inTrain = "/Users/aparate/Downloads/training_dbn_0412_1.csv";
		BufferedReader br = IOUtils.getReader(inTrain);
		ArrayList<double[]> list = new ArrayList<double[]>();
		String s = null;
		long st = System.currentTimeMillis();
		int count = 0;
		while((s=IOUtils.readLine(br))!=null) {
			String tokens[] = s.split(",");
			double x[] = new double[2];
			x[0] = Double.parseDouble(tokens[1]);
			x[1] = Double.parseDouble(tokens[2]);
			//x[2] = Double.parseDouble(tokens[2]);
			list.add(x);
			count++;
		}
		IOUtils.close(br);
		long et = System.currentTimeMillis();
		System.out.println("Finished Reading "+count+" records in:" + (et-st)/1000+" secs");
		st = et;

		int k = 10; int iter = 2000;
		GaussianCluster cluster = new GaussianCluster(k, list.toArray(new double[0][]), iter);
		list.clear();
		cluster.learnComponents();

		et = System.currentTimeMillis();
		System.out.println("Finished Clustering in:" + (et-st)/1000+" secs");
		st = et;

		cluster.printGMMComponents();
	}

	public static void extractPedometerData() throws Exception {
		String inFile = "/Users/aparate/Documents/RA/data/activity/data/pedometer-2.log";
		BufferedReader br = IOUtils.getReader(inFile);
		String outFile = "/Users/aparate/pedometer.csv";
		BufferedWriter bw = IOUtils.getWriter(outFile);
		String s = null;
		StringBuffer buff = new StringBuffer();
		long startTime = -1L;
		String prevLabel = null;
		long lastTime = -1L;
		while((s=IOUtils.readLine(br))!=null) {
			if(s.contains("WALK")) {
				String tokens[] = s.split(",");
				long time = Long.parseLong(tokens[0]);
				if(lastTime==-1) lastTime = time;
				if(startTime==-1 || (time-startTime>=5*1000)) {
					//Print every 5 seconds
					String temp = buff.toString();
					if(temp!=null) {
						String ttoks[] = temp.split("\n");
						if(ttoks.length>=5*20) { //If at least 20Hz data
							bw.write(temp);
						}
					}
					startTime = time;
					buff  = new StringBuffer();
					lastTime = time;
				}
				String label = tokens[tokens.length-1];
				if(time==startTime || !label.equals(prevLabel)) {
					//print label with the data
					String toPrint = tokens[0];
					for(int i=1;i<tokens.length-1;i++) {
						toPrint += (","+tokens[i]);
					}
					toPrint += (","+label);
					buff.append(toPrint+"\n");
				} else {
					//Do not print label, write null instead
					String toPrint = tokens[0];
					for(int i=1;i<tokens.length-1;i++) {
						toPrint += (","+tokens[i]);
					}
					toPrint += (",null");
					buff.append(toPrint+"\n");
				}
				prevLabel = label;
			}
		}
		IOUtils.close(br);
		IOUtils.close(bw);
	}

	public static void extractActivityData() throws Exception {
		String inFile = "/Users/aparate/All-filtered-2.log";
		BufferedReader br = IOUtils.getReader(inFile);
		String outFile = "/Users/aparate/activity-donotdelete-allactivities.csv";
		BufferedWriter bw = IOUtils.getWriter(outFile);
		String s = null;
		StringBuffer buff = new StringBuffer();
		long startTime = -1L;
		String prevLabel = "";
		int failed = 0;
		while((s=IOUtils.readLine(br))!=null) {
			String tokens[] = s.split(",");
			long time = Long.parseLong(tokens[0]);
			if(startTime==-1 || (time-startTime>=5*1000)) {
				//Print every 5 seconds
				String temp = buff.toString();
				if(temp!=null) {
					String ttoks[] = temp.split("\n");
					if(ttoks.length>=5*20) { //If at least 20Hz data
						bw.write(temp);
						//if(prevLabel.contains("DRI"))
							//System.out.println(prevLabel);
					} else {
						failed++;
					}
				} else {
					System.out.println("NULL");
				}
				startTime = time;
				buff  = new StringBuffer();
			}
			String label = tokens[tokens.length-1];
			//print label with the data
			String toPrint = tokens[0];
			//Add only accelerometer values
			for(int i=5;i<8;i++) {
				toPrint += (","+tokens[i]);
			}
			toPrint += (","+label);
			buff.append(toPrint+"\n");
			//System.out.println(label);
			prevLabel = label;
		}
		System.out.println("FAILED "+failed);
		IOUtils.close(br);
		IOUtils.close(bw);
	}

	public static void extractSteps(){
		SVFileStream svf = new SVFileStream(",");
		String file = "/Users/aparate/pedometer.csv";
		svf.addFileToStream(file, false);

		StepsExtractor se = new StepsExtractor(0, 1, 2);
		se.addChildStreams(svf);

		String outFile = "/Users/aparate/steps.csv";
		se.saveStreamToFile(outFile);
	}


	public static void main(String args[]) throws Exception{

		//processECG();

		//processEDA();

		//generateData();

		//processGeneral();

		//processINVEN();
		//test();
		//getDBNTestTrainMultiple();
		//testGMMCluster();
		//extractPedometerData();
		//extractSteps();
		extractActivityData();
	}

}

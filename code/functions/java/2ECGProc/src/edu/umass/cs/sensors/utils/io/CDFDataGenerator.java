package edu.umass.cs.sensors.utils.io;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;

public class CDFDataGenerator {

	ArrayList<Double> data = new ArrayList<Double>();
	public void generateCDFData(String inFile) throws IOException{
		BufferedReader br = new BufferedReader(new FileReader(inFile));
		long counter = 0;
		String s = null;
		data.clear();
		while((s=br.readLine())!=null){
			String tokens[] = s.split(",");
			if(tokens.length>1){
				data.add(Double.parseDouble(tokens[1]));
				counter++;
			}
		}
		br.close();
		System.out.println("#Sorting "+counter);
		Collections.sort(data);
		Iterator<Double> stepper = data.iterator();
		double probability = 0;

		while(stepper.hasNext()) {
			probability += 1.0 / data.size();
			System.out.println(stepper.next() + " " + probability);
		}

	}
	
	public void generateCDFData(String inFile,String outFile) throws IOException{
		BufferedReader br = new BufferedReader(new FileReader(inFile));
		BufferedWriter bw = new BufferedWriter(new FileWriter(outFile));
		long counter = 0;
		String s = null;
		data.clear();
		while((s=br.readLine())!=null){
			String tokens[] = s.split(",");
			if(tokens.length>1){
				data.add(Double.parseDouble(tokens[1]));
				counter++;
			}
		}
		br.close();
		bw.write("#Sorting "+counter+"\n");
		Collections.sort(data);
		Iterator<Double> stepper = data.iterator();
		double probability = 0;

		while(stepper.hasNext()) {
			probability += 1.0 / data.size();
			bw.write(stepper.next() + " " + probability+"\n");
		}
		bw.close();

	}
	public void generateCDFDataCompressed(String inFile,String outFile) throws IOException{
		int nPoints = 100;
		double delta = 1.0/nPoints;
		double nextProb = 0.0;
		BufferedReader br = new BufferedReader(new FileReader(inFile));
		BufferedWriter bw = new BufferedWriter(new FileWriter(outFile));
		long counter = 0;
		String s = null;
		data.clear();
		while((s=br.readLine())!=null){
			String tokens[] = s.split(",");
			if(tokens.length>1){
				data.add(Double.parseDouble(tokens[1]));
				counter++;
			}
		}
		br.close();
		bw.write("#Sorting "+counter+"\n");
		Collections.sort(data);
		Iterator<Double> stepper = data.iterator();
		double probability = 0;

		double value=0.0;
		while(stepper.hasNext()) {
			probability += 1.0 / data.size();
			value = stepper.next();
			if(probability>=nextProb){
				bw.write(value + " " + probability+"\n");
				nextProb +=delta;
			} 
		}
		bw.write(value + " " + probability+"\n");
		bw.close();

	}
	public void generatePDFData(String inFile) throws IOException{
		BufferedReader br = new BufferedReader(new FileReader(inFile));
		long counter = 0;
		String s = null;
		while((s=br.readLine())!=null){
			data.add(Double.parseDouble(s.split(",")[1]));
			counter++;
		}
		br.close();
		System.out.println("#Sorting "+counter);
		Collections.sort(data);
		Iterator<Double> stepper = data.iterator();
		double probability = 0;
		double start = data.get(0);
		double end = data.get(data.size()-1);
		double step = 1.0;//(end-start)/200;
		end = start+step;
		double current = start;
		while(stepper.hasNext()) {
			current = stepper.next();
			if(current>=(end-step) && current<end){
				probability += 1.0 / data.size();
			} else {
				System.out.println(end + " " + probability);
				while(true){
					end = end + step;
					if(current>=(end-step) && current<end){
						probability=1.0/data.size();
						break;
					} else {
						probability=0.0;
						System.out.println(end + " " + probability);
					}
				}
			}
			
		}
		System.out.println(end + " " + probability);
	}

	public static void main(String args[]) throws IOException {
		CDFDataGenerator cg = new CDFDataGenerator();
		String inFile = "/Users/aparate/Documents/RA/projects/falcon/falcon/files/";
		String outFile = "/Users/aparate/Documents/RA/projects/falcon/falcon/";
		inFile = "/Users/aparate/Documents/RA/projects/falcon/falcon/files/fresh/facebook/frs-best-fb/";
		
		inFile = "/Users/aparate/Documents/RA/projects/falcon/falcon/files/fresh/facebook/frs-per-ppm-fb-3.36x/";
		outFile = "/Users/aparate/Documents/RA/projects/falcon/falcon/files/fresh/facebook/frs-per-ppm-fb-3.36x/";
		cg.generateCDFDataCompressed(inFile+"fresh-all.csv", outFile+"fresh-all-cdf.csv");
		
		
		
		
		
		
	}
}

package edu.umass.cs.sensors.utils.io;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;


public class IOUtils {

	public static BufferedWriter getWriter(String file){
		BufferedWriter bw = null;
		try {
			bw = new BufferedWriter(new FileWriter(file));
		} catch (IOException e) {
			Logger.error("Exception in getting writer for "+file);
			//e.printStackTrace();
			return null;
		}
		return bw;
	}

	public static BufferedReader getReader(String file){
		BufferedReader br = null;
		try {
			br = new BufferedReader(new FileReader(file));
		} catch (IOException e) {
			Logger.error("Exception in getting reader for "+file);
			//e.printStackTrace();
			return null;
		}
		return br;
	}

	public static String readLine(BufferedReader br) {
		String s = null;
		try{
			s = br.readLine();
		}catch(IOException e) {
			Logger.error("Can't read line" +e.getLocalizedMessage());
		}
		return s;
	}
	
	public static void writeLine(String s, BufferedWriter bw) {
		try{
			bw.write(s+"\n");
		}catch(IOException e){
			Logger.error("Can't write to file"+e.getLocalizedMessage());
		}
	}

	public static void close(BufferedWriter bw) {
		try{
			if(bw!=null)
				bw.close();
		}catch(IOException e){
			Logger.error("Exception in closing writer");
			//e.printStackTrace();
		}
	}

	public static void close(BufferedReader br) {
		try{
			if(br!=null)
				br.close();
		}catch(IOException e){
			Logger.error("Exception in closing reader");
			//e.printStackTrace();
		}
	}
}

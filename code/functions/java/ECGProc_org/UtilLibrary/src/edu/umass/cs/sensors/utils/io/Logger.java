package edu.umass.cs.sensors.utils.io;

import java.sql.Timestamp;
import java.util.GregorianCalendar;

/**
 * Logger is the utility class to log various events with appropriate tags
 * @author aparate
 *
 */
public class Logger {

	private static final String error = " [ERROR]:";
	private static final String log = " [LOG]:";
	private static final String debug = " [DEBUG]:";
	
	public static void log(String s){
		Timestamp ts = new Timestamp(GregorianCalendar.getInstance().getTimeInMillis());
		System.out.println(ts+log+s);
	}
	
	public static void debug(String s){
		Timestamp ts = new Timestamp(GregorianCalendar.getInstance().getTimeInMillis());
		System.out.println(ts+debug+s);
	}
	
	public static void error(String s){
		Timestamp ts = new Timestamp(GregorianCalendar.getInstance().getTimeInMillis());
		System.out.println(ts+error+s);
	}
	
	public static void newLine(){
		System.out.println("------------------------------------------------------------------");
	}
}

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author monowar
 */
//package edu.memphis.cs.WiSeMANet.SIPDBExtractor;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Date;

public class ExtractDatabase {

	/**
	 * @param args
	 */
	private Connection connection = null;

	String outputFile, inputFile;
	private long startTime, endTime;
	private String tableName;
	int columnCount=0;
	FileOutputStream f =null;
	PrintStream p = null;


	public ExtractDatabase() {
	}
	public String getOperator(String[] args, String parameter) {
		for(int i=0;i<args.length;i++)
			if(args[i].equals(parameter)==true)
				return args[i+1];
		return null;
	}
	public void extractcolumnname()
	{
		int flag=0;
		columnCount=0;
		try{
			ResultSet rsColumns = null;
			DatabaseMetaData meta = connection.getMetaData();

			rsColumns = meta.getColumns(null, null, tableName, null);
			while (rsColumns.next()) {
				if(flag!=0) 	  p.print(",");
				flag=1;

				String columnName = rsColumns.getString("COLUMN_NAME");
				p.print(columnName);
				columnCount++;
			}
			if(flag!=0)
				p.println();
		}catch(Exception e){

		}
	}
	public void input(String [] args)
	{
		inputFile=getOperator(args,"-i");
		outputFile=getOperator(args,"-o");
		String start=getOperator(args,"-s");
		String end=getOperator(args,"-e");
		if(start==null) startTime=0; else startTime=Long.parseLong(start);
		if(end==null) endTime=2099999999999L;else endTime=Long.parseLong(end);
		tableName=getOperator(args,"-t");

//		inputFile="StressInferencePhone.db";
//		tableName="sensor21";
//		outputFile="sensor21.txt";


		try {
			f = new FileOutputStream(outputFile);
			p = new PrintStream(f);

		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
	}
	public void connect()
	{
		//System.out.println("Connect: "+inputFile);
		try {
			Class.forName("org.sqlite.JDBC");
			connection = DriverManager.getConnection("jdbc:sqlite:" + inputFile);

			//System.out.println("Done processing " + inFile);
		} catch (Exception e) {
			e.printStackTrace();
		}		
	}
	public void disconnect()
	{
		try {
			connection.close();
			if(p!=null)
				p.close();
			if(f!=null) 
				f.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public void extractSensorData() {
		//System.out.print("Starting..." + tableName);
		Statement statement=null;
		try {
			statement = connection.createStatement();
		} catch (SQLException ex) {
		}
		p.println("sample,time");
			try{
				ResultSet resultSet = statement.executeQuery("SELECT * FROM " + tableName+" where start_timestamp>="+startTime+" and start_timestamp<="+endTime);
				while (resultSet.next()) {
					// raw data
					byte[] data = resultSet.getBytes("samples");
					byte[] timestamp = resultSet.getBytes("timestamps");

					int d;
					long t;
					//                                System.out.println(data.length);
					//                                System.out.println(timestamp.length)
					for (int i=0; i < timestamp.length/8; i++) {
						t=0;
						d=0;
						for (int j=0; j<8; j++) {
							t <<= 8;
							t |= timestamp[8*i + j] & 0xFF;
						}

						for (int j=0; j<4; j++) {
							d <<= 8;
							d |= data[4*i + j] & 0xFF;
						}

						Date date = new Date();
						date.setTime(t);

						p.println(d + "," + t);
					}
				}

			} catch(SQLException e) {
				//System.out.println("Table " + tableName + " not found!");
			}
	}

	public void extractdata() {
		Statement statement;
		String str;
		try {
			statement = connection.createStatement();
			ResultSet resultSet = statement.executeQuery("SELECT * FROM " + tableName);
			while (resultSet.next()) {
				// raw data
				for(int i=1;i<=columnCount;i++){
					if(i!=1) p.print(",");

					str=resultSet.getString(i);
					str=str.replace(',', ';');
					str=str.replace("\n"," ");
					p.print(str);

				}
				p.println();
			}
			p.close();
			try {
				f.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		} catch (SQLException e) {
			//System.out.println("Table " + tableName + " not found!");
		}

//		System.out.println("Done");
	}
	public static void extractdb(String []args)
	{
		ExtractDatabase extractor = new ExtractDatabase();
		if(args!=null){
			extractor.input(args);
		extractor.connect();
		if(extractor.tableName.startsWith("sensor"))
			extractor.extractSensorData();
		else{
			extractor.extractcolumnname();
			extractor.extractdata();
		}
		extractor.disconnect();
		
		}
	}
	public static void main(String[] args) {
		System.out.println("using main");
		extractdb(args);
	}
}


package edu.umass.cs.sensors.utils.io;

import java.io.BufferedWriter;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;


public class SQLiteExecutor {

	/**
	 * Creates Sqlite jdbc connection
	 * @param dbLocation complete path to sqlite db file
	 */
	public Connection getConnection(String dbLocation) {
		try {
			Class.forName("org.sqlite.JDBC");
		} catch (ClassNotFoundException e) {
			Logger.error("Sqlite3 jdbc driver not found");
			Logger.error(e.getLocalizedMessage());
			return null;
		}
		Connection connection = null;
		try {
			connection = DriverManager.getConnection("jdbc:sqlite:"+dbLocation);
		} catch (SQLException e) {
			Logger.error("Sqlite connection not established");
			Logger.error(e.getLocalizedMessage());
			return null;
		}
		return connection;
	}
	
	/**
	 * Just close the jdbc connection
	 * @param conn
	 */
	public void closeConnection(Connection conn) {
		try {
			if(!conn.isClosed())
				conn.close();
		} catch (SQLException e) {
			Logger.error("JDBC Connection close problem");
			Logger.error(e.getLocalizedMessage());
		}
	}

	/**
	 * Execute input query and write it to a file in csv
	 * @param query sql query
	 * @param file complete path to the output file
	 * @param dbLocation complete path to the DB
	 */
	public boolean executeQueryToFile(String query, String file, String dbLocation)
	{
		Connection connection = getConnection(dbLocation);
		if(connection==null) return false;
		
		boolean success = executeQueryToFile(query,file,connection);
		closeConnection(connection);
		return success;
	}

	/**
	 * Execute input query and write it to a file in csv using db connection
	 * @param query sql query
	 * @param file complete path to the output file
	 * @param dbConnection
	 */
	public boolean executeQueryToFile(String query, String file, Connection dbConnection){
		try{
			Statement statement = dbConnection.createStatement();
			statement.setQueryTimeout(30);  // set timeout to 30 sec.

			ResultSet rs = statement.executeQuery(query);
			ResultSetMetaData metaData = rs.getMetaData();
			int numCols = metaData.getColumnCount();
			
			BufferedWriter out = IOUtils.getWriter(file);
			if(out==null) return false;
			
			while(rs.next())
			{
				String s = rs.getString(1);
				for(int i=2;i<=numCols;i++)
					s += (","+rs.getString(i));
				out.write(s+"\n");
			}
			out.close();
			return true;
		}catch(SQLException e){
			Logger.error("SQLite could not execute query");
			Logger.error(e.getLocalizedMessage());
			return false;
		}catch(IOException e){
			Logger.error("File path contains error:"+file);
			Logger.error(e.getLocalizedMessage());
			return false;
		}
	}

}

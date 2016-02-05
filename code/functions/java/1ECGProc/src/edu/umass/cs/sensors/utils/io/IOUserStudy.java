package edu.umass.cs.sensors.utils.io;

public class IOUserStudy {
	
	/** Queries corresponding to tables supported in User study*/
	static final String APPUSAGE_QUERY ="SELECT * FROM APPUSAGEEVENTS ORDER BY starttime";
	static final String PREFETCH_QUERY ="SELECT * FROM FalconPrefetchUsageEvents ORDER BY prefetchtime";
	static final String PRELAUNCH_QUERY ="SELECT * FROM FalconPrelaunchUsageEvents ORDER BY prelaunchtime";
	static final String FETCHTIME_QUERY ="SELECT * FROM FalconFetchTimeData ORDER BY fetchtime";
	
	public static enum TABLES {APPUSAGE,PREFETCH,PRELAUNCH,FETCHTIME};
	
	/**
	 * Write query output from given sqlite db at dbpath to file
	 * @param dbPath
	 * @param file
	 */
	public void writeQueryToFile(String query, String dbPath, String file){
		SQLiteExecutor executor = new SQLiteExecutor();
		executor.executeQueryToFile(query, file, dbPath);
	}
	
	/**
	 * Write sqlite table to file: A wrapper function
	 * @param table
	 * @param dbPath
	 * @param file
	 */
	public void writeTableToFile(TABLES table, String dbPath, String file)
	{
		switch(table) 
		{
		case APPUSAGE:
			writeQueryToFile(APPUSAGE_QUERY,dbPath,file);
			break;
		case PREFETCH:
			writeQueryToFile(PREFETCH_QUERY,dbPath,file);
			break;
		case PRELAUNCH:
			writeQueryToFile(PRELAUNCH_QUERY,dbPath,file);
			break;
		case FETCHTIME:
			writeQueryToFile(FETCHTIME_QUERY,dbPath,file);
			break;
		}
	}
	
	/**
	 * Write table from multiple sqlite dbs to multiple files
	 * @param table
	 * @param dbPath
	 * @param file
	 */
	public void writeTableToFile(TABLES table, String dbPath[],String file[])
	{
		for(int i=0;i<dbPath.length;i++){
			writeTableToFile(table,dbPath[i],file[i]);
		}
	}
	
	
}

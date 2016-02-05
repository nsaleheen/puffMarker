package falcon.utils;

/**
 * Gives fields in sqlite tables for user study
 * @author aparate
 *
 */
public interface USDataFields {
	
	/**Fields for AppUsageEvents Table*/
	static final int AU_ID_IDX = 0;
	static final int AU_APPNAME_IDX = 1;
	static final int AU_EVENTTYPE_IDX = 2;
	static final int AU_RUNTIME_IDX = 3;
	static final int AU_STARTTIME_IDX = 4;
	static final int AU_BLUETOOTH_IDX = 5;
	static final int AU_WIFI_IDX = 6;
	static final int AU_POWER_IDX = 7;
	static final int AU_ACCURACY_IDX = 8;
	static final int AU_LAT_IDX = 9;
	static final int AU_LNG_IDX = 10;
	static final int AU_HEADPHONE_IDX = 11;
	static final int AU_SYNC_IDX = 12;
	static final int AU_SCREENON_IDX = 13;
	static final int AU_SPEED_IDX = 14;
	static final int AU_ALT_IDX = 15;
	static final int AU_ORT_IDX = 16;
	static final int AU_BATTERY_IDX = 17;
	
	/**Fields for FalconFetchtimedata */
	static final int FT_ID_IDX = 0;
	static final int FT_APPNAME_IDX = 1;
	static final int FT_FETCHTIME_IDX = 2;
	static final int FT_FETCHDURATION_IDX = 3;
	
	/**Fields for FalconPrefetchUsage */
	static final int PF_ID_IDX = 0;
	static final int PF_APPNAME_IDX = 1;
	static final int PF_TIME_IDX = 2;
	
	/**Fields for FalconPrelauncchUsage */
	static final int PL_ID_IDX = 0;
	static final int PL_APPNAME_IDX = 1;
	static final int PL_TIME_IDX = 2;
	static final int PL_RUNNING_IDX = 3;
	
	/** Fields for Events */
	public static final short EVENT_UNDEFINED = 0;
	public static final short EVENT_INUSE = 1;
	public static final short EVENT_INSTALLED = 2;
	public static final short EVENT_UNINSTALLED = 3;
	public static final short EVENT_UPDATE = 4;
	
	public static final short EVENT_SNAPSHOT = 10;
	public static final short EVENT_SNAPSHOT_LAUNCHABLE = 11;

	public static final int EVENT_BOOT = 30;
	public static final int EVENT_POWEROFF = 31;
	
	public static final int EVENT_SCREENON = 40;
	public static final int EVENT_SCREENOFF = 41;

	public static final short EVENT_WIDGETCREATED = 50;
	public static final short EVENT_WIDGETREMOVED = 51;

	/* this one goes from 100 to 105 */
	public static final int EVENT_KICKERCLICKBASE = 100; // klick on 1st icon
	public static final int EVENT_KICKERCLICKBAS1 = 101; // klick on 2nd icon
	public static final int EVENT_KICKERCLICKBAS2 = 102; // klick on 3rd icon
	public static final int EVENT_KICKERCLICKBAS3 = 103; // klick on 4th icon
	public static final int EVENT_KICKERCLICKBAS4 = 104; // klick on 5th icon
	
	public static final short STATUS_LOCAL_ONLY = 1;
	public static final short STATUS_SYNCING = 2;
	public static final short STATUS_SERVER_PERSISTED = 3;
	
}

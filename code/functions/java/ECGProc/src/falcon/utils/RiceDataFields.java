package falcon.utils;

public interface RiceDataFields {

	/** These fields come from dcc_msft_appusage*/
	static final int USER_IDX = 0;
	static final int TIME_IDX = 1;
	static final int DB_ROW_IDX = 1;
	static final int APP_IDX = 3;
	static final int DURATION_IDX=4;
	static final int SES_ID_IDX=5;
	/** These fields come from location file*/
	static final int LOC_USR_IDX=6;
	static final int LOC_TIME_IDX=7;
	static final int LAT_IDX=8;
	static final int LNG_IDX=9;
	static final int GPS_ACC_IDX=10;
	static final int ALT_IDX=11;
	static final int ALT_ACC_IDX=12;
	static final int SPEED_IDX=13;
	/** These are generated fields*/
	static final int LOC_CLUS_IDX=14;
	//GMT hour
	static final int TIME_CLUS_IDX=15;
	static final int ENC_IDX=16; 
}

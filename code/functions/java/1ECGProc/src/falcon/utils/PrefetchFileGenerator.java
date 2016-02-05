package falcon.utils;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.Calendar;
import java.util.Collections;
import java.util.GregorianCalendar;
import java.util.LinkedList;
import java.util.TimeZone;

public class PrefetchFileGenerator {

	/* Indexes in main user-nosess file */
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

	/** Fields to specify distribution type*/
	static final int NEXT_PERFECT=0;
	static final int NEXT_IMPERFECT=1;
	static final int SECOND_NEXT_PERFECT=2;
	static final int SECOND_NEXT_IMPERFECT=3;
	static final int MEDIAN_PERFECT=4;

	/**
	 * This method is used to generate files with CDF for time to next app
	 * when next app is 'app'.
	 * @param nBins	divides time of day into number of bins
	 * @param inDir
	 * @param outDir
	 * @param user
	 * @param app
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public void getNextAppTimeDistribution(int nBins, String inDir, String outDir,String user,String app) throws Exception{
		System.out.println("Next App Dist for "+app);
		String sess = inDir+"/my-app-gps-time-"+user+"-nosess.csv";
		BufferedReader sr = new BufferedReader(new FileReader(sess));
		int binSize = 24/nBins;

		String line = null;
		long lastTime = -1L;
		LinkedList<Long> lists[] = new LinkedList[nBins];
		for(int i=0;i<nBins;i++)
			lists[i] = new LinkedList<Long>();

		while((line=sr.readLine())!=null) {
			String tokens[] = line.split(",");
			//Skip session line
			if(tokens.length<=2)
				continue;

			long currentTime = Long.parseLong(line.split(",")[TIME_IDX]);
			if(lastTime==-1L)
				lastTime=currentTime;
			//Record time if app name is not there
			if(!tokens[APP_IDX].toLowerCase().contains(app.toLowerCase())){
				lastTime = currentTime;
				continue;
			}
			//We know that 'app' is present in this line
			GregorianCalendar gc = new GregorianCalendar(TimeZone.getTimeZone("GMT-7"));
			gc.setTimeInMillis(lastTime*1000);
			int hour = gc.get(Calendar.HOUR_OF_DAY);
			int timeOfDayBin=hour/binSize;
			//Add time since last app to appropriate bin
			lists[timeOfDayBin].add(new Long(currentTime-lastTime));
			lastTime = currentTime;
		}
		sr.close();

		long perc[][] = new long[nBins][10];

		for(int i=0;i<nBins;i++) {
			LinkedList<Long> list = lists[i];
			Collections.sort(list);
			for(int j=0;j<10;j++) {
				int index = (int)(j*0.1*list.size());
				if(list.size()!=0) {
					Long percentile = list.get(index);
					perc[i][j] = percentile;
				} else {
					perc[i][j] = 100000;
				}
			}
		}
		sr = new BufferedReader(new FileReader(sess));
		String outFile = outDir+"/my-app-gps-time-"+user+"-next-dist.csv";
		BufferedWriter bw = new BufferedWriter(new FileWriter(outFile));

		lastTime = -1L;
		int incounter=0,outcounter=0;
		while((line=sr.readLine())!=null) {
			incounter++;
			String tokens[] = line.split(",");
			//Print if session line
			if(tokens.length<=2){
				bw.write(line+"\n");
				outcounter++;
				continue;
			}
			long currentTime = Long.parseLong(line.split(",")[TIME_IDX]);
			if(lastTime==-1L)
				lastTime = currentTime;
			GregorianCalendar gc = new GregorianCalendar(TimeZone.getTimeZone("GMT-7"));
			gc.setTimeInMillis(lastTime*1000);
			int hour = gc.get(Calendar.HOUR_OF_DAY);
			int timeOfDayBin=hour/binSize;
			long percentiles[] = perc[timeOfDayBin]; 
			String s = "";
			for(int i=0;i<percentiles.length;i++)
				s+= (","+percentiles[i]);
			bw.write(line+s+"\n");
			outcounter++;
			lastTime = currentTime; 
		}
		bw.close();
		System.out.println("Written "+outcounter+" of "+incounter+" lines");
		System.out.println(" to file- "+outFile);
	}

	/**
	 * This method is used to generate files with perfect CDF for time to next app 
	 * and time to second next app
	 * when next app is 'app'.
	 * @param nBins	divides time of day into number of bins
	 * @param inDir
	 * @param outDir
	 * @param user
	 * @param app
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public void getSecondNextAppTimeDistribution(int nBins, String inDir, String outDir,String user,String app) throws Exception{
		System.out.println("Second Next App Dist for "+app);
		String sess = inDir+"/my-app-gps-time-"+user+"-nosess.csv";
		BufferedReader sr = new BufferedReader(new FileReader(sess));
		int binSize = 24/nBins;

		String line = null;
		long lastTime = -1L;
		long secondLastTime = -1L;
		LinkedList<Long> lists[] = new LinkedList[nBins];
		LinkedList<Long> secLists[] = new LinkedList[nBins];
		for(int i=0;i<nBins;i++) {
			lists[i] = new LinkedList<Long>();
			secLists[i] = new LinkedList<Long>();
		}

		while((line=sr.readLine())!=null) {
			String tokens[] = line.split(",");
			//Skip session line
			if(tokens.length<=2)
				continue;

			long currentTime = Long.parseLong(line.split(",")[TIME_IDX]);
			GregorianCalendar gc = new GregorianCalendar(TimeZone.getTimeZone("GMT-7"));
			gc.setTimeInMillis(currentTime*1000);

			if(lastTime==-1L){
				lastTime=currentTime;
				secondLastTime = currentTime;
			}
			//Record time if app name is not there
			if(!tokens[APP_IDX].toLowerCase().contains(app.toLowerCase())){
				lastTime = currentTime;
				continue;
			}
			//We know that 'app' is present in this line
			gc.setTimeInMillis(lastTime*1000);
			int hour = gc.get(Calendar.HOUR_OF_DAY);
			int timeOfDayBin=hour/binSize;
			//Add time since last app to appropriate bin
			lists[timeOfDayBin].add(new Long(currentTime-lastTime));
			//Repeat for secondary list
			gc.setTimeInMillis(secondLastTime*1000);
			hour = gc.get(Calendar.HOUR_OF_DAY);
			timeOfDayBin=hour/binSize;
			//Add time since last app to appropriate bin
			secLists[timeOfDayBin].add(new Long(currentTime-secondLastTime));
			secondLastTime = lastTime;
			lastTime = currentTime;
		}
		sr.close();
		//Get Percentiles from training data
		long perc[][] = new long[nBins][10];
		long secPerc[][] = new long[nBins][10];
		for(int i=0;i<nBins;i++) {
			LinkedList<Long> list = lists[i];
			Collections.sort(list);
			for(int j=0;j<10;j++) {
				int index = (int)(j*0.1*list.size());
				if(list.size()!=0) {
					Long percentile = list.get(index);
					perc[i][j] = percentile;
				} else {
					perc[i][j] = 100000;
				}
			}
			list = secLists[i];
			Collections.sort(list);
			for(int j=0;j<10;j++) {
				int index = (int)(j*0.1*list.size());
				if(list.size()!=0) {
					Long percentile = list.get(index);
					secPerc[i][j] = percentile;
				} else {
					secPerc[i][j] = 100000;
				}
			}
		}
		//TODO:Comment or uncomment following block by setting boolean to true/false
		/** Following code gives percentile distribution needed for initialization in app*/
		boolean printDistributionForApp=false;
		if(printDistributionForApp)
		{
			perc = new long[nBins][20];
			secPerc = new long[nBins][20];
			for(int i=0;i<nBins;i++) {
				LinkedList<Long> list = lists[i];
				Collections.sort(list);
				for(int j=0;j<20;j++) {
					int index = (int)(j*0.05*list.size());
					if(list.size()!=0) {
						Long percentile = list.get(index);
						perc[i][j] = percentile;
					} else {
						perc[i][j] = 100000;
					}
				}
				list = secLists[i];
				Collections.sort(list);
				for(int j=0;j<20;j++) {
					int index = (int)(j*0.05*list.size());
					if(list.size()!=0) {
						Long percentile = list.get(index);
						secPerc[i][j] = percentile;
					} else {
						secPerc[i][j] = 100000;
					}
				}
			}
			for(int i=0;i<nBins;i++)
			{	
				String s = "Bin,"+i+",next";
				for(int j=0;j<perc[i].length;j++)
				{
					s+=(","+perc[i][j]);
				}
				System.out.println(s);
				s = "Bin,"+i+",second-next";
				for(int j=0;j<secPerc[i].length;j++)
				{
					s+=(","+secPerc[i][j]);
				}
				System.out.println(s);
			}
			return;
		}
		/** End printing*/

		sr = new BufferedReader(new FileReader(sess));
		String outFile = outDir+"/my-app-gps-time-"+user+"-next-dist.csv";
		BufferedWriter bw = new BufferedWriter(new FileWriter(outFile));

		lastTime = -1L;
		int incounter=0,outcounter=0;
		//Continue reading for remaining days as test data
		while((line=sr.readLine())!=null) {
			incounter++;
			String tokens[] = line.split(",");
			//Print if session line
			if(tokens.length<=2){
				bw.write(line+"\n");
				outcounter++;
				continue;
			}
			long currentTime = Long.parseLong(line.split(",")[TIME_IDX]);
			if(lastTime==-1L){
				lastTime = currentTime;
				secondLastTime = currentTime;
			}
			GregorianCalendar gc = new GregorianCalendar(TimeZone.getTimeZone("GMT-7"));
			gc.setTimeInMillis(lastTime*1000);
			int hour = gc.get(Calendar.HOUR_OF_DAY);
			int timeOfDayBin=hour/binSize;
			long percentiles[] = perc[timeOfDayBin]; 
			String s = "";
			for(int i=0;i<percentiles.length;i++)
				s+= (","+percentiles[i]);
			gc.setTimeInMillis(secondLastTime*1000);
			hour = gc.get(Calendar.HOUR_OF_DAY);
			timeOfDayBin=hour/binSize;
			percentiles = secPerc[timeOfDayBin]; 
			for(int i=0;i<percentiles.length;i++)
				s+= (","+percentiles[i]);
			bw.write(line+s+"\n");
			outcounter++;
			secondLastTime = lastTime;
			lastTime = currentTime; 
		}
		bw.close();
		System.out.println("Written "+outcounter+" of "+incounter+" lines");
		System.out.println(" to file- "+outFile);
	}

	/**
		 * This method is used to generate files with imperfect CDF for time to next app
		 * when next app is 'app'.
		 * @param trainDays No of days for training
		 * @param nBins	divides time of day into number of bins
		 * @param inDir
		 * @param outDir
		 * @param user
		 * @param app
		 * @throws Exception
		 */
		@SuppressWarnings("unchecked")
		public void getImperfectNextAppTimeDistribution(int trainDays,int nBins, String inDir, String outDir,String user,String app) throws Exception{
			System.out.println("Imperfect Next App Dist for "+app);
			String sess = inDir+"/my-app-gps-time-"+user+"-nosess.csv";
			BufferedReader sr = new BufferedReader(new FileReader(sess));
			int binSize = 24/nBins;
			int totalDays = 0;
			int dayOfYear = 0;

			String line = null;
			long lastTime = -1L;
			LinkedList<Long> lists[] = new LinkedList[nBins];
			for(int i=0;i<nBins;i++)
				lists[i] = new LinkedList<Long>();

			while((line=sr.readLine())!=null) {
				String tokens[] = line.split(",");
				//Skip session line
				if(tokens.length<=2)
					continue;

				long currentTime = Long.parseLong(line.split(",")[TIME_IDX]);
				GregorianCalendar gc = new GregorianCalendar(TimeZone.getTimeZone("GMT-7"));
				gc.setTimeInMillis(currentTime*1000);
				int nDayOfYear = gc.get(Calendar.DAY_OF_YEAR);
				if(nDayOfYear!=dayOfYear) {
					dayOfYear = nDayOfYear;
					totalDays++;
				}
				if(totalDays==trainDays)
					sr.mark(2048);
				if(totalDays==(trainDays+1)){
					sr.reset();
					break;
				}

				if(lastTime==-1L)
					lastTime=currentTime;
				//Record time if app name is not there
				if(!tokens[APP_IDX].toLowerCase().contains(app.toLowerCase())){
					lastTime = currentTime;
					continue;
				}
				//We know that 'app' is present in this line
				gc.setTimeInMillis(lastTime*1000);
				int hour = gc.get(Calendar.HOUR_OF_DAY);
				int timeOfDayBin=hour/binSize;
				//Add time since last app to appropriate bin
				lists[timeOfDayBin].add(new Long(currentTime-lastTime));
				lastTime = currentTime;
			}
			//Get Percentiles from training data
			long perc[][] = new long[nBins][10];
			for(int i=0;i<nBins;i++) {
				LinkedList<Long> list = lists[i];
				Collections.sort(list);
				for(int j=0;j<10;j++) {
					int index = (int)(j*0.1*list.size());
					if(list.size()!=0) {
						Long percentile = list.get(index);
						perc[i][j] = percentile;
					} else {
						perc[i][j] = 100000;
					}
				}
			}

			String outFile = outDir+"/my-app-gps-time-"+user+"-next-dist.csv";
			BufferedWriter bw = new BufferedWriter(new FileWriter(outFile));

			lastTime = -1L;
			int incounter=0,outcounter=0;
			bw.write("Session,0\n");
			//Continue reading for remaining days as test data
			while((line=sr.readLine())!=null) {
				incounter++;
				String tokens[] = line.split(",");
				//Print if session line
				if(tokens.length<=2){
					bw.write(line+"\n");
					outcounter++;
					continue;
				}
				long currentTime = Long.parseLong(line.split(",")[TIME_IDX]);
				if(lastTime==-1L)
					lastTime = currentTime;
				GregorianCalendar gc = new GregorianCalendar(TimeZone.getTimeZone("GMT-7"));
				gc.setTimeInMillis(lastTime*1000);
				int hour = gc.get(Calendar.HOUR_OF_DAY);
				int timeOfDayBin=hour/binSize;
				long percentiles[] = perc[timeOfDayBin]; 
				String s = "";
				for(int i=0;i<percentiles.length;i++)
					s+= (","+percentiles[i]);
				bw.write(line+s+"\n");
				outcounter++;
				lastTime = currentTime; 
			}
			bw.close();
			System.out.println("Written "+outcounter+" of "+incounter+" lines");
			System.out.println(" to file- "+outFile);
		}

		/**
		 * This method is used to generate files with imperfect CDF for time to next app 
		 * and time to second next app
		 * when next app is 'app'.
		 * @param trainDays No of days for training
		 * @param nBins	divides time of day into number of bins
		 * @param inDir
		 * @param outDir
		 * @param user
		 * @param app
		 * @throws Exception
		 */
		@SuppressWarnings("unchecked")
		public void getImperfectSecondNextAppTimeDistribution(int trainDays,int nBins, String inDir, String outDir,String user,String app) throws Exception{
			System.out.println("Imperfect Second Next App Dist for "+app);
			String sess = inDir+"/my-app-gps-time-"+user+"-nosess.csv";
			BufferedReader sr = new BufferedReader(new FileReader(sess));
			int binSize = 24/nBins;
			int totalDays = 0;
			int dayOfYear = 0;

			String line = null;
			long lastTime = -1L;
			long secondLastTime = -1L;
			LinkedList<Long> lists[] = new LinkedList[nBins];
			LinkedList<Long> secLists[] = new LinkedList[nBins];
			for(int i=0;i<nBins;i++) {
				lists[i] = new LinkedList<Long>();
				secLists[i] = new LinkedList<Long>();
			}

			while((line=sr.readLine())!=null) {
				String tokens[] = line.split(",");
				//Skip session line
				if(tokens.length<=2)
					continue;

				long currentTime = Long.parseLong(line.split(",")[TIME_IDX]);
				GregorianCalendar gc = new GregorianCalendar(TimeZone.getTimeZone("GMT-7"));
				gc.setTimeInMillis(currentTime*1000);
				int nDayOfYear = gc.get(Calendar.DAY_OF_YEAR);
				if(nDayOfYear!=dayOfYear) {
					dayOfYear = nDayOfYear;
					totalDays++;
				}
				if(totalDays==trainDays)
					sr.mark(2048);
				if(totalDays==(trainDays+1)){
					sr.reset();
					break;
				}

				if(lastTime==-1L){
					lastTime=currentTime;
					secondLastTime = currentTime;
				}
				//Record time if app name is not there
				if(!tokens[APP_IDX].toLowerCase().contains(app.toLowerCase())){
					lastTime = currentTime;
					continue;
				}
				//We know that 'app' is present in this line
				gc.setTimeInMillis(lastTime*1000);
				int hour = gc.get(Calendar.HOUR_OF_DAY);
				int timeOfDayBin=hour/binSize;
				//Add time since last app to appropriate bin
				lists[timeOfDayBin].add(new Long(currentTime-lastTime));
				//Repeat for secondary list
				gc.setTimeInMillis(secondLastTime*1000);
				hour = gc.get(Calendar.HOUR_OF_DAY);
				timeOfDayBin=hour/binSize;
				//Add time since last app to appropriate bin
				secLists[timeOfDayBin].add(new Long(currentTime-secondLastTime));
				secondLastTime = lastTime;
				lastTime = currentTime;
			}
			//Get Percentiles from training data
			long perc[][] = new long[nBins][10];
			long secPerc[][] = new long[nBins][10];
			for(int i=0;i<nBins;i++) {
				LinkedList<Long> list = lists[i];
				Collections.sort(list);
				for(int j=0;j<10;j++) {
					int index = (int)(j*0.1*list.size());
					if(list.size()!=0) {
						Long percentile = list.get(index);
						perc[i][j] = percentile;
					} else {
						perc[i][j] = 100000;
					}
				}
				list = secLists[i];
				Collections.sort(list);
				for(int j=0;j<10;j++) {
					int index = (int)(j*0.1*list.size());
					if(list.size()!=0) {
						Long percentile = list.get(index);
						secPerc[i][j] = percentile;
					} else {
						secPerc[i][j] = 100000;
					}
				}
			}

			String outFile = outDir+"/my-app-gps-time-"+user+"-next-dist.csv";
			BufferedWriter bw = new BufferedWriter(new FileWriter(outFile));

			lastTime = -1L;
			int incounter=0,outcounter=0;
			bw.write("Session,0\n");
			//Continue reading for remaining days as test data
			while((line=sr.readLine())!=null) {
				incounter++;
				String tokens[] = line.split(",");
				//Print if session line
				if(tokens.length<=2){
					bw.write(line+"\n");
					outcounter++;
					continue;
				}
				long currentTime = Long.parseLong(line.split(",")[TIME_IDX]);
				if(lastTime==-1L){
					lastTime = currentTime;
					secondLastTime = currentTime;
				}
				GregorianCalendar gc = new GregorianCalendar(TimeZone.getTimeZone("GMT-7"));
				gc.setTimeInMillis(lastTime*1000);
				int hour = gc.get(Calendar.HOUR_OF_DAY);
				int timeOfDayBin=hour/binSize;
				long percentiles[] = perc[timeOfDayBin]; 
				String s = "";
				for(int i=0;i<percentiles.length;i++)
					s+= (","+percentiles[i]);
				gc.setTimeInMillis(secondLastTime*1000);
				hour = gc.get(Calendar.HOUR_OF_DAY);
				timeOfDayBin=hour/binSize;
				percentiles = secPerc[timeOfDayBin]; 
				for(int i=0;i<percentiles.length;i++)
					s+= (","+percentiles[i]);
				bw.write(line+s+"\n");
				outcounter++;
				secondLastTime = lastTime;
				lastTime = currentTime; 
			}
			bw.close();
			System.out.println("Written "+outcounter+" of "+incounter+" lines");
			System.out.println(" to file- "+outFile);
		}

		@SuppressWarnings("unchecked")
		public void getAppGapDistribution(int nBins, String inDir, String outDir,String user,String app) throws Exception{
			System.out.println("Median Dist for "+app);
			String sess = inDir+"/my-app-gps-time-"+user+"-nosess.csv";
			BufferedReader sr = new BufferedReader(new FileReader(sess));
			String line = null;
			long endTime = -1;
			boolean first = true;
			int binSize = 24/nBins;

			LinkedList<Long> lists[] = new LinkedList[nBins];
			for(int i=0;i<lists.length;i++) 
				lists[i] = new LinkedList<Long>();
			while((line=sr.readLine())!=null){
				String tokens[] = line.split(",");
				if(tokens.length<=2 || !tokens[APP_IDX].toLowerCase().contains(app))
					continue;
				long currentStartTime = Long.parseLong(tokens[TIME_IDX]);
				long currentEndTime = Long.parseLong(tokens[DURATION_IDX])+currentStartTime;
				GregorianCalendar gc = new GregorianCalendar(TimeZone.getTimeZone("GMT-7"));
				gc.setTimeInMillis(currentStartTime*1000);
				int hour = gc.get(Calendar.HOUR_OF_DAY);

				if(first){
					endTime = currentEndTime;
					first = false;
					continue;
				}
				int timeOfDayBin=hour/binSize;
				lists[timeOfDayBin].add(currentStartTime-endTime);
				endTime = currentEndTime;
			}
			sr.close();
			//Logic for mean median etc
			long perc[][] = new long[nBins][10];

			for(int i=0;i<nBins;i++) {
				LinkedList<Long> list = lists[i];
				Collections.sort(list);
				for(int j=0;j<10;j++) {
					int index = (int)(j*0.1*list.size());
					if(list.size()!=0) {
						Long percentile = list.get(index);
						perc[i][j] = percentile;
					} else {
						perc[i][j] = 100000;
					}
				}
			}
			int incounter=0,outcounter=0;
			sr = new BufferedReader(new FileReader(sess));
			String outFile = outDir+"/my-app-gps-time-"+user+"-next-dist.csv";
			BufferedWriter bw = new BufferedWriter(new FileWriter(outFile));
			while((line=sr.readLine())!=null){
				incounter++;
				String tokens[] = line.split(",");
				if(tokens.length<=2) {
					bw.write(line+"\n");
					outcounter++;
					continue;
				}
				long currentStartTime = Long.parseLong(tokens[1]);
				GregorianCalendar gc = new GregorianCalendar(TimeZone.getTimeZone("GMT-7"));
				gc.setTimeInMillis(currentStartTime*1000);
				int hour = gc.get(Calendar.HOUR_OF_DAY);
				int timeOfDayBin=hour/binSize;
				long percentiles[] = perc[timeOfDayBin]; 
				String s = "";
				for(int i=0;i<percentiles.length;i++)
					s+= (","+percentiles[i]);
				bw.write(line+s+"\n");
				outcounter++;
			}
			sr.close();
			bw.close();

			System.out.println("Written "+outcounter+" of "+incounter+" lines");
			System.out.println(" to file- "+outFile);


		}

		public void getFreshnessStats(String inDir, String users[]) throws Exception {
			System.out.println("#user min q1 q2 q3 max mean nsamples username");
			for(int i=0;i<users.length;i++) {
				String user=users[i];
				String file = inDir+"/my-app-gps-time-"+user+"-next-dist.frs";
				BufferedReader br = new BufferedReader(new FileReader(file));
				String s=null;
				LinkedList<Long> list = new LinkedList<Long>();
				while((s=br.readLine())!=null) {
					String tokens[] = s.split(",");
					list.add(Long.parseLong(tokens[1]));
				}
				Collections.sort(list);
				br.close();
				String TAB="\t";
				int size=list.size();
				if(size>0)
					System.out.println(i+TAB+(list.get(0)/1.0+1)+TAB+(list.get((int)(0.25*size))/1.0+1)
							+TAB+list.get((int)(0.5*size))/1.0+TAB+list.get((int)(0.75*size))/1.0
							+TAB+list.get((size-1))/1.0+TAB+size+TAB+user);
			}
		}

		public void getFreshnessStats(String inDir, String fileName, String label) throws Exception {
			String file = inDir+"/"+fileName;
			BufferedReader br = new BufferedReader(new FileReader(file));
			String s=null;
			LinkedList<Long> list = new LinkedList<Long>();
			while((s=br.readLine())!=null) {
				String tokens[] = s.split(",");
				list.add(Long.parseLong(tokens[1]));
			}
			Collections.sort(list);
			br.close();
			String TAB="\t";
			int size=list.size();
			if(size>0)
				System.out.println(label+TAB+(list.get((int)(0.25*size))/1.0)
						+TAB+list.get((int)(0.5*size))/1.0+TAB+list.get((int)(0.75*size))/1.0);
		}

		public static void main(String args[]) throws Exception{

			String inDir = "/Users/aparate/Documents/RA/projects/falcon/falcon/files2";
			String outDir = "/Users/aparate/Documents/RA/projects/falcon/falcon/files/fresh";

			String users[] = {"A00","A01","A02","A03","A04","A05","A06","A07","A08","A09","A10",
				"A11","A12","B00","B02","B03","B04","B05","B06","B07","B08","B09",
				"B10","B11","D00","D01","D02","D03","D04","D05","D06","D07","D08","D09"};

			PrefetchFileGenerator pfg = new PrefetchFileGenerator();

			/** Generate user files with time of day based CDF to evaluate freshness*/
			String app = "facebook";
			int nBins =6;
			boolean GENERATE = false;
			int DISTRIBUTION = SECOND_NEXT_PERFECT;
			if(DISTRIBUTION==MEDIAN_PERFECT) nBins = 24;
			int trainDays = 30;
			for(int i=0;i<users.length && GENERATE ;i++) {
				switch(DISTRIBUTION) {
				case NEXT_PERFECT: 
				{
					pfg.getNextAppTimeDistribution(nBins, inDir, outDir, users[i], app);
					break;
				}
				case NEXT_IMPERFECT: 
				{
					pfg.getImperfectNextAppTimeDistribution(trainDays,nBins, inDir, outDir, users[i], app);
					break;
				}
				case SECOND_NEXT_PERFECT:
				{
					pfg.getSecondNextAppTimeDistribution(nBins, inDir, outDir, users[i], app);
					break;
				}
				case SECOND_NEXT_IMPERFECT:
				{
					pfg.getImperfectSecondNextAppTimeDistribution(trainDays, nBins, inDir, outDir, users[i], app);
					break;
				}
				case MEDIAN_PERFECT:
				{
					pfg.getAppGapDistribution(nBins, inDir, outDir, users[i], app);
					break;
				}
				}
			}

			/** Generate freshness stats for boxplot */
			inDir ="/Users/aparate/Documents/RA/projects/falcon/falcon/files/fresh/facebook/frs-per-m11-fb-4x";
			//if(!GENERATE)
			//pfg.getFreshnessStats(inDir, users);

			/** Generate quartile results for aggregate of all users */
			inDir ="/Users/aparate/Documents/RA/projects/falcon/falcon/files/fresh/facebook/frs-per-m9-fb-0x";
			String fileName = "fresh-all.csv";
			String label = "default";
			if(!GENERATE)
				pfg.getFreshnessStats(inDir, fileName,label);
			inDir ="/Users/aparate/Documents/RA/projects/falcon/falcon/files/fresh/facebook/frs-per-ppm-fb-2x";
			label = "ppm-2x";
			if(!GENERATE)
				pfg.getFreshnessStats(inDir, fileName,label);
			inDir ="/Users/aparate/Documents/RA/projects/falcon/falcon/files/fresh/facebook/frs-per-m11-fb-2x";
			label="prod-2-2x";
			if(!GENERATE)
				pfg.getFreshnessStats(inDir, fileName,label);
			inDir ="/Users/aparate/Documents/RA/projects/falcon/falcon/files/fresh/facebook/frs-per-ppm-fb-4x";
			label = "ppm-4x";
			if(!GENERATE)
				pfg.getFreshnessStats(inDir, fileName,label);
			inDir ="/Users/aparate/Documents/RA/projects/falcon/falcon/files/fresh/facebook/frs-per-m11-fb-4x";
			label="prod-2-4x";
			if(!GENERATE)
				pfg.getFreshnessStats(inDir, fileName,label);
			inDir ="/Users/aparate/Documents/RA/projects/falcon/falcon/files/fresh/facebook/frs-per-ppm-fb-8x";
			label = "ppm-8x";
			if(!GENERATE)
				pfg.getFreshnessStats(inDir, fileName,label);
			inDir ="/Users/aparate/Documents/RA/projects/falcon/falcon/files/fresh/facebook/frs-per-m11-fb-8x";
			label="prod-2-8x";
			if(!GENERATE)
				pfg.getFreshnessStats(inDir, fileName,label);
			inDir ="/Users/aparate/Documents/RA/projects/falcon/falcon/files/fresh/facebook/frs-best-fb";
			label = "ppm-best";
			if(!GENERATE)
				pfg.getFreshnessStats(inDir, fileName,label);
			inDir ="/Users/aparate/Documents/RA/projects/falcon/falcon/files/fresh/facebook-4x-new";
			label = "prod-2-4x-new";
			//for(int i=0;i<users.length;i++){
			//fileName = "my-app-gps-time-"+users[i]+"-next-dist.frs";
			//System.out.println(users[i]);
			if(!GENERATE)
				pfg.getFreshnessStats(inDir, fileName,label);
			//}
		}
	}

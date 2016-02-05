package falcon.utils;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;

public class BatteryFileConverter {

	public static void interpolate(String inFile, String outFile) {
		try{
			BufferedReader br = new BufferedReader(new FileReader(inFile));
			BufferedWriter bw = new BufferedWriter(new FileWriter(outFile));
			String s = null;
			int count = 0;
			int lastValidLevel = 100;
			boolean startCounting = false;
			int missedCount = 0;
			while((s=br.readLine())!=null){
				String toks[] = s.split("[ \t]+");
				int level = Integer.parseInt(toks[3]);
				if(level!=0){
					if(!startCounting){
						count++;
						bw.write(count+"\t"+level+"\n");
					}
					else {
						//interpolate missed count and print missed data
						int delta = lastValidLevel-level;
						int stepSize = missedCount;
						if(delta!=0)
							stepSize = missedCount/delta;
						int added = 0;
						int lastPrinted = lastValidLevel;
						for(int i=0;i<(delta==0?1:delta);i++){
							for(int j=0;j<stepSize;j++){
								count++;
								added++;
								bw.write(count+"\t"+(lastValidLevel-i)+"\n");
								lastPrinted = lastValidLevel-i;
							}
						}
						while(added<missedCount){
							count++;
							added++;
							bw.write(count+"\t"+(lastPrinted)+"\n");
						}
						missedCount=0;
						startCounting = false;
						//Print current level
						count++;
						bw.write(count+"\t"+level+"\n");
					}
					lastValidLevel = level;
				}else {
					if(startCounting)
						missedCount++;
					else{
						startCounting=true;
						missedCount=1;
					}
				}
			}
			br.close();
			bw.close();
			//Now print start and end counts for each level
			int startCount = 1;
			int lastLevel = 100;
			br = new BufferedReader(new FileReader(outFile));
			while((s=br.readLine())!=null){
				String toks[] = s.split("[ \t]+");
				int level = Integer.parseInt(toks[1]);
				count = Integer.parseInt(toks[0]);
				if(level!=lastLevel){
					System.out.println(startCount+"\t"+lastLevel);
					System.out.println((count-1)+"\t"+lastLevel);
					lastLevel = level;
					startCount = count;
				}
			}
			System.out.println(startCount+"\t"+lastLevel);
			System.out.println((count)+"\t"+lastLevel);
			br.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public static void main(String args[]) {
		String file = "/Users/aparate/battery.log";
		String outfile = "/Users/aparate/battery-int.log";
		BatteryFileConverter.interpolate(file, outfile);
	}
 	
}

import java.util.ArrayList;
import java.util.Arrays;

public class RPVCalculation {

	public static int globalIndex=0;
	public static int peakThreshold=2200;
	public static float minDurationOfEachBreath=1.50f; // in second
	//public static int durationThreshold=100;	//when the sampling rate is 64 hz
	public static double durationThreshold=33; //when the sampling rate is 21.33 hz

	/**
	 * calculates the real peak valleys in two steps: a) find local max min from the given samples
	 * and b) then find real peaks and valleys
	 * It depends on a threshold value. all the real peaks will be above the threshold value.
	 * adaptive threshold is calculated according to the output of real peak value.
	 * whoever is using this function should also implement adaptive threshold value code. (e.g RealPeakValleyVirtualSensor.java)
	 * @param data
	 * @param timestamp
	 * @return real peaks and valleys as an integer array
	 * @author Mahbub
	 */
	public RPVCalculation()
	{
	}

	public RPVCalculation(double samplingFrequency)
	{
		if(samplingFrequency==21.33)
			durationThreshold=minDurationOfEachBreath*samplingFrequency;  //1.5*21.33=32
		if(samplingFrequency==64)
			durationThreshold=minDurationOfEachBreath*samplingFrequency;  //1.5*64=96
	}
	public int[]calculate(int[] data)
	{
		peakThreshold=(int)percentile(data, 70.0);
		int localMaxMin[]=getAllPeaknValley(data);
		int realPeakValley[]=getRealPeaknValley(localMaxMin);
		return realPeakValley;
	}
	/**
	 * calculates peaks and valleys (false + real) from the data buffer
	 * @param buffer
	 * @return list of tuple containing (valleyIndex, valley, peakIndex, peak). so if any method wants to use this method, it should read all the four values together.
	 * @author Mahbub
	 */
	public int[] getAllPeaknValley(int[] data)					//consider the timestamp issues. because it is important
	{

		//for testing:
		globalIndex=0;
		//////////////
		int prev_value1=0;
		int curr_value=0;
		boolean isStarting=true;
		int length=data.length;
		ArrayList<Integer> list=new ArrayList<Integer>();

		try {
			for(int i=0;i<length;){
				int line;
				if(isStarting && (i < length-1))
				{
					isStarting=false;
					prev_value1=data[i++];
					globalIndex++;
					curr_value=data[i++];
					globalIndex++;
					//skipping up to the first increasing sequence
					while((prev_value1>=curr_value)&& (i < length))
					{
						prev_value1=curr_value;
						line=data[i++];
						globalIndex++;
						curr_value=line;
					}
					list=addToTheList(list, globalIndex-1, prev_value1);		//prev_value1 is the current valley
					continue;
				}
				if(curr_value>prev_value1 )			//this means the sequence is increasing
				{
					while((prev_value1<=curr_value)&& (i < length))
					{
						prev_value1=curr_value;
						line=data[i++];
						globalIndex++;
						curr_value=line;
					}
					list=addToTheList(list,globalIndex-1, prev_value1);		//prev_value1 is the current valley
				}else //if(Integer.parseInt(curr_value)<Integer.parseInt(prev_value1))
				{
					while((prev_value1>=curr_value)&& (i < length))
					{
						prev_value1=curr_value;
						line=data[i++];
						globalIndex++;
						curr_value=line;
					}
					if(i!=length)
						list=addToTheList(list,globalIndex-1, prev_value1);		//prev_value1 is the current valley
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		//converting the ArrayList to array
		int peakValleys[]=new int[list.size()];
		for(int i=0;i<list.size();i++)
		{
			peakValleys[i]=list.get(i).intValue();
		}
		return peakValleys;
	}
	public ArrayList<Integer> addToTheList(ArrayList<Integer> list,int anchorIndex, int anchorValue)
	{
		Integer ind=new Integer(anchorIndex);
		Integer val=new Integer(anchorValue);
		list.add(ind);
		list.add(val);
		return list;
	}
	/**
	 * calculates real peaks and valleys from the data buffer
	 * @param data
	 * @return list of tuple containing (valleyIndex, valley, peakIndex, peak). so if any method wants to use this method, it should read all the four values together.
	 * @author Mahbub
	 */
	public int[] getRealPeaknValley(int[] data)			//check whether it is multiple of four....if not then discard the last part which does not fit to
	{
	//	System.out.println("peakThreshold= "+peakThreshold);
		boolean isStarting=true;
		ArrayList<Integer> list=new ArrayList<Integer>();

		int prev1_valleyIndex=-1;
		int prev1_valley=-1;		
		int prev1_peakIndex=-1;
		int prev1_peak=-1;
		int current_valleyIndex=-1;
		int current_valley=-1;		
		int current_peakIndex=-1;
		int current_peak=-1;
		int valleyAnchor=-1;
		int valleyAnchorIndex=-1;
		int realPeak=-1;
		int realPeakIndex=-1;
		int realValley=-1;
		int realValleyIndex=-1;

		//int valleyAnchorIndex=-1;
		//int valleyAnchor=-1;
		int valleyAnchorIndex1=-1;
		int valleyAnchor1=-1;
		int peakAnchor=-1;
		int peakAnchorIndex=-1;


		//I have to consider four values together to calculate the real peaks and valleys
		int i=0;
		int size=data.length;
		outer:
			for(;i<size;)
			{
				if(isStarting)		//check ...it should be equal or greater
				{
					//find the first real valley
					isStarting=false;
					if((size-i)<4)
					{
						i+=4;
						continue outer;
					}
					prev1_valleyIndex=data[i];
					prev1_valley=data[i+1];
					prev1_peakIndex=data[i+2];
					prev1_peak=data[i+3];
					valleyAnchor=prev1_valley;
					valleyAnchorIndex=prev1_valleyIndex;
//					if(prev1_peak>=peakThreshold)
//					{
//						realPeak=prev1_peak;
//						realPeakIndex=prev1_peakIndex;
//						realValley=valleyAnchor;
//						realValleyIndex=valleyAnchorIndex;
//						list=addToTheList(list, realValleyIndex, realValley);
//						list=addToTheList(list, realPeakIndex, realPeak);
//					}
					i+=4;
					if((size-i)<4)
					{
						i+=4;
						continue outer;
					}
					current_valleyIndex=data[i];
					current_valley=data[i+1];		
					current_peakIndex=data[i+2];
					current_peak=data[i+3];
					i+=4;
				}
				if(current_peak>prev1_peak)			//this means the sequence is increasing
				{
					while(prev1_peak<=current_peak)		//this is increasing trend
					{
						if((current_peak>=peakThreshold) /*&& realPeak!=0*/)				//then the previous valleyAnchor is real valley, check the peak to previous real peak against duration threshold
						{
							//then real valley update, inhalation period, exhalation period, IE ratio.
							if(peakAnchorIndex!=-1||(current_peakIndex - realPeakIndex)>=durationThreshold || realPeak==-1)
							{
								if((peakAnchorIndex!=-1)&&((current_peakIndex- peakAnchorIndex)>=durationThreshold)&& (realPeakIndex!=peakAnchorIndex)&& peakAnchorIndex>valleyAnchorIndex)
								{
									realPeak=peakAnchor;
									realPeakIndex=peakAnchorIndex;
									if(valleyAnchor<peakThreshold || valleyAnchorIndex<valleyAnchorIndex1)
									{
										realValley=valleyAnchor;
										realValleyIndex=valleyAnchorIndex;
									}
									else
									{
										realValley=valleyAnchor1;					//this is a previous valley candidate
										realValleyIndex=valleyAnchorIndex1;
									}
									peakAnchor=current_peak;
									peakAnchorIndex=current_peakIndex;
									if(realPeak!=-1)
									{
										list=addToTheList(list, realValleyIndex, realValley);
										list=addToTheList(list, realPeakIndex, realPeak);
									}
								}
								peakAnchor=current_peak;
								peakAnchorIndex=current_peakIndex;
								if(current_valley<peakThreshold || realValleyIndex==prev1_peakIndex)
								{
									valleyAnchor=current_valley;
									valleyAnchorIndex=current_valleyIndex;
								}
								else
								{
//									valleyAnchor=prev1_valley;
//									valleyAnchorIndex=prev1_valleyIndex;
									if(prev1_valley<peakThreshold)
									{
										valleyAnchor=prev1_valley;
										valleyAnchorIndex=prev1_valleyIndex;
									}else
									{
										int m=getValleyAnchorIndexBelowThreshold(data, i+1, realPeak);
										if(m==0)
										{
											valleyAnchor=prev1_valley;
											valleyAnchorIndex=prev1_valleyIndex;
										}
										else if(data[i]<peakAnchorIndex)
										{
											valleyAnchor=data[m];
											valleyAnchorIndex=data[m-1];
										}
									}
								}
							}
						}
						prev1_valleyIndex=current_valleyIndex;
						prev1_valley=current_valley;
						prev1_peakIndex=current_peakIndex;
						prev1_peak=current_peak;
						if((size-i)<4)
						{
							i+=4;
							continue outer;
						}
						current_valleyIndex=data[i];				//line=dis.readLine();
						current_valley=data[i+1];		
						current_peakIndex=data[i+2];
						current_peak=data[i+3];
						i+=4;										//curr_value=line.split(" ");
					}
					if(realPeakIndex<peakAnchorIndex && realPeakIndex!=-1)
					{

						realPeak=peakAnchor;
						realPeakIndex=peakAnchorIndex;

						if(valleyAnchor<peakThreshold ||valleyAnchorIndex1<realPeakIndex || valleyAnchorIndex<valleyAnchorIndex1 || (valleyAnchorIndex1<realValleyIndex && valleyAnchorIndex>realValleyIndex))
						{
							realValley=valleyAnchor;
							realValleyIndex=valleyAnchorIndex;
						}
						else
						{
							realValley=valleyAnchor1;					//this is a previous valley candidate
							realValleyIndex=valleyAnchorIndex1;
						}
						list=addToTheList(list, realValleyIndex, realValley);
						list=addToTheList(list, realPeakIndex, realPeak);
					}
					else if(current_peak>=peakThreshold)
					{
						if(realPeakIndex==-1 && realPeakIndex<peakAnchorIndex)
						{
							//check this thing
							realPeak=peakAnchor;
							realPeakIndex=peakAnchorIndex;
							realValley=valleyAnchor;
							realValleyIndex=valleyAnchorIndex;
							list=addToTheList(list, realValleyIndex, realValley);
							list=addToTheList(list, realPeakIndex, realPeak);
						}
						if((current_peakIndex - realPeakIndex)>=durationThreshold)
						{
							peakAnchor=current_peak;
							peakAnchorIndex=current_peakIndex;
							if(current_valley<peakThreshold || realValleyIndex==prev1_peakIndex)
							{
								valleyAnchor=current_valley;
								valleyAnchorIndex=current_valleyIndex;
							}
							else
							{
//														valleyAnchor=prev1_valley;
//														valleyAnchorIndex=prev1_valleyIndex;
								if(prev1_valley<peakThreshold)
								{
									valleyAnchor=prev1_valley;
									valleyAnchorIndex=prev1_valleyIndex;
								}else
								{
									int m=getValleyAnchorIndexBelowThreshold(data, i+1, realPeak);
									if(m==0)
									{
										valleyAnchor=prev1_valley;
										valleyAnchorIndex=prev1_valleyIndex;
									}
									else if(data[i]<peakAnchorIndex)
									{
										valleyAnchor=data[m];
										valleyAnchorIndex=data[m-1];
									}
								}
							}
						}
					}
				}else
				{
					while(prev1_peak>=current_peak)		//this is decreasing trend
					{
						if((current_peak>=peakThreshold) && ((current_peakIndex - realPeakIndex)>=durationThreshold) && realPeak!=-1)				//then the previous valleyAnchor is real valley, check the peak to previous real peak against duration threshold
						{
							if(realPeakIndex<peakAnchorIndex && realPeakIndex!=-1 && ((current_peakIndex - peakAnchorIndex)>=durationThreshold))
							{
								realPeak=peakAnchor;
								realPeakIndex=peakAnchorIndex;
								if(valleyAnchor<peakThreshold)
								{
									realValley=valleyAnchor;
									realValleyIndex=valleyAnchorIndex;
								}
								else
								{
									realValley=valleyAnchor1;					//this is a previous valley candidate
									realValleyIndex=valleyAnchorIndex1;
								}					
								list=addToTheList(list, realValleyIndex, realValley);
								list=addToTheList(list, realPeakIndex, realPeak);
							}
							peakAnchor=current_peak;
							peakAnchorIndex=current_peakIndex;
							if(current_valley<peakThreshold || realValleyIndex==prev1_valleyIndex)
							{
								valleyAnchor=current_valley;
								valleyAnchorIndex=current_valleyIndex;
							}
							else
							{
//															valleyAnchor=prev1_valley;
//															valleyAnchorIndex=prev1_valleyIndex;
								if(prev1_valley<peakThreshold)
								{
									valleyAnchor=prev1_valley;
									valleyAnchorIndex=prev1_valleyIndex;
								}else
								{
									int m=getValleyAnchorIndexBelowThreshold(data, i+1, realPeak);
									if(m==0)
									{
										valleyAnchor=prev1_valley;
										valleyAnchorIndex=prev1_valleyIndex;
									}
									else if(data[i]<peakAnchorIndex)
									{
										valleyAnchor=data[m];
										valleyAnchorIndex=data[m-1];
									}
								}
							}
						}
						prev1_valleyIndex=current_valleyIndex;			//prev_value1=curr_value;
						prev1_valley=current_valley;
						prev1_peakIndex=current_peakIndex;
						prev1_peak=current_peak;

						if((size-i)<4)
						{
							i+=4;
							continue outer;
						}

						current_valleyIndex=data[i];				//line=dis.readLine();
						current_valley=data[i+1];		
						current_peakIndex=data[i+2];
						current_peak=data[i+3];
						i+=4;										//curr_value=line.split(" ");
					}
					valleyAnchor1=current_valley;
					valleyAnchorIndex1=current_valleyIndex;
				}
			}
		ArrayList<Integer> list1=postProcessing(list);
		//converting the ArrayList to array
		int realPeakValleys[]=new int[list1.size()];
		for(int j=0;j<list1.size();j++)
		{
			realPeakValleys[j]=list1.get(j).intValue();
		}
		return realPeakValleys;
	}
	/**
	 * @param prevRealPeakIndex prev real peak location in local min max array array
	 * @param data local min max array in [index+valley ,index+peak] format
	 * @param startIndex the starting point of the back tracking to search the valley anchor
	 * @return valleyAnchor Index
	 */

	public int getValleyAnchorIndexBelowThreshold(int data[],int startIndex, int prevRealPeak)
	{
		int prevRealPeakIndex=0;
		if(prevRealPeak==-1)
			return 0;
		//		for(int k=0;k<data.length;k++)
		//			System.out.print(data[k]+" ");
//		System.out.println("data length= "+data.length);

//		System.out.println();
		if(startIndex>=data.length)
			return 0;
		for(int j=startIndex;j>0;j=j-2)
		{
			//			System.out.println("j = "+j);
			if(data[j]==prevRealPeak)
			{
				prevRealPeakIndex=j;
				break;
			}
		}
		for(int i=startIndex;i>0;i=i-4)
		{
			if(data[i]<peakThreshold && i>prevRealPeakIndex)
				return i;
		}
		return 0;
	}
	//check this code
	public ArrayList<Integer> postProcessing(ArrayList<Integer> list)
	{
		if(list.size()<8) //at least two peaks required for this processing
			return list;
		int size=list.size();
		for(int i=2;i<size-4;i+=4)
		{
			if(list.get(i+4).intValue()-list.get(i).intValue()<durationThreshold)
			{
				size-=4;
				if(list.get(i+5).intValue()>list.get(i+1).intValue())
				{
					list.remove(i);
					list.remove(i);
					list.remove(i);
					list.remove(i);
				}
				else
				{
					list.remove(i+2);
					list.remove(i+2);
					list.remove(i+2);
					list.remove(i+2);
				}
			}
		}
		//for negetive inhalations.....//need to thought carefully later
		if(list.size()>=8)
		{
			for(int i=0;i<list.size()-4;i+=4)
			{
				if(list.get(i).intValue()==list.get(i+4).intValue())
				{
					list.remove(i);
					list.remove(i);
					list.remove(i);
					list.remove(i);
				}
			}
		}
		return list;
	}
public static double percentile(final int[] values,final double p) {
		
//		String ripData="";
//		for(int i=0;i<values.length;i++)
//		{
//			ripData+=values[i]+",";
//		}
//		Log.d("percentile","percentile raw="+ripData);
		
		if ((p > 100) || (p <= 0)) {
			throw new IllegalArgumentException("invalid quantile value: " + p);
		}
		double n = (double) values.length;
		if (n == 0) {
			return Double.NaN;
		}
		if (n == 1) {
			return values[0]; // always return single value for n = 1
		}
		double pos = p * (n + 1) / 100;
		double fpos = Math.floor(pos);
		int intPos = (int) fpos;
		double dif = pos - fpos;
		int[] sorted = new int[values.length];
		System.arraycopy(values, 0, sorted, 0, values.length);
		Arrays.sort(sorted);

		if (pos < 1) {
			return sorted[0];
		}
		if (pos >= n) {
			return sorted[values.length - 1];
		}
		double lower = sorted[intPos - 1];
		double upper = sorted[intPos];
		return lower + dif * (upper - lower);
	}

}

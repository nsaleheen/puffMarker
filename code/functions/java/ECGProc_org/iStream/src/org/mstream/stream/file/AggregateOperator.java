package org.mstream.stream.file;

import java.io.BufferedWriter;
import java.util.Calendar;
import java.util.GregorianCalendar;

import org.mstream.stream.IStream;
import org.mstream.stream.items.DoubleValuesItem;
import org.mstream.stream.items.IStreamItem;

import edu.umass.cs.sensors.utils.io.IOUtils;
import edu.umass.cs.sensors.utils.io.Logger;

/**
 * Computes various aggregates over a timed-window
 * <p>
 * Input Stream: Any stream<br/>
 * 
 * @author Abhinav Parate
 */
public class AggregateOperator implements IStream<DoubleValuesItem>{


	private DoubleValuesItem nextItem = null;

	

	//Variables for tracking next item
	private boolean verifiedNext = false;
	private boolean hasNext = false;
	private int validDataPoints = -1;
	private int WINDOW_IN_SECONDS = -1;
	private int INDEX_TO_READ[] = null;

	private IStream<IStreamItem> child = null;
	
	private AggregateType aggType = AggregateType.AVERAGE;
	private AggregateWindow winType = null;
	
	/**
	 *  Indicates Aggregator to aggregate over window aligned on days, hours, minutes, seconds
	 * 
	 * @author Abhinav Parate
	 */
	public enum AggregateWindow {DAY,HOUR,MINUTE,SECOND};
	
	/**
	 * Specifies the type of aggregation to perform
	 * 
	 * @author Abhinav Parate
	 * 
	 */
	public enum AggregateType {AVERAGE,MIN,MAX,SUM,COUNT};


	/**
	 * Constructor for {@link AggregateOperator}
	 * @param WINDOW_IN_SECONDS results in 1 output for each window
	 * @param INDEX_TO_READ indices of columns to be aggregated
	 * @param aggType type of aggregator
	 */
	public AggregateOperator(int WINDOW_IN_SECONDS, int INDEX_TO_READ[], AggregateType aggType){
		this.WINDOW_IN_SECONDS = WINDOW_IN_SECONDS;
		this.INDEX_TO_READ = INDEX_TO_READ;
		this.aggType = aggType;
	}
	
	/**
	 * Constructor for {@link AggregateOperator}
	 * @param winType type of aggregate window
	 * @param INDEX_TO_READ indices of columns to be aggregated
	 * @param aggType type of aggregator
	 */
	public AggregateOperator(AggregateWindow winType, int INDEX_TO_READ[], AggregateType aggType) {
		this.winType = winType;
		this.INDEX_TO_READ = INDEX_TO_READ;
		this.aggType = aggType;
	}



	/**
	 * Returns next {@link DoubleValuesItem}
	 * @see org.mstream.stream.IStream#getNextItem()
	 **/
	@Override
	public DoubleValuesItem getNextItem() {
		if(verifiedNext && hasNext){
			verifiedNext = false;
			return nextItem;
		} 
		else if(!verifiedNext) 
		{
			hasNext = readNext();
			verifiedNext = false;
			if(hasNext)
				return nextItem;
		}
		return null;
	}

	/** 
	 * Add one child stream
	 * @throws Exception if stream is not of valid type 
	 * @see org.mstream.stream.IStream#addChildStreams(org.mstream.stream.IStream[])
	 **/
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public void addChildStreams(IStream... streams) {
		for(IStream stream:streams)
			child = (IStream<IStreamItem>)stream;
	}

	@Override
	public boolean hasNext(){
		if(verifiedNext)
			return hasNext;
		hasNext = readNext();
		return hasNext;
	}


	@Override
	public void closeStream() {

		if(child!=null)
			child.closeStream();
		verifiedNext = true;
		hasNext = false;
	}

	/**
	 * Reads the next item, returns true if next item is read successfully<p>
	 * Sets verifiedNext to true only when next item is found
	 * @return true if reads next item successfully
	 */
	private boolean readNext() {
		if(child==null)
		{
			verifiedNext = true;
			return false;
		}
		if(!child.hasNext())
		{
			verifiedNext = true;
			return false;
		}
		verifiedNext = true;
		return readNSecondsSamples();
	}

	/**
	 * Reads samples for N seconds, computes average and saves it in next Item
	 * @return true if successfully reads N sample
	 */
	private boolean readNSecondsSamples(){
		boolean success = true;
		validDataPoints = 0;
		long startTime = -1;
		long WINDOW_IN_MS = WINDOW_IN_SECONDS*1000;
		double sum[] = new double[INDEX_TO_READ.length];
		while(success){
			if(child.hasNext()) 
			{
				IStreamItem item = child.getNextItem();
				if(startTime==-1) startTime = item.timeStamp;
				try{
					//TODO:Implement aggregators other than average
					for(int i=0;i<sum.length;i++)
						sum[i] +=  item.getValueAsDouble(INDEX_TO_READ[i]);
					validDataPoints++;
					if(testBreakCondition(startTime, item.timeStamp, WINDOW_IN_MS)){
						break;
					}
				} catch(Exception e){
					e.printStackTrace();
					Logger.error(e.getLocalizedMessage());
					continue;
				}
			}
			else {
				//Exhausted stream, no more data
				success = false;
				break;
			}
		} //Read window and computed sum over window
		if(validDataPoints>0 && startTime>0) {
			Calendar c = GregorianCalendar.getInstance();
			c.setTimeInMillis(startTime);
			
			Double result[] = new Double[sum.length+3];
			for(int i=0;i<sum.length;i++)
				result[i+3] = sum[i]/validDataPoints;
			result[0] = (double)c.get(Calendar.DAY_OF_YEAR);
			result[1] = (double)c.get(Calendar.HOUR_OF_DAY);
			result[2] = (double)c.get(Calendar.MINUTE);
					
			nextItem = new DoubleValuesItem(startTime,result);
			return true;
		}
		else { 
			Logger.log("FAILED "+startTime+" "+validDataPoints);
			nextItem = null;
			return false;
		}
	}


	private boolean testBreakCondition(long startTime, long currentTime, long WINDOW_IN_MS) {
		if(WINDOW_IN_MS>0) {
			if(currentTime-startTime >= WINDOW_IN_MS) return true;
			return false;
		} else {
			Calendar start = GregorianCalendar.getInstance();
			start.setTimeInMillis(startTime);
			Calendar current = GregorianCalendar.getInstance();
			current.setTimeInMillis(currentTime);
			int sVal = 0,cVal = 0;
			switch(winType) {
			case DAY:
				sVal = start.get(Calendar.DAY_OF_YEAR);
				cVal = current.get(Calendar.DAY_OF_YEAR);
				if(sVal!=cVal) return true;
				return false;
			case HOUR:
				sVal = start.get(Calendar.HOUR_OF_DAY);
				cVal = current.get(Calendar.HOUR_OF_DAY);
				if(sVal!=cVal) return true;
				return false;
			case MINUTE:
				sVal = start.get(Calendar.MINUTE);
				cVal = current.get(Calendar.MINUTE);
				if(sVal!=cVal) return true;
				return false;
			case SECOND:
				sVal = start.get(Calendar.SECOND);
				cVal = current.get(Calendar.SECOND);
				if(sVal!=cVal) return true;
				return false;
			default:
				sVal = start.get(Calendar.SECOND);
				cVal = current.get(Calendar.SECOND);
				if(sVal!=cVal) return true;
				return false;
			}	
		}
	}
	

	/**
	 * Saves Timed average stream with timestamps
	 * @see org.mstream.stream.IStream#saveStreamToFile(java.lang.String)
	 **/
	@Override
	public void saveStreamToFile(String filePath) {
		BufferedWriter bw = IOUtils.getWriter(filePath);
		while(hasNext())
		{
			DoubleValuesItem item = getNextItem();
			if(item!=null)
				IOUtils.writeLine(item.toString(), bw);
		}
		IOUtils.close(bw);
	}
}

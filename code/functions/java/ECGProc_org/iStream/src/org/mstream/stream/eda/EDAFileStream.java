package org.mstream.stream.eda;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.sql.Timestamp;
import java.util.LinkedList;

import org.mstream.stream.IStream;
import org.mstream.stream.items.StringValuesItem;

import edu.umass.cs.sensors.utils.io.IOUtils;
import edu.umass.cs.sensors.utils.io.Logger;

/**
 * A stream to read EDA file
 * @author aparate
 *
 */
public class EDAFileStream implements IStream<StringValuesItem>{


	
	/** Lists having file names and header info */
	private LinkedList<String> fileList = new LinkedList<String>();
	
	/**
	 * Variable to track the file being processed by the stream
	 */
	private int fileIndex = -1;

	/**
	 * The next item to be returned
	 */
	private StringValuesItem nextItem = null;

	/**
	 * Variable indicates the last file has been read completely
	 */
	private boolean fileEnded = true;
	private BufferedReader reader = null;
	private boolean verifiedNext = false;
	private boolean hasNext = false;
	
	/**
	 * Milliseconds Time difference between two records.<p>Used in computation of time for individual record.
	 */
	private double delta = 125;
	
	/**
	 * EDA file does not have time for each record. We compute this from the start time available in header.
	 */
	private long startTime = 0L;

	
	/**
	 * Constructor for EDAFileStream
	 * @param SAMPLE_RATE sampling rate of the files in Hz
	 */
	public EDAFileStream(int SAMPLE_RATE){
		delta = 1000.0/SAMPLE_RATE;
	}

	/**
	 * Add files in the order they need to processed
	 * @param file path to the input file
	 */
	public void addFileToStream(String file) {
		fileList.add(file);
	}

	/**
	 * Returns next stringitem
	 * @see org.mstream.stream.IStream#getNextItem()
	 **/
	@Override
	public StringValuesItem getNextItem() {
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
	 * Filestream does not use this method as there are no child streams
	 * @see org.mstream.stream.IStream#addChildStreams(org.mstream.stream.IStream[])
	 **/
	@SuppressWarnings("rawtypes")
	@Override
	public void addChildStreams(IStream... stream) {}

	@Override
	public boolean hasNext(){
		if(verifiedNext)
			return hasNext;
		hasNext = readNext();
		return hasNext;
	}
	
	/* (non-Javadoc)
	 * @see org.istream.stream.IStream#closeStream()
	 */
	@Override
	public void closeStream() {
		
		IOUtils.close(reader);
		verifiedNext = true;
		hasNext = false;
		fileList.clear();
		nextItem = null;
	}

	/**
	 * Reads the next item, returns true if next item is read successfully
	 * Sets verifiedNext to true only when next item is found
	 * @return true if reads next item successfully
	 */
	private boolean readNext() {
		if(fileEnded){
			if(fileIndex>=fileList.size()-1) {
				verifiedNext = true;
				return false;
			}
			else {
				if(reader!=null) IOUtils.close(reader);
				fileIndex++;
				reader = IOUtils.getReader(fileList.get(fileIndex));
				fileEnded = false;
				if(reader==null) {
					//Could not read file, skip
					Logger.debug("Skipping file:"+fileList.get(fileIndex));
					fileEnded = true;
					return readNext();
				}
				try{
					readStartTimeFromHeader();
				}catch(Exception e) {
					//Could not read file, skip
					Logger.debug("Skipping file:"+fileList.get(fileIndex));
					fileEnded = true;
					return readNext();
				}
			}
		}
		//Loop until we get valid next item
		while(true) {
			String s = IOUtils.readLine(reader);
			if(s==null)
			{
				fileEnded = true;
				return readNext();
			} else {
				try{
					nextItem = parseItem(s);
					verifiedNext = true;
					return true;
				} catch(Exception e){
					Logger.error(e.getLocalizedMessage());
					continue;
				}
			}
		}
		//Done
	}
	
	private void readStartTimeFromHeader() throws Exception{
		String s = null;
		String date = null;
		
		while((s=reader.readLine())!=null) {
			if(s.contains("Start Time")) {
				String toks[] = s.split("[ \t]+");
				date = toks[2]+" "+toks[3];
				startTime = (long)(Timestamp.valueOf(date).getTime()-delta);
			}
			if(s.contains("----"))
				break;
		}
	}

	/**
	 * Parse string item from the string
	 * @param s input string
	 */
	private StringValuesItem parseItem(String s) {
		String tokens[] = s.split(",");
		startTime += delta;
		return new StringValuesItem(startTime,tokens);
	}

	/**
	 * EDA filestream saves stream with timestamps
	 * @see org.mstream.stream.IStream#saveStreamToFile(java.lang.String)
	 **/
	@Override
	public void saveStreamToFile(String filePath) {
		BufferedWriter bw = IOUtils.getWriter(filePath);
		while(hasNext())
		{
			StringValuesItem item = getNextItem();
			IOUtils.writeLine(item.toString(), bw);
		}
		IOUtils.close(bw);
		
	}

}

package org.mstream.stream.file;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.sql.Timestamp;
import java.util.Arrays;
import java.util.LinkedList;

import org.mstream.stream.IStream;
import org.mstream.stream.items.StringValuesItem;

import edu.umass.cs.sensors.utils.io.IOUtils;
import edu.umass.cs.sensors.utils.io.Logger;


/**
 * A stream that reads the files with lines containing comma-separated or tab-separated values. 
 * Any delimiter may be used for the purpose.
 * @author aparate
 *
 */
public class SVFileStream implements IStream<StringValuesItem>{


	/**
	 * Regular expression to split line in the file
	 */
	private String regEx = ",";
	private TimeFormat format = TimeFormat.UNIXTIME;

	/** List with file names in the order files should be processed*/
	private LinkedList<String> fileList = new LinkedList<String>();
	/** List indicates if the file has a header info in it */
	private LinkedList<Boolean> hasHeaderList = new LinkedList<Boolean>();

	

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
	private boolean knownFormat = false;

	/**
	 * Constructor for file stream
	 * @param separatorRegEx regular expression describing how the values are separated in a line. CSV, TSV, etc.
	 * @param format Format of the timestamp in file
	 */
	public SVFileStream(String separatorRegEx, TimeFormat format){
		if(separatorRegEx!=null)
			regEx = separatorRegEx;
		//Format is known in advance
		knownFormat = true;
		this.format = format;
	}

	/**
	 * Constructor does not know the timestamp format
	 * @param separatorRegEx Regular expression of delimiters in a line
	 */
	public SVFileStream(String separatorRegEx){
		if(separatorRegEx!=null)
			regEx = separatorRegEx;
	}

	/**
	 * Add files in the order they need to processed
	 * @param file
	 * @param hasHeader
	 */
	public void addFileToStream(String file,boolean hasHeader) {
		fileList.add(file);
		hasHeaderList.add(hasHeader);
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
		hasHeaderList.clear();
		nextItem = null;
	}

	/**
	 * Reads the next item, returns true if next item is read successfully
	 * Sets verifiedNext to true only when next item is found
	 * @return true if reads next item successfully
	 */
	private boolean readNext() {
		if(fileEnded){
			if(fileIndex==fileList.size()-1) {
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
				if(hasHeaderList.get(fileIndex))
					IOUtils.readLine(reader);
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
					e.printStackTrace();
					Logger.error(e.getLocalizedMessage()+" line:"+s);
					continue;
				}
			}
		}
		//Done
	}

	/**
	 * Parse string item from the string
	 * @param s input pattern-separated values string
	 * @return item
	 */
	private StringValuesItem parseItem(String s) {
		String tokens[] = s.split(regEx);
		long ts = 0;
		if(!knownFormat) checkTimeFormat(tokens[0]);
		
		if(format == TimeFormat.UNIXTIME)
			ts = Long.parseLong(tokens[0]);
		else if(format == TimeFormat.ISO)
			ts = Timestamp.valueOf(tokens[0]).getTime();
		else //if(format == TimeFormat.DDMMYY) //Let it throw exception
		{
			tokens[0] = tokens[0].replace("/", "-");
			String subToks[] = tokens[0].split("[ -]+");
			String isoTimeString = subToks[2]+"-"+subToks[1]+"-"+subToks[0]+" "+subToks[3];
			ts = Timestamp.valueOf(isoTimeString).getTime();
		}

		return new StringValuesItem(ts,Arrays.copyOfRange(tokens, 1, tokens.length));
	}

	private void checkTimeFormat(String s)
	{
		try{
			Timestamp.valueOf(s);
			format = TimeFormat.ISO;
			knownFormat = true;
			return;
		}catch(Exception e){}
		try{
			Long.parseLong(s);
			format = TimeFormat.UNIXTIME;
			knownFormat = true;
			return;
		}catch(Exception e){}
		try{
			s = s.replace("/", "-");
			String tokens[] = s.split("[ -]+");
			String isoTimeString = tokens[2]+"-"+tokens[1]+"-"+tokens[0]+" "+tokens[3];
			Timestamp.valueOf(isoTimeString);
			format = TimeFormat.DDMMYY;
			knownFormat = true;
			return;
		}catch(Exception e){}
		format = TimeFormat.UNKNOWN;
		knownFormat = false;
	}

	/** Does nothing
	 * @see org.mstream.stream.IStream#saveStreamToFile(java.lang.String)
	 */
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

package org.mstream.stream.file;

/**
 * Indicates the Format of timestamp in file
 * <p>
 * {@code ISO}: ISO standard format parseable by SQL timestamp class<br/>
 * {@code UNIXTIME} Time in milliseconds since epoch <br/>
 * {@code DDMMYY} Accepts following format "31-01-2012 10:00:00[.000]" or "31/01/2012 10:00:00[.000]" <br/>
 * {@code UNKNOWN} Stream won't process if format is none of the above.
 */
public enum TimeFormat {
	/** ISO standard format parseable by {@link java.sql.Timestamp} class */
	ISO,
	/** Accepts format "31-01-2012 10:00:00.000" or "31/01/2012 10:00:00:000" */
	DDMMYY,
	/** Time in milliseconds since epoch */
	UNIXTIME,
	/** Unknown format. Stream won't process if format is none of the above */
	UNKNOWN};
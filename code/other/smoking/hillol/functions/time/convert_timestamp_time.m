function str=convert_timestamp_time(G,curtime)
dnOffset = datenum('01-Jan-1970');
tstamp=curtime/1000.0;
timezone=G.TIME.TIMEZONE;
dnNow = tstamp/(24*60*60) + dnOffset +timezone/24.0;
str=datestr(dnNow,G.TIME.FORMAT);
len=length(curtime);
for i=1:len
		if G.TIME.DAYLIGHTSAVING==1
			if is_Daylight_Savings(str(i,:))==1
				timezone=G.TIME.TIMEZONE+1;
				dnNow(i) = tstamp(i)/(24*60*60) + dnOffset +timezone/24.0;
				str(i,:)=datestr(dnNow(i),G.TIME.FORMAT);
			end
		end
	
end
end

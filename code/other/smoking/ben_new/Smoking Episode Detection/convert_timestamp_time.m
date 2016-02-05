function str=convert_timestamp_time(curtime)
dnOffset = datenum('01-Jan-1970');
tstamp=curtime/1000.0;
timezone=-6;
dnNow = tstamp/(24*60*60) + dnOffset +timezone/24.0;
str=datestr(dnNow,'mm/dd/yyyy HH:MM:SS');
len=length(curtime);
for i=1:len
			if is_Daylight_Savings(str(i,:))==1
				timezone=timezone+1;
				dnNow(i) = tstamp(i)/(24*60*60) + dnOffset +timezone/24.0;
				str(i,:)=datestr(dnNow(i),'mm/dd/yyyy HH:MM:SS');
			end
	
end
end

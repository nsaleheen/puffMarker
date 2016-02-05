function mattime=convert_timestamp_matlabtimestamp(G,curtime)
if isempty(curtime)
	mattime=[];
	return ;
end
dnOffset = datenum('01-Jan-1970');
tstamp=curtime/1000.0;
timezone=G.TIME.TIMEZONE;
mattime = tstamp/(24*60*60) + dnOffset +timezone/24.0;
if G.TIME.DAYLIGHTSAVING==1
	len=length(curtime);
	if len==1
		str=datestr(mattime,G.TIME.FORMAT);
		if is_Daylight_Savings(str)==1
			timezone=G.TIME.TIMEZONE+1;
			mattime = tstamp/(24*60*60) + dnOffset +timezone/24.0;
		end	
	else
		f=0;
		s=0;
		str=datestr(mattime(1),G.TIME.FORMAT);
		if is_Daylight_Savings(str)==1
			f=1;
		end
		str=datestr(mattime(end),G.TIME.FORMAT);
		if is_Daylight_Savings(str)==1
			s=1;
		end
		if f==s
			if f==1
				timezone=G.TIME.TIMEZONE+1;
				mattime = tstamp/(24*60*60) + dnOffset +timezone/24.0;
			end
		else
			for i=1:len
				str=datestr(mattime(i),G.TIME.FORMAT);
				if is_Daylight_Savings(str)==1
					timezone=TIME.TIMEZONE+1;
					mattime(i) = tstamp(i)/(24*60*60) + dnOffset +timezone/24.0;
				end
			end
		end
	end
end
if size(curtime,1)~=size(mattime,1)
	mattime=mattime';
end
end

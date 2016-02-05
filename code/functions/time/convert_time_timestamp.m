function timestamp=convert_time_timestamp(G,time_str)
timezone=G.TIME.TIMEZONE;
if G.TIME.DAYLIGHTSAVING==1
    if is_Daylight_Savings(time_str)==1
        timezone=timezone+1;
    end
end
unixstart = datenum([1970,1,1,0,0,0]);
matlabtime = datenum(time_str, G.TIME.FORMAT);
timestamp=(matlabtime-unixstart)*24*60*60*1000;
timestamp=timestamp-timezone*60*60*1000;
end


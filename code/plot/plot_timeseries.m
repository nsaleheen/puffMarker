function plot_timeseries(sample,timestamp,linetype,linewidth)
ts = timeseries(sample,timestamp);
ts.TimeInfo.Format = 'HH:MM:SS';
ts.TimeInfo.StartDate = '31-Dec-1969 18:00:00';
ts.TimeInfo.Units = 'milliseconds';
%ts.Time=ts.Time-ts.Time(1);
plot(ts,linetype,'Linewidth',linewidth);
end

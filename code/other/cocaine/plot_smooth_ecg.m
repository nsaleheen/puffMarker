function plot_smooth_ecg(G,pid,sid,INDIR)
%% Load Data (Formatted Raw, Formatted Data)
fprintf('%-6s %-6s %-20s Task (',pid,sid,'main_basicfeature');
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' G.FILE.FRMTDATA_MATNAME];

if isempty([indir G.DIR.SEP infile]),    disp(['FILE NOT FOUND' indir G.DIR.SEP infile]);return;end
load([indir G.DIR.SEP infile]);
sample=D.sensor{G.SENSOR.R_ECGID}.sample;
matlabtime=D.sensor{G.SENSOR.R_ECGID}.matlabtime;
timestr=datestr(matlabtime,'yyyy-mm-dd HH:MM:SS.FFF');

end


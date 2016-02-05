function detect_cocaine_deepak(G,pid,sid,INDIR,OUTDIR)
%% Load Data (Formatted Raw, Formatted Data)
fprintf('%-6s %-6s %-20s Task (',pid,sid,'main_deepak');
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' G.FILE.FRMTDATA_MATNAME];
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
if isempty(dir(outdir))
    mkdir(outdir);
end
%{
file1=[outdir G.DIR.SEP pid '_' sid '_infile.csv'];

if isempty([indir G.DIR.SEP infile]),    disp(['FILE NOT FOUND' indir G.DIR.SEP infile]);return;end
load([indir G.DIR.SEP infile]);
sample=D.sensor{G.SENSOR.R_ECGID}.sample;
matlabtime=D.sensor{G.SENSOR.R_ECGID}.matlabtime;
fid=fopen(file1,'w');
%str=datestr(matlabtime, 'yyyy-mm-dd HH:MM:SS.FFF');
for i=1:length(sample)
    str1=[datestr(matlabtime(i),'yyyy-mm-dd HH:MM:SS.FFF') ',' num2str(sample(i))];
    fprintf(fid,'%s\n',str1);
end
fclose(fid);
%}
cd functions/java/ECGProc/bin/;

system(['java edu.umass.cs.sensors.test.ECGProcess ' outdir ' ' pid ' ' sid]);

cd ../../../..;

%[t,~,v2,~]=textread([outdir G.DIR.SEP pid '_' sid '_interpolate.csv'],'%f %f %f %s','delimiter',',');
%A.interpolate.timestamp=t';
%A.interpolate.matlabtime=convert_timestamp_matlabtimestamp(G,A.interpolate.timestamp);
%A.interpolate.sample=v2';

[t,~,v2,~]=textread([outdir G.DIR.SEP pid '_' sid '_smooth.csv'],'%f %f %f %s','delimiter',',');
%A.smooth.timestamp=t';
A.smooth.matlabtime=convert_timestamp_matlabtimestamp(G,t);

A.smooth.sample=v2';

[t,~,v2,s]=textread([outdir G.DIR.SEP pid '_' sid '_peak.csv'],'%f %f %f %s','delimiter',',');
ind=find(strcmp(s,'null')~=1);
A.peak.timestamp=t(ind)';
A.peak.matlabtime=convert_timestamp_matlabtimestamp(G,A.peak.timestamp);
A.peak.sample=v2(ind)';
A.peak.type=cell2mat(s(ind));

x=csvread([outdir G.DIR.SEP pid '_' sid '_feature.csv'],1,0);
A.feature.timestamp=x(:,1);
A.feature.matlabtime=convert_timestamp_matlabtimestamp(G,A.feature.timestamp);
A.feature.sample=x(:,2:101);
A.feature.rr=x(:,102);
A.feature.qt=x(:,103);
A.feature.qtc=x(:,104);
A.feature.pr=x(:,105);
A.feature.qrs=x(:,106);
A.feature.th=x(:,107);
save([outdir G.DIR.SEP pid '_' sid '.mat']);

end


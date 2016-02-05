function main_avgrr(G,pid, sid,INDIR,OUTDIR,MODEL)
%% Load Basic Feature Data
fprintf('%-6s %-6s %-20s Task (',pid,sid,'main_avgrr');
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' G.FILE.BASICFEATURE_MATNAME];
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
outfile=[MODEL.STUDYTYPE '_' pid '_' sid '_' MODEL.NAME '_' G.FILE.WINDOW_MATNAME];

load ([indir G.DIR.SEP infile]);

A.NAME=['AVGRR[' G.STUDYNAME ' ' pid ' ' sid ']'];

ind=find(B.sensor{G.SENSOR.R_ECGID}.rr.quality==G.QUALITY.GOOD);
sample=B.sensor{G.SENSOR.R_ECGID}.rr.sample(ind);
timestamp=B.sensor{G.SENSOR.R_ECGID}.rr.timestamp(ind);
lowest=min(sample);
highest=prctile(sample,90);
Q=10.0;
val=double(int32(Q*(sample-lowest)/(highest-lowest)))/Q;
if isempty(dir(outdir))
    mkdir(outdir);
end

save([outdir G.DIR.SEP outfile],'W');

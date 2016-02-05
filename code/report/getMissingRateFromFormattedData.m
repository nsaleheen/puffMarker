function missingRate=getMissingRateFromFormattedData(G,pid,sid) 

indir=[G.DIR.DATA];
infile=[pid '_' sid '_' G.FILE.FRMTDATA_MATNAME];
load([indir G.DIR.SEP 'formatteddata' G.DIR.SEP infile]);
fid=fopen('C:\Users\mmrahman\Desktop\NIDA\nida_RIP_MissingRate_sessionAdjusted.csv','a');
missingRate=-1;

timestamps=D.sensor{G.SENSOR.R_RIPID}.timestamp_all;
if ~isempty(timestamps)
    d=diff(timestamps)/1000/60;
    pos=[1 find(d>10) length(timestamps)];
    times=D.sensor{G.SENSOR.R_RIPID}.timestamp_all(pos);
    d=diff(times)/1000;
    samplingRate=64/3;
    totalExpectedSamples=sum(d)*samplingRate;
    totalMissingSamples=totalExpectedSamples-length(D.sensor{G.SENSOR.R_RIPID}.sample_all);
    missingRate=totalMissingSamples/totalExpectedSamples;
    fprintf(fid,'%s\n',num2str(missingRate*100));
    fclose(fid);
end
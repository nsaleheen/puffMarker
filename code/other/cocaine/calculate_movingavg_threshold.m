function calculate_movingavg_threshold(G,pid,sid,OUTDIR,MODEL)
disp(['pid=' pid ' sid=' sid ' Task=segmentation']);
indir=[G.DIR.DATA G.DIR.SEP 'basicfeature'];infile=[pid '_' sid '_' G.FILE.BASICFEATURE_MATNAME];
load([indir G.DIR.SEP infile]);

ind=find(B.sensor{G.SENSOR.R_ECGID}.rr.quality==G.QUALITY.GOOD);
sample=B.sensor{G.SENSOR.R_ECGID}.rr.sample(ind)*1000;
matlabtime=B.sensor{G.SENSOR.R_ECGID}.rr.matlabtime(ind);
timestamp=B.sensor{G.SENSOR.R_ECGID}.rr.timestamp(ind);

P.METADATA=B.METADATA;
P.starttimestamp=B.starttimestamp;P.endtimestamp=B.endtimestamp;
P.start_matlabtime=B.start_matlabtime;P.end_matlabtime=B.end_matlabtime;

ind=find(sample<1500);
sample=sample(ind);
matlabtime=matlabtime(ind);
timestamp=timestamp(ind);

%if isempty(sample), return;end;
P.rr.sample=sample;
P.rr.matlabtime=matlabtime;
P.rr.timestamp=timestamp;
if isempty(timestamp), start_timestamp=0;end_timestamp=0;
else
start_timestamp=ceil(timestamp(1)/1000);start_timestamp=start_timestamp*1000;
end_timestamp=floor(timestamp(end)/1000);end_timestamp=end_timestamp*1000;
end
% Average
%[P.rr.avg.t1,P.rr.avg.timestamp]=compute_moving_avg(sample,timestamp,1,start_timestamp,end_timestamp);
%[P.rr.avg.t10,P.rr.avg.timestamp]=compute_moving_avg(sample,timestamp,10,start_timestamp,end_timestamp);
%[P.rr.avg.t30,P.rr.avg.timestamp]=compute_moving_avg(sample,timestamp,30,start_timestamp,end_timestamp);
[P.rr.avg.t60,P.rr.avg.timestamp]=compute_moving_avg(sample,timestamp,60,start_timestamp,end_timestamp);
[P.rr.avg.t120,P.rr.avg.timestamp]=compute_moving_avg(sample,timestamp,120,start_timestamp,end_timestamp);
[P.rr.avg.t300,P.rr.avg.timestamp]=compute_moving_avg(sample,timestamp,300,start_timestamp,end_timestamp);
[P.rr.avg.t600,P.rr.avg.timestamp]=compute_moving_avg(sample,timestamp,600,start_timestamp,end_timestamp);
P.rr.avg.matlabtime=convert_timestamp_matlabtimestamp(G,P.rr.avg.timestamp);

%Accelerometer
[value,timestamp,matlabtime,quality]=get_activity_featurevalue(G,pid,sid,MODEL);
ind=find(timestamp>=start_timestamp & timestamp<=end_timestamp);
value=value(ind);timestamp=timestamp(ind);matlabtime=matlabtime(ind);quality=quality(ind);
P.acl.timestamp=timestamp;P.acl.value=value;P.acl.matlabtime=matlabtime;
%if length(P.acl.value)==0, return;end;
%{
if length(P.acl.timestamp)<length(P.rr.avg.timestamp)
    d=length(P.rr.avg.timestamp)-length(P.acl.timestamp);
    P.acl.timestamp=[P.rr.avg.timestamp(1:d) P.acl.timestamp];
    P.acl.value=[P.acl.value(1)*ones(1,d) P.acl.value];
end
P.acl.matlabtime=convert_timestamp_matlabtimestamp(G,P.acl.timestamp);
%}
[P.acl.avg.t1,P.acl.avg.timestamp]=compute_moving_avg(P.acl.value,P.acl.timestamp,1,start_timestamp,end_timestamp);
[P.acl.avg.t10,P.acl.avg.timestamp]=compute_moving_avg(P.acl.value,P.acl.timestamp,10,start_timestamp,end_timestamp);
[P.acl.avg.t30,P.acl.avg.timestamp]=compute_moving_avg(P.acl.value,P.acl.timestamp,30,start_timestamp,end_timestamp);
[P.acl.avg.t60,P.acl.avg.timestamp]=compute_moving_avg(P.acl.value,P.acl.timestamp,60,start_timestamp,end_timestamp);
[P.acl.avg.t120,P.acl.avg.timestamp]=compute_moving_avg(P.acl.value,P.acl.timestamp,120,start_timestamp,end_timestamp);
[P.acl.avg.t300,P.acl.avg.timestamp]=compute_moving_avg(P.acl.value,P.acl.timestamp,300,start_timestamp,end_timestamp);
[P.acl.avg.t600,P.acl.avg.timestamp]=compute_moving_avg(P.acl.value,P.acl.timestamp,600,start_timestamp,end_timestamp);
P.acl.avg.matlabtime=convert_timestamp_matlabtimestamp(G,P.acl.avg.timestamp);
P.acl.avg.th1=(prctile(P.acl.avg.t1,95)-prctile(P.acl.avg.t1,5))*0.35;
P.acl.avg.th10=(prctile(P.acl.avg.t10,95)-prctile(P.acl.avg.t10,5))*0.35;
P.acl.avg.th30=(prctile(P.acl.avg.t30,95)-prctile(P.acl.avg.t30,5))*0.35;
P.acl.avg.th60=(prctile(P.acl.avg.t60,95)-prctile(P.acl.avg.t60,5))*0.35;
P.acl.avg.th120=(prctile(P.acl.avg.t120,95)-prctile(P.acl.avg.t120,5))*0.35;
P.acl.avg.th300=(prctile(P.acl.avg.t300,95)-prctile(P.acl.avg.t300,5))*0.35;
P.acl.avg.th600=(prctile(P.acl.avg.t600,95)-prctile(P.acl.avg.t600,5))*0.35;



%fprintf('  acltime-rravgtime=%f',max(abs(diff(P.acl.matlabtime-P.rr.avg.matlabtime)))*24*60*60);
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
outfile=[pid '_' sid '_segment.mat'];
if isempty(dir(outdir))
    mkdir(outdir);
end
save([outdir G.DIR.SEP outfile],'P');
fprintf(') =>  done\n');
end

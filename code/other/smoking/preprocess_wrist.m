function preprocess_wrist(G, pid,sid, INDIR, OUTDIR,YTHRESHOLD)

indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' G.FILE.BASICFEATURE_MATNAME];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);
P=B;
P=rmfield(P,'sensor');
for i=[G.SENSOR.R_RIPID,G.SENSOR.WL9_ACLXID,G.SENSOR.WL9_ACLYID,G.SENSOR.WL9_ACLZID,G.SENSOR.WR9_ACLXID,G.SENSOR.WR9_ACLYID,G.SENSOR.WR9_ACLZID, G.SENSOR.WL9_GYRXID, G.SENSOR.WL9_GYRYID, G.SENSOR.WL9_GYRZID, G.SENSOR.WR9_GYRXID, G.SENSOR.WR9_GYRYID, G.SENSOR.WR9_GYRZID]
    P.sensor{i}=B.sensor{i};    
end
P=correct_orientation(G,P);
for s=[G.SENSOR.WL9_ACLXID,G.SENSOR.WL9_ACLYID,G.SENSOR.WL9_ACLZID,G.SENSOR.WR9_ACLXID,G.SENSOR.WR9_ACLYID,G.SENSOR.WR9_ACLZID]
    [b,a]=butter(2,0.1);P.sensor{s}.sample_filtered=filter(b,a,P.sensor{s}.sample);
    P.sensor{s}.s_variance_1=find_variance(P.sensor{s}.sample,1000);
    P.sensor{s}.sf_variance_1=find_variance(P.sensor{s}.sample_filtered,1000);
    P.sensor{s}.s_variance_2=find_variance(P.sensor{s}.sample,2000);
    P.sensor{s}.sf_variance_2=find_variance(P.sensor{s}.sample_filtered,2000);
end
P.magniture_L_1=calculate_magnitude(G,P,G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_ACLZID,1000);
P.magniture_L_2=calculate_magnitude(G,P,G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_ACLZID,2000);
P.magniture_L_5=calculate_magnitude(G,P,G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_ACLZID,5000);
P.magniture_R_1=calculate_magnitude(G,P,G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_ACLZID,1000);
P.magniture_R_2=calculate_magnitude(G,P,G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_ACLZID,2000);
P.magniture_R_5=calculate_magnitude(G,P,G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_ACLZID,5000);

P.sensor{G.SENSOR.WL9_ACLY}.segment=acl_segmentation(P.sensor{G.SENSOR.WL9_ACLY}.sample_filtered,YTHRESHOLD);
P.sensor{G.SENSOR.WR9_ACLY}.segment=acl_segmentation(P.sensor{G.SENSOR.WR9_ACLY}.sample_filtered,YTHRESHOLD);
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
outfile=[pid '_' sid '_preprocess.mat'];

if isempty(dir(outdir))
    mkdir(outdir);
end
save([outdir G.DIR.SEP outfile],'P');

end
%     if s==G.SENSOR.WL9_ACLXID || s==G.SENSOR.WR9_ACLXID
%         [res,time]=measure_position(P.sensor{s}.sample_filtered,P.sensor{s}.timestamp,5*60*1000,1000,800);
%     elseif s==G.SENSOR.WL9_ACLZID || s==G.SENSOR.WR9_ACLZID
%         [res,time]=measure_position(P.sensor{s}.sample_filtered,P.sensor{s}.timestamp,5*60*1000,1000,300);
%     else
%         [res,time]=measure_position(P.sensor{s}.sample_filtered,P.sensor{s}.timestamp,5*60*1000,1000,700);
%     end
%     P.sensor{s}.s_avg=res;
%     P.sensor{s}.t_avg=time;
%     P.sensor{s}.mt_avg=convert_timestamp_matlabtimestamp(G,time);
    %    res=exponential_movingavg(B.sensor{s}.sample,20);
    %  data=B.sensor{s}.sample;
    
    %    for curtime=B.sensor{s}.timestamp(1):1*1000:B.sensor{s}.timestamp(end)
    %        ind=find(B.sensor{s}.timestamp>=curtime-10*60*1000);

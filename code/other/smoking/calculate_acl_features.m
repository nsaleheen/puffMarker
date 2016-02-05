function calculate_acl_features(G, pid,sid, INDIR, OUTDIR)

indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' INDIR '.mat'];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);
%[P.wl.magnitude.sample,P.wl.magnitude.timestamp]=calculate_magnitude(P,[G.SENSOR.WL9_ACLXID,G.SENSOR.WL9_ACLYID,G.SENSOR.WL9_ACLZID]);
%[P.wr.magnitude.sample,P.wr.magnitude.timestamp]=calculate_magnitude(P,[G.SENSOR.WR9_ACLXID,G.SENSOR.WR9_ACLYID,G.SENSOR.WR9_ACLZID]);
%P.wl.magnitude.matlabtime=convert_timestamp_matlabtimestamp(G,P.wl.magnitude.timestamp);
%P.wr.magnitude.matlabtime=convert_timestamp_matlabtimestamp(G,P.wr.magnitude.timestamp);

[P.wlg.magnitude.sample,P.wlg.magnitude.timestamp]=calculate_magnitude(P,[G.SENSOR.WL9_GYRXID,G.SENSOR.WL9_GYRYID,G.SENSOR.WL9_GYRZID]);
[P.wrg.magnitude.sample,P.wrg.magnitude.timestamp]=calculate_magnitude(P,[G.SENSOR.WR9_GYRXID,G.SENSOR.WR9_GYRYID,G.SENSOR.WR9_GYRZID]);
%[b,a]=butter(2,0.5);P.wlg.magnitude.sample_filtered=filter(b,a,P.wlg.magnitude.sample);
%[b,a]=butter(2,0.5);P.wrg.magnitude.sample_filtered=filter(b,a,P.wrg.magnitude.sample);

P.wlg.magnitude.matlabtime=convert_timestamp_matlabtimestamp(G,P.wlg.magnitude.timestamp);
P.wrg.magnitude.matlabtime=convert_timestamp_matlabtimestamp(G,P.wrg.magnitude.timestamp);
P.wlg.magnitude.segment=gsr_segmentation(P.wlg.magnitude.sample,300,4);
P.wrg.magnitude.segment=gsr_segmentation(P.wrg.magnitude.sample,300,4);

outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
outfile=[pid '_' sid '_' OUTDIR '.mat'];

if isempty(dir(outdir))
    mkdir(outdir);
end
save([outdir G.DIR.SEP outfile],'P');

end

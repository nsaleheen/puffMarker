function smooth_signal(G, pid,sid, INDIR, OUTDIR)
fprintf('...smooth_signal');
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' INDIR '.mat'];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);
for s=[G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_GYRZID,G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_GYRZID]
    P.sensor{s}.sample_filtered=smooth(P.sensor{s}.sample,8);
%    [b,a]=butter(2,0.1);P.sensor{s}.sample_filtered=filter(b,a,P.sensor{s}.sample);
end
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
outfile=[pid '_' sid '_' OUTDIR '.mat'];

if isempty(dir(outdir))
    mkdir(outdir);
end
save([outdir G.DIR.SEP outfile],'P');


end

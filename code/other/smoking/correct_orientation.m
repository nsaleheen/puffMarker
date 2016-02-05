function correct_orientation(G, pid,sid, INDIR, OUTDIR)
fprintf('...correct_orientation');
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' INDIR '.mat'];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);
P.sensor{G.SENSOR.WL9_ACLYID}.sample=-P.sensor{G.SENSOR.WL9_ACLYID}.sample;

outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
outfile=[pid '_' sid '_' OUTDIR '.mat'];

if isempty(dir(outdir))
    mkdir(outdir);
end
save([outdir G.DIR.SEP outfile],'P');


end
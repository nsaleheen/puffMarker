function filter_segment_all_gyr(G, pid,sid, INDIR, OUTDIR,MISSING,MINLEN,MAXLEN,TH)

indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' INDIR '.mat'];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);

for i=1:2
    P.wrist{i}.gyr.segment.valid_all=zeros(1,length(P.wrist{i}.gyr.segment.starttimestamp));
    ind=find(P.wrist{i}.gyr.segment.missing>MISSING);P.wrist{i}.gyr.segment.valid_all(ind)=1;
    ind=find(P.wrist{i}.gyr.segment.length_gyr<=MINLEN);P.wrist{i}.gyr.segment.valid_all(ind)=2;
    ind=find(P.wrist{i}.gyr.segment.length_gyr>MAXLEN);P.wrist{i}.gyr.segment.valid_all(ind)=3;
    ind=find(P.wrist{i}.gyr.segment.error_rp>TH(i));P.wrist{i}.gyr.segment.valid_all(ind)=4;
end
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
outfile=[pid '_' sid '_' OUTDIR '.mat'];

if isempty(dir(outdir))
    mkdir(outdir);
end
save([outdir G.DIR.SEP outfile],'P');

end

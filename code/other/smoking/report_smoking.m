function report_smoking(G,pid,sid,INDIR)
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' G.FILE.FRMTDATA_MATNAME];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);
fprintf('pid=%s,sid=%s,',pid,sid);
fprintf('selfreport=%d,',length(D.selfreport{2}.matlabtime));
fprintf('episode=%d,',length(D.cress.episode));
for i=1:length(D.cress.episode)
    fprintf('e%d=%d,',i,length(D.cress.episode{i}.puff));
end
fprintf('\n');
end
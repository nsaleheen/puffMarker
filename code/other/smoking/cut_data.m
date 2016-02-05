function found=cut_data(G,pid,sid,n)
found=1;
indir=[G.DIR.DATA G.DIR.SEP 'formatteddata'];
infile=[pid '_' sid '_' G.FILE.FRMTDATA_MATNAME];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);
if length(D.selfreport{2}.timestamp)<n, found=0;return;end;
marktimestamp=D.selfreport{2}.timestamp(n);
starttimestamp=marktimestamp-15*60*1000;
endtimestamp=marktimestamp+5*60*1000;

sensorlist=[1,26:31,33:38];
i=0;
for s=sensorlist
    i=i+1;
    ind=find(D.sensor{s}.timestamp>=starttimestamp & D.sensor{s}.timestamp<=endtimestamp);
    S.sensor{i}.sample=D.sensor{s}.sample(ind);
    S.sensor{i}.timestamp=D.sensor{s}.timestamp(ind);
    S.sensor{i}.NAME=D.sensor{s}.NAME;
end
S.report_smoking_timestamp=marktimestamp;

outdir=[G.DIR.DATA G.DIR.SEP 'smoking_episode'];
outfile=[pid '_' sid '_e' num2str(n) '_episode.mat'];

if isempty(dir(outdir))
    mkdir(outdir);
end
save([outdir G.DIR.SEP outfile],'S');
fprintf(') =>  done\n');

end
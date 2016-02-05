function mark_cocaine_recovery(G,pid,sid)
disp(['pid= ' pid 'sid=' sid ' Task=mark cocaine segment']);
indir=[G.DIR.DATA G.DIR.SEP 'segment'];infile=[pid '_' sid '_segment.mat'];
if exist([indir G.DIR.SEP infile], 'file') ~= 2
    return;
end
load([indir G.DIR.SEP infile]);
if ~isfield(P.rr,'window'), return;end;
ind=find(P.rr.window.mark>0);
if isempty(ind),return ;end;
for i=ind
    t1=P.rr.avg.timestamp(P.rr.window.p1(i));
    t2=P.rr.avg.timestamp(P.rr.window.v2(i));
    ind_t=find(P.rr.avg.timestamp>=t1 & P.rr.avg.timestamp<=t2);
    [v,t3]=min(P.rr.avg.t30(ind_t));
    P.rr.window.r1(i)=ind_t(t3);
   P.rr.window.r2(i)=P.rr.window.p2(i);

end

outdir=[G.DIR.DATA G.DIR.SEP 'segment'];
outfile=[pid '_' sid '_segment.mat'];
if isempty(dir(outdir))
    mkdir(outdir);
end
save([outdir G.DIR.SEP outfile],'P');
fprintf(') =>  done\n');

end

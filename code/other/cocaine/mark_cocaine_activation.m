function mark_cocaine_activation(G,pid,sid)
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
    sind=P.rr.window.p1(i);
    eind=min(P.rr.window.v1(i),P.rr.window.v2(i));
    t1=P.rr.avg.timestamp(sind);
    t2=P.rr.avg.timestamp(eind);
    ind_t=find(P.rr.avg.timestamp>=t1 & P.rr.avg.timestamp<=t2);
    [v,t3]=max(P.rr.avg.t30(ind_t));
    sind=ind_t(t3);

    [v,t3]=min(P.rr.avg.t30(ind_t));
    eind=ind_t(t3);

    P.rr.window.a1(i)=sind;
    P.rr.window.a2(i)=eind;

end

outdir=[G.DIR.DATA G.DIR.SEP 'segment'];
outfile=[pid '_' sid '_segment.mat'];
if isempty(dir(outdir))
    mkdir(outdir);
end
save([outdir G.DIR.SEP outfile],'P');
fprintf(') =>  done\n');

end

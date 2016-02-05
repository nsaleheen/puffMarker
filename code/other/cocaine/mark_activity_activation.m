function mark_activity_activation(G,pid,sid)
disp(['pid= ' pid 'sid=' sid ' Task=mark cocaine segment']);
indir=[G.DIR.DATA G.DIR.SEP 'segment'];infile=[pid '_' sid '_segment.mat'];
if exist([indir G.DIR.SEP infile], 'file') ~= 2
    return;
end
load([indir G.DIR.SEP infile]);
if ~isfield(P.rr,'window'), return;end;
for i=1:length(P.rr.window.mark)
    if P.rr.window.mark(i)~=0, continue;end;
    sind=P.rr.window.p1(i);
    eind=min(P.rr.window.v1(i),P.rr.window.v2(i));
    t1=P.rr.avg.timestamp(sind);
    t2=P.rr.avg.timestamp(eind);
    ind_t=find(P.rr.avg.timestamp>=t1 & P.rr.avg.timestamp<=t2);
    [v,t3]=min(P.rr.avg.t30(ind_t));
    eind=ind_t(t3);
    ii=find(P.acl.avg.t120(sind:eind)>P.acl.avg.th120);
    if isempty(ii), sind=-1;%P.rr.window.p1(i);
    else
        sind=ii(1)+sind;
    end
%    ii=find(P.acl.avg.t120(sind:eind)>P.acl.avg.th120);
%    if ~isempty(ii), sind=ii(end)+sind;end
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

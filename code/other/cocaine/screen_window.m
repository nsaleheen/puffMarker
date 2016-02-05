function screen_window(G,pid,sid)
disp(['pid= ' pid 'sid=' sid ' Task=mark window']);
indir=[G.DIR.DATA G.DIR.SEP 'preprocess'];infile=[pid '_' sid '_preprocess.mat'];
if exist([indir G.DIR.SEP infile], 'file') ~= 2
    return;
end

load([indir G.DIR.SEP infile]);
indir=[G.DIR.DATA G.DIR.SEP 'formattedraw'];infile=[pid '_' sid '_frmtraw.mat'];
load([indir G.DIR.SEP infile]);
if isfield(R,'adminmark'), 
    P.adminmark=R.adminmark;
else
    P.adminmark=[];
end
if isfield(R,'pdamark')
    P.pdamark=R.pdamark;
else, P.pdamark=[];end;
P.rr.window.mark=zeros(1,length(P.rr.window.p1));
%threshold=(max(P.acl.avg60.value)-min(P.acl.avg60.value))/2;
threshold=(prctile(P.acl.avg60.value,95)-prctile(P.acl.avg60.value,5))*0.35;

for i=1:length(P.rr.window.p1)
    P.rr.window.mark(i)=-1;
    if P.rr.window.v1(i)==-1 || P.rr.window.v2(i)==-1,P.rr.window.mark(i)=-1;continue;end;
    stime=P.rr.avg.matlabtime(P.rr.window.p1(i));
    etime=P.rr.avg.matlabtime(P.rr.window.p2(i));
    ind_rr=find(P.rr.matlabtime>=stime & P.rr.matlabtime<=etime);
    
    expected=((etime-stime)*24*60)*50;
    duration=((etime-stime)*24*60*60);
    estimated=length(ind_rr);
    if estimated<=expected*0.8, P.rr.window.mark(i)=-2;continue;end  % missing
    ind_avg_t=find(P.rr.avg.matlabtime>=stime & P.rr.avg.matlabtime<=etime);
%    avg_sample=P.rr.avg.t600(ind_avg_t);
    org_h=prctile(P.rr.avg.t600,95)-prctile(P.rr.avg.t600,5);
    now_h=max(P.rr.avg.t600(ind_avg_t))-min(P.rr.avg.t600(ind_avg_t));

    if org_h/3>now_h, P.rr.window.mark(i)=-4;continue;end;   % depth at least 1/3
    if duration <900, P.rr.window.mark(i)=-3;continue;end;   % duration < 15 minutes -> ignore
    
    ind_acl=find(P.acl.avg60.matlabtime>=stime & P.acl.avg60.matlabtime<=stime+300/(24*60*60));
    ind_acl1=find(P.acl.avg60.value(ind_acl)>=threshold);
    if length(ind_acl1)>=length(ind_acl)/2, P.rr.window.mark(i)=-5;continue;end;
%    if val>threshold, P.rr.window.mark(i)=-5;end;   % Because of activity
    P.rr.window.mark(i)=0;
    
end
outdir=[G.DIR.DATA G.DIR.SEP 'preprocess'];
outfile=[pid '_' sid '_preprocess.mat'];
if isempty(dir(outdir))
    mkdir(outdir);
end
save([outdir G.DIR.SEP outfile],'P');
fprintf(') =>  done\n');

end

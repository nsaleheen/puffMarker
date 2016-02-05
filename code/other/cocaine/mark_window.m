function mark_window(G,pid,sid)
disp(['pid= ' pid 'sid=' sid ' Task=mark window']);
indir=[G.DIR.DATA G.DIR.SEP 'segment'];infile=[pid '_' sid '_segment.mat'];
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
else P.pdamark=[];
end;
P.rr.window.mark=zeros(1,length(P.rr.window.p1));
for i=1:length(P.rr.window.p1)
    if P.rr.window.v1(i)==-1 || P.rr.window.v2(i)==-1,P.rr.window.mark(i)=-1;continue;end;
    stime=P.rr.avg.matlabtime(P.rr.window.p1(i));
    etime=P.rr.avg.matlabtime(P.rr.window.p2(i));
    rr_matlabtime=P.rr.matlabtime(find(P.rr.matlabtime>=stime & P.rr.matlabtime<=etime));
%% Missing
    good=0;bad=0;
    for now=stime:60/(24*60*60):etime
        len=length(find(rr_matlabtime>=now & rr_matlabtime<now+60/(24*60*60)));
        if len<40, bad=bad+1; else good=good+1;end;
    end
    if bad/(bad+good)>0.3, P.rr.window.mark(i)=-2;continue;end;
    %% Missing    
%    expected=((etime-stime)*24*60)*50;
%    estimated=length(ind_rr);
%    if estimated<=expected*0.7,        P.rr.window.mark(i)=-2;        continue;    end
    
    %% Width
    duration=((etime-stime)*24*60*60);    
    if duration <1147,         P.rr.window.mark(i)=-3;        continue;     end;

    %% Height
    org_h=prctile(P.rr.avg.t600,98)-prctile(P.rr.avg.t600,2);
    ind_avg_t=find(P.rr.avg.matlabtime>=stime & P.rr.avg.matlabtime<=etime);
    now_h=max(P.rr.avg.t600(ind_avg_t))-min(P.rr.avg.t600(ind_avg_t));
    if org_h/3>now_h, P.rr.window.mark(i)=-4;continue;end;   % depth at least 1/3
    
    %% activity threshold
    threshold=(prctile(P.acl.avg60.value,98)-prctile(P.acl.avg60.value,1))*0.50;
    ind_acl=find(P.acl.avg60.matlabtime>=P.rr.avg.matlabtime(P.rr.window.p1(i)) & P.acl.avg60.matlabtime<=P.rr.avg.matlabtime(P.rr.window.v1(i)));
    ind_acl=find(P.acl.avg60.matlabtime>=P.rr.avg.matlabtime(P.rr.window.p1(i)) & P.acl.avg60.matlabtime<=P.rr.avg.matlabtime(P.rr.window.p1(i))+(7*60)/(25*60*60));

    ind_acl1=find(P.acl.avg60.value(ind_acl)>=threshold);
    if length(ind_acl1)>=length(ind_acl)*.5, P.rr.window.mark(i)=-5;continue;end;
    
    
end
if isfield(R,'adminmark') & isfield(R.adminmark,'matlabtime'),
    for j=1:length(R.adminmark.matlabtime)
        minv=inf;who=0;
        for i=1:length(P.rr.window.p1)
            if abs(R.adminmark.matlabtime(j)-P.rr.avg.matlabtime(P.rr.window.p1(i)))<minv,minv=abs(R.adminmark.matlabtime(j)-P.rr.avg.matlabtime(P.rr.window.p1(i)));who=i;end;
        end
        if P.rr.window.mark(who)~=-1 & P.rr.window.mark(who)~=-2,
        P.rr.window.mark(who)=R.adminmark.dose(j);
        end
    end
end

outdir=[G.DIR.DATA G.DIR.SEP 'segment'];
outfile=[pid '_' sid '_segment.mat'];
if isempty(dir(outdir))
    mkdir(outdir);
end
save([outdir G.DIR.SEP outfile],'P');
fprintf(') =>  done\n');

end

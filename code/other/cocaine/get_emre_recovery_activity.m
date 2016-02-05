function [E,rr]=get_emre_recovery_activity(G,pid,sid,c_n)
disp(['pid= ' pid 'sid=' sid ' Task=get cocaine segment']);
E=[];rr=[];
indir=[G.DIR.DATA G.DIR.SEP 'segment'];infile=[pid '_' sid '_segment.mat'];
if exist([indir G.DIR.SEP infile], 'file') ~= 2
    return;
end
load([indir G.DIR.SEP infile]);
if ~isfield(P.rr,'window'), return;end;
now=0;
rr=P.rr.sample;
for i=1:length(P.rr.window.p1)
    mark=P.rr.window.mark(i);if mark~=0, continue;end;
    if check_valid_noncocaine(P)==0, continue;end;
    x=find(P.acl.avg.t120(P.rr.window.r1(i):P.rr.window.r2(i))>P.acl.avg.th120);
    if ~isempty(x),     a1=x(end)+P.rr.window.r1(i);a2=P.rr.window.r2(i);
    else, a1=P.rr.window.r1(i);a2=P.rr.window.r2(i);end;
    aa=find(P.acl.avg.t120(max(1,a1-60):a1)>P.acl.avg.th120);
    if length(aa)<40, continue;end;
    [x,y]=min(P.rr.avg.t60(max(1,a1-60):a1));
    a1=y+max(1,a1-60);
    a2=P.rr.window.r2(i);
%    if a2-a1<15, continue;end;
    sind=a1;%P.rr.window.r1(i);
    eind=a2;%P.rr.window.r2(i);
    stime=P.rr.avg.timestamp(sind);
    etime=P.rr.avg.timestamp(eind);
    ind=find(P.rr.avg.timestamp>=stime & P.rr.avg.timestamp<=etime);
    if isempty(ind), continue;end;
    ind=find(P.rr.timestamp>=stime & P.rr.timestamp<=etime);
    if isempty(ind), continue;end;

    now=now+1;
    E{now}.rr.timestamp=P.rr.timestamp(ind);
    E{now}.rr.sample=P.rr.sample(ind);
    
    ind=find(P.rr.avg.timestamp>=stime & P.rr.avg.timestamp<=etime);
    E{now}.rr.avg.timestamp=P.rr.avg.timestamp(ind);
    E{now}.rr.avg.t10=P.rr.avg.t10(ind);
    E{now}.rr.avg.t30=P.rr.avg.t30(ind);
    E{now}.rr.avg.t60=P.rr.avg.t60(ind);
    E{now}.rr.avg.t120=P.rr.avg.t120(ind);
    E{now}.rr.avg.t300=P.rr.avg.t300(ind);
    E{now}.rr.avg.t600=P.rr.avg.t600(ind);
    E{now}.window_time(1)=P.rr.avg.timestamp(P.rr.window.p1(i));
    E{now}.window_time(2)=P.rr.avg.timestamp(P.rr.window.v1(i));
    E{now}.window_time(3)=P.rr.avg.timestamp(a1);
    E{now}.window_time(4)=P.rr.avg.timestamp(a2);
    E{now}.window.mark=P.rr.window.mark(i);
    
    ind=find(P.acl.timestamp>=stime & P.acl.timestamp<=etime);
    E{now}.acl.timestamp=P.acl.timestamp(ind);
    E{now}.acl.value=P.acl.value(ind);
    
    
    
    
end
fprintf(') =>  done\n');

end
function valid=check_valid_cocaine(P,stime,etime)
valid=0;
if isfield(P,'adminmark')==0,return;end;
if isfield(P.adminmark,'timestamp')==0, return;end;
if length(P.adminmark.timestamp)==0, return;end;
[m,i]=min(abs(P.adminmark.timestamp-stime));
if P.adminmark.dose(i)==20 || P.adminmark.dose(i)==40 || P.adminmark.dose(i)==10
    for j=1:i-1
        if P.adminmark.dose(i)==P.adminmark.dose(j), return; end;
    end
    
    valid=1;
    return;
end
end
function valid=check_valid_noncocaine(P)
valid=0;
if isfield(P,'adminmark')==1 && isfield(P.adminmark,'timestamp')==1 && ~isempty(P.adminmark.timestamp),return;end;
%ind=find(P.acl.avg.timestamp>=stime-1*60*1000 & P.acl.avg.timestamp<stime);
%value=P.acl.avg.t10(ind);
%if prctile(value,50)>P.acl.avg.th10, valid=1;return;end;
valid=1;
end

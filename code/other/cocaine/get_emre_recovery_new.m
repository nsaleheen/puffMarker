function [E,rr]=get_emre_recovery_new(G,pid,sid,c_n)
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
    if P.rr.window.mark(i)<0, continue;end;
    if P.rr.window.p1(i)==-1, continue;end;
    mark=P.rr.window.mark(i);if mark>0, mark=1;end
    if c_n==1 && mark==1
        sind=P.rr.window.c1(i);
        eind=P.rr.window.c2(i);
       
        r_stime=P.rr.avg.timestamp(sind);
        r_etime=P.rr.avg.timestamp(eind);
        if strcmp(G.STUDYNAME,'NIDA')~=1 && check_valid_cocaine(P,r_stime,r_etime,i)==0, continue;end;
    elseif c_n==0 && mark==0
        if P.rr.window.atr1(i)==-1, continue;end;

        sind=P.rr.window.atr1(i);
        eind=P.rr.window.atr2(i);
        
        r_stime=P.rr.avg.timestamp(sind);
        r_etime=P.rr.avg.timestamp(eind);
        if strcmp(G.STUDYNAME,'NIDA')~=1 && check_valid_noncocaine(P,r_stime,r_etime)==0, continue;end;
    else continue;
    end
    stime=P.rr.avg.timestamp(P.rr.window.p1(i));
    etime=P.rr.avg.timestamp(P.rr.window.p2(i));
    ind=find(P.rr.timestamp>=stime & P.rr.timestamp<=etime);
    
    now=now+1;
    E{now}.rr.timestamp=P.rr.timestamp(ind);
    E{now}.rr.sample=P.rr.sample(ind);
    
    ind=find(P.rr.avg.timestamp>=stime & P.rr.avg.timestamp<=etime);
    E{now}.rr.avg.timestamp=P.rr.avg.timestamp(ind);
%    E{now}.rr.avg.t10=P.rr.avg.t10(ind);
%    E{now}.rr.avg.t30=P.rr.avg.t30(ind);
    E{now}.rr.avg.t60=P.rr.avg.t60(ind);
    E{now}.rr.avg.t120=P.rr.avg.t120(ind);
    E{now}.rr.avg.t300=P.rr.avg.t300(ind);
    E{now}.rr.avg.t600=P.rr.avg.t600(ind);
    E{now}.window_time(1)=P.rr.avg.timestamp(P.rr.window.p1(i));
    E{now}.window_time(2)=P.rr.avg.timestamp(P.rr.window.v1(i));
    E{now}.window_time(3)=r_stime;%P.rr.avg.timestamp(P.rr.window.r1(i));
    E{now}.window_time(4)=r_etime;%P.rr.avg.timestamp(P.rr.window.r2(i));
    E{now}.window.mark=P.rr.window.mark(i);
    
    ind=find(P.acl.timestamp>=stime & P.acl.timestamp<=etime);
    E{now}.acl.timestamp=P.acl.timestamp(ind);
    E{now}.acl.value=P.acl.value(ind);
 %   E{now}.acl.avg.t10=P.acl.avg.t10(ind);
%    E{now}.acl.avg.t30=P.acl.avg.t30(ind);
    E{now}.acl.avg.t60=P.acl.avg.t60(ind);
    E{now}.acl.avg.t120=P.acl.avg.t120(ind);
%    E{now}.acl.avg.th10=P.acl.avg.th10;
%    E{now}.acl.avg.th30=P.acl.avg.th30;
    E{now}.acl.avg.th60=P.acl.avg.th60;
    E{now}.acl.avg.th120=P.acl.avg.th120;
    
    
end

end

function valid=check_valid_cocaine(P,stime,etime,i)
if P.rr.window.mark(i)>0, valid=1;return;end;
valid=0;
%if isfield(P,'adminmark')==0,return;end;
%if isfield(P.adminmark,'timestamp')==0, return;end;
%if length(P.adminmark.timestamp)==0, return;end;
%[m,i]=min(abs(P.adminmark.timestamp-stime));
%if P.adminmark.dose(i)==20 || P.adminmark.dose(i)==40 || P.adminmark.dose(i)==10
%    for j=1:i-1
%        if P.adminmark.dose(i)==P.adminmark.dose(j), return; end;
%    end
    
%    valid=1;
%    return;
%end
end
function valid=check_valid_noncocaine(P,stime,etime)
valid=1;
if isfield(P,'adminmark')==0, return;end;
if isfield(P.adminmark,'timestamp')==0, return; end;
if isempty(P.adminmark.timestamp), return;end;
for i=1:length(P.adminmark.timestamp)
    if abs(P.adminmark.timestamp(i)-stime)< 1*60*60*1000, valid=0;return;end;
    if abs(P.adminmark.timestamp(i)-etime)< 1*60*60*1000, valid=0;return;end;

end
valid=1;
end
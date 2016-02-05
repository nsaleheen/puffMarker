function [N,rr]=generate_activity_recovery(G,pid,sid)
N=[];rr=[];
disp([pid ' ' sid]);
indir=[G.DIR.DATA G.DIR.SEP 'preprocess'];infile=[pid '_' sid '_preprocess.mat'];
if exist([indir G.DIR.SEP infile], 'file') ~= 2, return;end
load([indir G.DIR.SEP infile]);

threshold=(prctile(P.acl.avg60.value,95)-prctile(P.acl.avg60.value,5))*0.35;
rr=P.rr.avg.t600;

N=[];now=0;
for i=1:length(P.rr.window.mark)
    if P.rr.window.mark(i)==-1 , continue;end;
    p1=P.rr.window.p1(i);    p2=P.rr.window.p2(i);
    v1=P.rr.window.v1(i);    v2=P.rr.window.v2(i);
    n.rr.avg.sample=P.rr.avg.t600(v2:p2);
    n.rr.avg.matlabtime=P.rr.avg.matlabtime(v2:p2);
    n.mark=P.rr.window.mark(i);
    n.rr.window(1)=p1-p1;
    n.rr.window(2)=v1-p1;
    n.rr.window(3)=v2-p1;
    n.rr.window(4)=p2-p1;
    stime=P.rr.avg.matlabtime(p1);etime=P.rr.avg.matlabtime(p2);
    ind=find(P.acl.avg60.matlabtime>=stime & P.acl.avg60.matlabtime<=etime);
    n.acl.avg.sample=P.acl.avg60.value(ind);
    n.acl.avg.matlabtime=P.acl.avg60.matlabtime(ind);
    n.acl.threshold=threshold;
    n.rr.avg.min=prctile(rr,2);
    n.rr.avg.max=prctile(rr,98);    
    now=now+1;
    N{now}=n;
end    
return;
%{
for i=1:length(P.rr.window.p1)
    mark=P.rr.window.mark(i);if mark>0, mark=1;end
    if mark==c_n
        stime=P.rr.avg.matlabtime(P.rr.window.p1(i));
        etime=P.rr.avg.matlabtime(P.rr.window.p2(i));
        if c_n==1,
            if check_valid_cocaine(P,stime,etime)==0, continue;end;
        elseif c_n==0,
            if check_valid_noncocaine(P,stime,etime)==0, continue;end;
        end
        ind=find(P.rr.matlabtime>=stime & P.rr.matlabtime<=etime);
        now=now+1;
        E{now}.rr.matlabtime=P.rr.matlabtime(ind);
        E{now}.rr.sample=P.rr.sample(ind);

        ind=find(P.rr.avg.matlabtime>=stime & P.rr.avg.matlabtime<=etime);
        E{now}.rr.avg.matlabtime=P.rr.avg.matlabtime(ind);
        E{now}.rr.avg.sample=P.rr.avg.t600(ind);
        E{now}.window_time(1)=P.rr.avg.matlabtime(P.rr.window.p1(i));
        E{now}.window_time(2)=P.rr.avg.matlabtime(P.rr.window.v1(i));
        E{now}.window_time(3)=P.rr.avg.matlabtime(P.rr.window.p2(i));
        E{now}.window_time(4)=P.rr.avg.matlabtime(P.rr.window.v2(i));
        E{now}.window.mark=P.rr.window.mark(i);

        ind=find(P.acl.matlabtime>=stime & P.acl.matlabtime<=etime);
        E{now}.acl.matlabtime=P.acl.matlabtime(ind);
        E{now}.acl.value=P.acl.value(ind);
        

    end
end
%}
end
function valid=iscocaine(R,stime,etime)
valid=0;
if isfield(R,'adminmark')==0,return;end;
if isfield(R.adminmark,'matlabtime')==0, return;end;
if length(R.adminmark.matlabtime)==0, return;end;
mintime=min(R.adminmark.matlabtime)-(1*60*60)/(24*60*60);
maxtime=max(R.adminmark.matlabtime)+(2*60*60)/(24*60*60);
if stime>=mintime & stime<=maxtime, return ; end;
if etime>=mintime & etime<=maxtime, return ; end;
valid=1;
return;
end

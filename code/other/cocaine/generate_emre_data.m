function E=generate_emre_data(G,pid,sid,c_n)
indir=[G.DIR.DATA G.DIR.SEP 'preprocess'];infile=[pid '_' sid '_preprocess.mat'];
load([indir G.DIR.SEP infile]);
res=[];
E=[];
now=0;
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
end
function valid=check_valid_cocaine(P,stime,etime)
valid=0;
if isfield(P,'adminmark')==0,return;end;
if isfield(P.adminmark,'matlabtime')==0, return;end;
if length(P.adminmark.matlabtime)==0, return;end;
[m,i]=min(abs(P.adminmark.matlabtime-stime));
if P.adminmark.dose(i)==20 || P.adminmark.dose(i)==40 || P.adminmark.dose(i)==10
    for j=1:i-1
        if P.adminmark.dose(i)==P.adminmark.dose(j), return; end;
    end
    valid=1;
    return;
end
end
function valid=check_valid_noncocaine(P,stime,etime)
valid=1;
if isfield(P,'adminmark')==0,return;end;
if isfield(P.adminmark,'matlabtime')==0, return;end;
if length(P.adminmark.matlabtime)==0, return;end;
valid=0;
end
%}
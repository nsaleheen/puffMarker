function res=curve_fit_activation_recovery(G,pid,sid,wlarge,wsmall,a_r,c_n)
disp(['pid= ' pid 'sid=' sid ' Task=curve fit activation a_r=' a_r ' c_n=' num2str(c_n)]);
indir=[G.DIR.DATA G.DIR.SEP 'preprocess'];infile=[pid '_' sid '_preprocess.mat'];
load([indir G.DIR.SEP infile]);
now=0;res=[];
for i=1:length(P.rr.window.p1)
    mark=P.rr.window.mark(i);if mark>0, mark=1;end
    if mark==c_n
        if a_r=='a',
            stime=P.rr.avg.matlabtime(P.rr.window.p1(i));
            etime=P.rr.avg.matlabtime(P.rr.window.v1(i));
        else
            stime=P.rr.avg.matlabtime(P.rr.window.v2(i));
            etime=P.rr.avg.matlabtime(P.rr.window.p2(i));
        end
        if c_n==1,
            if check_valid_cocaine(P,stime,etime)==0, continue;end;
        elseif c_n==0,
            if check_valid_noncocaine(P,stime,etime)==0, continue;end;
        end
        ind=find(P.rr.avg.matlabtime>=stime & P.rr.avg.matlabtime<=etime);
        sample=P.rr.avg.(['t' num2str(wsmall)])(ind);
        matlabtime=P.rr.avg.matlabtime(ind);
        if a_r=='a', [m,n]=max(sample); else [m,n]=min(sample);end
        sample(1:n-1)=[];matlabtime(1:n-1)=[];
        if a_r=='a', [m,n]=min(sample); else [m,n]=max(sample);end
        sample(n+1:end)=[];matlabtime(n+1:end)=[];
        %        sx=floor(length(sample)/4);sy=ceil(length(sample)*3/4);
        %        if sy-sx<10, continue;end
        %        sample=sample(sx:sy);
        %        matlabtime=matlabtime(sx:sy);
        
        matlabtime=matlabtime-matlabtime(1);
        sample=sample-min(sample);
        
        if length(sample)<30 , continue;end;
        %        sample=diff(sample);
        %        matlabtime(end)=[];
        %        continue;
        if a_r=='a'
            [b,g]=activation(matlabtime*24*60,sample,max(sample),0);
        else
            [b,g]=recovery(matlabtime*24*60,sample,max(sample),0);
        end
        now=now+1;
        res{now}.sample=sample;
        res{now}.matlabtime=matlabtime;
        res{now}.b=b;
        res{now}.g=g;
        res{now}.height=max(sample);
        res{now}.duration=max(matlabtime)*24*60*60;
        res{now}.dose=P.rr.window.mark(i);
        res{now}.pid=pid;
        res{now}.sid=sid;
        res{now}.a_r=a_r;
        res{now}.c_n=c_n;
        if a_r=='a', ind=find(P.acl.matlabtime>=P.rr.avg.matlabtime(P.rr.window.p1(i)) & P.acl.matlabtime<=P.rr.avg.matlabtime(P.rr.window.v1(i)));
        else ind=find(P.acl.matlabtime>=P.rr.avg.matlabtime(P.rr.window.p1(i)) & P.acl.matlabtime<=P.rr.avg.matlabtime(P.rr.window.p2(i)));
        end
        res{now}.acl.matlabtime=P.acl.matlabtime(ind);
        res{now}.acl.value=P.acl.value(ind);

    end
end
end
function valid=check_valid_cocaine(R,stime,etime)
valid=0;
if isfield(R,'adminmark')==0,return;end;
if isfield(R.adminmark,'matlabtime')==0, return;end;
if length(R.adminmark.matlabtime)==0, return;end;
[m,i]=min(abs(R.adminmark.matlabtime-stime));
if R.adminmark.dose(i)==20 || R.adminmark.dose(i)==40
    for j=1:i-1
        if R.adminmark.dose(i)==R.adminmark.dose(j), return; end;
    end
    valid=1;
    return;
end
end
function valid=check_valid_noncocaine(R,stime,etime)
valid=1;
if isfield(R,'adminmark')==0,return;end;
if isfield(R.adminmark,'matlabtime')==0, return;end;
if length(R.adminmark.matlabtime)==0, return;end;
valid=0;
end

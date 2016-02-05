function res=get_recovery(G,pid,sid,wsmall,c_n)
disp(['pid= ' pid 'sid=' sid ' Task=recovery']);
indir=[G.DIR.DATA G.DIR.SEP 'preprocess'];infile=[pid '_' sid '_preprocess.mat'];
load([indir G.DIR.SEP infile]);

threshold=(max(P.acl.value)-min(P.acl.value))/4+min(P.acl.value);
th=threshold;

now=0;res=[];
for i=1:length(P.rr.window.p1)
    mark=P.rr.window.mark(i);if mark>0, mark=1;end
    if mark==c_n
        stime=P.rr.avg.matlabtime(P.rr.window.v2(i));
        etime=P.rr.avg.matlabtime(P.rr.window.p2(i));
        if c_n==1,
            if check_valid_cocaine(P,stime,etime)==0, continue;end;
        elseif c_n==0,
            if check_valid_noncocaine(P,stime,etime)==0, continue;end;
        end
        ind=find(P.rr.avg.matlabtime>=stime & P.rr.avg.matlabtime<=etime);
        sample=P.rr.avg.(['t' num2str(wsmall)])(ind);
        matlabtime=P.rr.avg.matlabtime(ind);
        
        acl_time=P.acl.matlabtime(ind);
        acl_value=P.acl.value(ind);
        
        [m,n]=min(sample); sample(1:n-1)=[];matlabtime(1:n-1)=[];acl_value(1:n-1)=[];acl_time(1:n-1)=[];
        [m,n]=max(sample); sample(n+1:end)=[];matlabtime(n+1:end)=[]; acl_value(n+1:end)=[];acl_time(n+1:end)=[];
        %ind=find(acl_value>threshold);
        %if ~isempty(ind)
        %    sample(1:ind(end))=[];matlabtime(1:ind(end))=[];acl_value(1:ind(end))=[];acl_time(1:ind(end))=[];
        %end
        if isempty(acl_time), continue, end;
        if c_n==0
            ind=find(P.acl.matlabtime<acl_time(1) & P.acl.matlabtime>acl_time(1)-10/24*60*60);
            ind=find(mean(P.acl.value(ind))>threshold);
            if isempty(ind), continue;end;
            
        end
        if length(sample)<30 , continue;end;
        hold on;
        if c_n==0
            plot(1./sample,'b-');
        else plot(1./sample,'r-');
            continue;
            
            now=now+1;
            res{now}.sample=sample;
            res{now}.matlabtime=matlabtime;
            res{now}.height=max(sample);
            res{now}.duration=max(matlabtime)*24*60*60;
            res{now}.dose=P.rr.window.mark(i);
            res{now}.pid=pid;
            res{now}.sid=sid;
            res{now}.acl.matlabtime=P.acl.matlabtime(ind);
            res{now}.acl.value=P.acl.value(ind);
        end
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

%{
figure;
hold on;
val=P.acl.value;
threshold=150*(threshold-min(val))/(max(val)-min(val));
val=150*(val-min(val))/(max(val)-min(val));
h(3)=plot_signal(P.acl.matlabtime,val,'g-',1,700);legend_text{3}='varince of magnitude (accel)';
h(4)=plot_signal([P.acl.matlabtime(1),P.acl.matlabtime(end)],[threshold,threshold],'k-',2,700);legend_text{4}='Activity Threshold';
      hold on;
        plot_signal(matlabtime,sample,'r-',2);
  
%}
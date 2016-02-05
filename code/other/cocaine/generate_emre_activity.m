function E=generate_emre_activity(G,pid,sid,c_n)
E=[];
disp([pid ' ' sid]);
indir=[G.DIR.DATA G.DIR.SEP 'preprocess'];infile=[pid '_' sid '_preprocess.mat'];
if exist([indir G.DIR.SEP infile], 'file') ~= 2
    return;
end

load([indir G.DIR.SEP infile]);
%figure;
%hold on;
%h(1)=plot_signal(P.rr.matlabtime,P.rr.sample,'b.',1,0); legend_text{1}='RR Interval';
%h(3)=plot_signal(P.rr.avg.matlabtime,P.rr.avg.(['t' num2str(wsmall)]),'y-',2,0);
%h(2)=plot_signal(P.rr.avg.matlabtime,P.rr.avg.t600,'r-',2,0);legend_text{2}='Moving Average(10 minute)';
val=P.acl.value;
threshold=(max(P.acl.value)-min(P.acl.value))/2;
threshold=150*(threshold-min(val))/(max(val)-min(val));
val=150*(val-min(val))/(max(val)-min(val));
val60=150*(P.acl.avg60.value-min(P.acl.avg60.value))/(max(P.acl.avg60.value)-min(P.acl.avg60.value));
val120=150*(P.acl.avg120.value-min(P.acl.avg120.value))/(max(P.acl.avg120.value)-min(P.acl.avg120.value));

%h(3)=plot_signal(P.acl.matlabtime,val,'g-',1,1000);legend_text{3}='varince of magnitude (accel)';
%h(3)=plot_signal(P.acl.avg60.matlabtime,val60,'k-',1,1000);legend_text{3}='varince of magnitude (accel)';
%h(3)=plot_signal(P.acl.avg120.matlabtime,val120,'b-',1,1000);legend_text{3}='varince of magnitude (accel)';

%h(4)=plot_signal([P.acl.matlabtime(1),P.acl.matlabtime(end)],[threshold,threshold],'r-',1,1000);legend_text{4}='Activity Threshold';

threshold=(max(P.acl.avg120.value)-min(P.acl.avg120.value))/2;
%threshold=150*(threshold-min(P.acl.avg120.value))/(max(P.acl.avg120.value)-min(P.acl.avg120.value));

E=[];
now=0;
lasttime=0;
ind=find(P.acl.avg120.value>threshold);
count=0;
for i=1:length(ind)
    nowt=ind(i);
    b_time=P.acl.avg120.matlabtime(nowt);
    a_time=b_time-60/(24*60*60);
    c_time=b_time+600/(24*60*60);
    if lasttime>a_time, continue;end;
    if iscocaine(a_time,c_time)==1, continue;end;
    ind1=find(P.acl.avg120.matlabtime>=a_time & P.acl.avg120.matlabtime<b_time);
    ind2=find(P.acl.avg120.matlabtime>=b_time & P.acl.avg120.matlabtime<=c_time);
    if isempty(ind1) || isempty(ind2), continue;end;
    if mean(P.acl.avg120.value(ind1))>threshold & mean(P.acl.avg120.value(ind2))<threshold
        st=b_time;
        et=c_time;
        ind3=find(P.rr.avg.matlabtime>=st & P.rr.avg.matlabtime<et); 
        [minv,k]=min(P.rr.avg.t600(ind3));
        ind3(1:k)=[];
        [minv,k]=max(P.rr.avg.t600(ind3));
        ind3(k+1:end)=[];
        if length(ind3)<240,continue;end;
        
        st=P.rr.avg.matlabtime(ind3(1));
        et=P.rr.avg.matlabtime(ind3(end));
        ind5=find(P.rr.matlabtime>=st & P.rr.matlabtime<=et);
        if length(ind5)==0, continue;end;
        
        now=now+1;
        E{now}.rr.matlabtime=P.rr.matlabtime(ind5)-P.rr.matlabtime(ind5(1));
        E{now}.rr.sample=P.rr.sample(ind5);

        ind5=find(P.rr.avg.matlabtime>=st & P.rr.avg.matlabtime<=et);
        E{now}.rr.avg.matlabtime=P.rr.avg.matlabtime(ind5)-P.rr.avg.matlabtime(ind5(1));
        E{now}.rr.avg.sample=P.rr.avg.t600(ind5);
        ind5=find(P.acl.matlabtime>=st & P.acl.matlabtime<=et);
        E{now}.acl.matlabtime=P.acl.matlabtime(ind5)-P.acl.matlabtime(ind5(1));
        E{now}.acl.value=P.acl.value(ind5);
        
%        plot_signal(P.rr.avg.matlabtime(ind3),P.rr.avg.t600(ind3),'k-',2);
%        plot_signal(P.rr.avg.matlabtime(ind3),P.rr.avg.t600(ind3)+50,'k-',2);
%        text(P.rr.avg.matlabtime(ind3(1)), P.rr.avg.t600(ind3(1))+100,num2str(count),'Color','r','fontsize',14);
        lasttime=et;
        
    end
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

function fit_recovery_activity(G,pid,sid,OUTDIR,MODEL,w)
threshold=0.21384;
disp(['pid= ' pid 'sid=' sid ' Task=recovery']);
indir=[G.DIR.DATA G.DIR.SEP 'feature'];infile=[MODEL.STUDYTYPE '_' pid '_' sid '_' MODEL.NAME '_' G.FILE.FEATURE_MATNAME];
load([indir G.DIR.SEP infile]);
indir=[G.DIR.DATA G.DIR.SEP 'preprocess'];infile=[pid '_' sid '_preprocess.mat'];
load([indir G.DIR.SEP infile]);
%indir=[G.DIR.DATA G.DIR.SEP 'basicfeature'];infile=[pid '_' sid '_' G.FILE.BASICFEATURE_MATNAME];
%load([indir G.DIR.SEP infile]);

%ind=find(B.sensor{G.SENSOR.R_ECGID}.rr.quality==G.QUALITY.GOOD);
%sample=B.sensor{G.SENSOR.R_ECGID}.rr.sample(ind)*1000;
%matlabtime=B.sensor{G.SENSOR.R_ECGID}.rr.matlabtime(ind);
%ind=find(sample<1500);
%sample=sample(ind);
%matlabtime=matlabtime(ind);
sample=P.rr.sample;
matlabtime=P.rr.matlabtime;
if isempty(sample), return;end;
[A.rr.(['avg' num2str(w)]),A.rr.matlabtime]=compute_moving_avg(sample,matlabtime,w);
[A.activity.acl.matlabtime,A.activity.acl.value]=get_activity_featurevalue(F);
threshold=(max(A.activity.acl.value)-min(A.activity.acl.value))/2;
A.acl.threshold=threshold;

A.activity.acl.window_index=get_activity_window(A,threshold);
A.activity.activation.ind=[];A.activity.recovery.ind=[];
for i=1:2:length(A.activity.acl.window_index)
    [sind,eind]=find_activation(A,i,w);
    if sind~=-1 & eind~=-1, 
        A.activity.activation.ind(end+1)=sind;
        A.activity.activation.ind(end+1)=eind;
    end
    [sind,eind]=find_recovery(A,i,w);
    if sind~=-1 & eind~=-1, 
        A.activity.recovery.ind(end+1)=sind;
        A.activity.recovery.ind(end+1)=eind;
     end
end
%plot_figure(G,pid,sid,P,A,w,threshold);
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
outfile=[pid '_' sid '_activity.mat'];
if isempty(dir(outdir))
    mkdir(outdir);
end
save([outdir G.DIR.SEP outfile],'A');
fprintf(') =>  done\n');

end
%{
function plot_figure(G,pid,sid,P,A,w,threshold)
figure;hold on;
h(1)=plot_signal(P.rr.matlabtime,P.rr.sample,'b.',1,0);
h(3)=plot_signal(A.rr.matlabtime,A.rr.(['avg' num2str(w)]),'y-',2,0);
h(2)=plot_signal(P.rr.avg.matlabtime,P.rr.avg.(['t' num2str(600)]),'r-',2,0);
val=A.activity.acl.value;
threshold=150*(threshold-min(val))/(max(val)-min(val));
val=150*(val-min(val))/(max(val)-min(val));
h(4)=plot_signal(A.activity.acl.matlabtime,val,'g-',1,1000);
h(4)=plot_signal([A.activity.acl.matlabtime(1),A.activity.acl.matlabtime(end)],[threshold,threshold],'r-',1,1000);
%{
for i=1:2:length(A.activity.acl.window_index)
    sind=A.activity.acl.window_index(i);
    eind=A.activity.acl.window_index(i+1);
    plot_signal([A.activity.acl.matlabtime(sind),A.activity.acl.matlabtime(eind)],[threshold,threshold],'k-',3,1000);
end
for i=1:length(A.activity.activation.ind)
    sind=A.activity.activation.ind(i);
    plot_signal(A.rr.matlabtime(sind),A.rr.(['avg' num2str(w)])(sind),'ko',4,0);
end
for i=1:length(A.activity.recovery.ind)
    sind=A.activity.recovery.ind(i);
    plot_signal(A.rr.matlabtime(sind),A.rr.(['avg' num2str(w)])(sind),'co',4,0);
end
%}
coc_mark_lab=plot_adminmark(G,pid,sid,'formattedraw',[0,1000]);
ind=P.rr.win_ind;
ind1=P.rr.macd.posv1;
ind2=P.rr.macd.posv2;
h(6)=plot_signal(P.rr.avg.matlabtime(ind(1:2:end)),P.rr.avg.t600(ind(1:2:end)),'go',4,0);
h(7)=plot_signal(P.rr.avg.matlabtime(ind(2:2:end)),P.rr.avg.t600(ind(2:2:end)),'ro',4,0);
h(6)=plot_signal(P.rr.avg.matlabtime(ind1),P.rr.avg.t600(ind1),'co',4,0);
h(7)=plot_signal(P.rr.avg.matlabtime(ind2),P.rr.avg.t600(ind2),'mo',4,0);

%ind=P.rr.macd.MP1;
%h(8)=plot_signal(P.rr.avg.matlabtime(ind),P.rr.avg.t600(ind),'ko',4,0);

end
%}
%{
function [sind,eind]=find_activation(A,i,w)
    sind=-1;eind=-1;
    stime=A.activity.acl.matlabtime(A.activity.acl.window_index(i));
    ind=find(A.rr.matlabtime>=stime-60/(24*60*60) & A.rr.matlabtime<=stime+60/(24*60*60));  % check previous 1 minute
    if isempty(ind), return;end;
    [~,n]=max(A.rr.(['avg' num2str(w)])(ind));
    sind=ind(n);
    stime=A.rr.matlabtime(sind);
    etime=min(A.activity.acl.matlabtime(A.activity.acl.window_index(i+1)),stime+(5*60)/(24*60*60));
    ind=find(A.rr.matlabtime>=stime & A.rr.matlabtime<=etime);
    [~,n]=min(A.rr.(['avg' num2str(w)])(ind));
    eind=ind(n);
end
function [sind,eind]=find_recovery(A,i,w)
    sind=-1;eind=-1;
    stime=A.activity.acl.matlabtime(A.activity.acl.window_index(i+1));
    ind=find(A.rr.matlabtime>=stime-(60)/(24*60*60) & A.rr.matlabtime<=stime);
    if isempty(ind), return ;end;
    [m,n]=min(A.rr.(['avg' num2str(w)])(ind));
    sind=ind(n);
    stime=A.rr.matlabtime(ind(n));
    ind=find(A.rr.matlabtime>=stime & A.rr.matlabtime<=stime+(5*60)/(24*60*60));
    if isempty(ind), return ;end;
    [m,n]=max(A.rr.(['avg' num2str(w)])(ind));
    eind=ind(n);
end

function [matlabtime,value]=get_activity_featurevalue(F)
matlabtime=[];
value=[];
for i=1:length(F.window)
    if F.window(i).feature{4}.quality~=0, continue;end;
    matlabtime(end+1)=F.window(i).end_matlabtime-(10/(24*60*60));
    value(end+1)=F.window(i).feature{4}.value{30};
end
k=prctile(value,98);
value(find(value>k))=k;
end

%{
function window_index=get_activity_window(A, threshold)
window_index=[];
ind=find(A.activity.acl.value>threshold);
s=1;
count=1;
for i=2:length(ind)
    if ind(i)-ind(i-1)<=60,
        count=count+1;
        e=i;
    else
        if count>=60, window_index(end+1)=ind(s);window_index(end+1)=ind(e);end;         
        s=i;
        count=1;
    end
end
end
%}
%}

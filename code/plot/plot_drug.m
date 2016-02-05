function plot_drug(G,pid,sid,MODEL,druglevel)
indir=[G.DIR.DATA G.DIR.SEP 'formatteddata'];
infile=[pid '_' sid '_' G.FILE.FRMTDATA_MATNAME];
load([indir G.DIR.SEP infile]);

indir=[G.DIR.DATA G.DIR.SEP 'basicfeature'];
infile=[pid '_' sid '_' G.FILE.BASICFEATURE_MATNAME];
load([indir G.DIR.SEP infile]);
indir=[G.DIR.DATA G.DIR.SEP 'feature'];
infile=[MODEL.STUDYTYPE '_' pid '_' sid '_' MODEL.NAME '_' G.FILE.FEATURE_MATNAME];
load([indir G.DIR.SEP infile]);
load([G.DIR.DATA G.DIR.SEP 'curve' G.DIR.SEP MODEL.STUDYTYPE '_' pid '_' sid '_' MODEL.NAME '_smooth.mat']);

%{
ind=find(B.sensor{2}.rr.quality==G.QUALITY.GOOD);
sample=B.sensor{2}.rr.sample(ind);
timestamp=B.sensor{2}.rr.timestamp(ind);
matlabtime=B.sensor{2}.rr.matlabtime(ind);
window=10;
md=zeros(length(timestamp),1);
sd=zeros(length(timestamp),1);

for i=1:length(sample)
    st=timestamp(i)-window*1000;
    et=timestamp(i)+window*1000;
    ind=find(timestamp>=st & timestamp <=et);
    if ~isempty(ind)
        s=sample(ind);
        md(i)=median(s);
        sd(i)=std(s(1:end-1)-s(2:end));
        
    end
end
plot_signal(matlabtime,md,'b.',1);
hold on;
%plot_signal(matlabtime,sd,'r.',1);
%hold on;


[base,a,b]=find_base(G,B,F,D);
%%
h=figure;
title(['pid= ' pid 'sid=' sid]);
ind=find(B.sensor{G.SENSOR.R_ECGID}.rr.quality==G.QUALITY.GOOD);
if ~isempty(ind)
    hold on;plot_signal(B.sensor{G.SENSOR.R_ECGID}.rr.matlabtime(ind),B.sensor{G.SENSOR.R_ECGID}.rr.sample(ind)*500,'g.',1,0);
    hold on;plot_signal([B.sensor{G.SENSOR.R_ECGID}.rr.matlabtime(ind(1)),B.sensor{G.SENSOR.R_ECGID}.rr.matlabtime(ind(end))],[base*500,base*500],'k-',1,0);
end
if ~isempty(C)
    hold on; plot_signal(C.matlab_timestamp,C.Q9_smooth*500,'r-',1);
    hold on;plot_signal(C.matlab_timestamp(C.peak_ind),C.Q9_smooth(C.peak_ind)*500,'b*',2);
    hold on;plot_signal(C.matlab_timestamp(C.valley_ind),C.Q9_smooth(C.valley_ind)*500,'k*',2);
end
[matlabtime,value]=get_featurevalue(G,F,G.FEATURE.R_ACLID,G.FEATURE.R_ACL.STDEVMAGNITUDE);
%plot_signal(matlabtime,value,'b-',1,0);

hold on;plot_signal(B.sensor{G.SENSOR.R_ACLXID}.matlabtime,B.sensor{G.SENSOR.R_ACLXID}.sample,'k-',1,800);
hold on;plot_signal(B.sensor{G.SENSOR.R_ACLYID}.matlabtime,B.sensor{G.SENSOR.R_ACLYID}.sample,'g-',1,1000);
hold on;plot_signal(B.sensor{G.SENSOR.R_ACLZID}.matlabtime,B.sensor{G.SENSOR.R_ACLZID}.sample,'r-',1,1200);

%}

%hold on;plot_adminmark(G,pid,sid,'formatteddata');
%hold on;plot_labstudymark(G,pid,sid,'formatteddata');
%hold on; plot_pdamark(G,pid,sid,'formatteddata');

%sample=C.RR_new;
%sample=md;
sample=C.Q9;
lowest=prctile(sample,1);
highest=prctile(sample,99);
Q=4.0;
for i=0:Q
%    plot_signal([matlabtime(1),matlabtime(end)], [lowest,lowest],'k-',2);
%    plot_signal([matlabtime(1),matlabtime(end)], [highest,highest],'k-',2);
    plot_signal([matlabtime(1),matlabtime(end)], [lowest+i*(highest-lowest)/Q,lowest+i*(highest-lowest)/Q],'k-',2);
%    plot_signal([matlabtime(1),matlabtime(end)], [lowest+2*(highest-lowest)/3,lowest+2*(highest-lowest)/3],'k-',2);
end
%val=double(int32(Q*(sample-lowest)/(highest-lowest)))/(highest-;
%val=sample;
%val(val>=lowest & val<lowest+(highest-lowest)/3)=lowest;
%val(val>=lowest+(highest-lowest)/3 & val<lowest+2*(highest-lowest)/3)=lowest+(highest-lowest)/3;
%val(val>=lowest+2*(highest-lowest)/3)=lowest+2*(highest-lowest)/3;
%{
val=lowest+(highest-lowest)*double(int32(Q*(sample-lowest)/(highest-lowest)))/Q;
for i=2:length(val)-1
    if val(i-1)==val(i+1), val(i)=val(i-1);continue; end;

end
for i=3:length(val)-2
    if val(i-2)==val(i+2), val(i-1)=val(i-2);val(i)=val(i-2);val(i+1)=val(i-2);continue; end;

end

%hold on;plot_signal(C.matlab_timestamp,C.RR_new*500,'k-',1);
%hold on;plot_signal(matlabtime,md,'k-',1);
hold on;plot_signal(matlabtime,val,'k-',2);
%}
%hold on;plot_signal(C.matlab_timestamp,val*500,'b-',2);
return;
ylim([0 900]);
if ~isempty(druglevel)
    ind=find(D.adminmark.dose==druglevel);
    if isempty(ind), close(h);
    else
    xlim([D.adminmark.matlabtime(ind(1))-30/(24*60),D.adminmark.matlabtime(ind(1))+180/(24*60)]);
    end
else
    close(h);
end
sd=zeros(1,length(C.RR_new));
md=zeros(1,length(C.RR_new));
for i=1:length(C.RR_new)
    starttimestamp=C.timestamp(i)-30*1000;
    endtimestamp=C.timestamp(i)+30*1000;
    ind=find(C.timestamp>=starttimestamp & C.timestamp<=endtimestamp);
    rr=C.RR_new(ind);
    
    sd(i)=std(rr(2:end)-rr(1:end-1));
    md(i)=median(rr);
    timestamp(i)=C.timestamp(i);
end
ind=find(D.adminmark.dose==druglevel);
if ~isempty(ind)
    mark=D.adminmark.timestamp(ind(1));
    ind=find(C.timestamp(C.valley_ind)>mark);
    vind=C.valley_ind(ind(1));
    now=vind;
    resind=[];
    while C.timestamp(now)<C.timestamp(vind)+20*60*1000
         resind=[resind, now];
         now=now+1;
    end
    figure;
    scatter(md(resind),sd(resind));
end
%saveas(h,[G.DIR.DATA G.DIR.SEP 'figure' G.DIR.SEP MODEL.STUDYTYPE '_' pid '_' sid '_' MODEL.NAME '_smooth.fig']);
%close(h);
end
function [matlabtime,value]=get_featurevalue(G,F,fid,ffid)
matlabtime=[];value=[];
i=0;
for w=1:length(F.window)
    if F.window(w).feature{fid}.quality~=G.QUALITY.GOOD, continue;end
    if F.window(w).starttimestamp==0, continue;end;
    if F.window(w).start_matlabtime==0, continue;end;
    i=i+1;
    matlabtime(i)=F.window(w).start_matlabtime;
    value(i)=F.window(w).feature{fid}.value{ffid};
end
%}
end
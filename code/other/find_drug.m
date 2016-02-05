function rr=find_drug(G,pid,sid,MODEL,rr,dose)
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
if ~isfield(D.adminmark,'dose'),return;end;
flag=0;
for i=1:length(D.adminmark.dose)
    if flag==1, continue;end;
    if D.adminmark.dose(i)~=dose, continue;end;
    flag=1;
    [baserr,aclbase,aclmax,aclmid]=find_base(G,B,F,D);
    [timestamp2,matlabtime2,value2]=get_featurevalue(G,F,G.FEATURE.R_ACLID,G.FEATURE.R_ACL.RANGEENERGY);
    [timestamp1,matlabtime1,value1]=get_featurevalue(G,F,G.FEATURE.R_ECGID,G.FEATURE.R_ECG.RRCT);
    now=length(rr);
    ind=find(C.timestamp(C.valley_ind)>D.adminmark.timestamp(i));
    vind=ind(1);
    
%    starttimestamp=C.timestamp(C.peak_ind(vind));
%    endtimestamp=C.timestamp(C.peak_ind(vind+1));
    starttimestamp=C.timestamp(C.valley_ind(vind))-5*60*1000;
    endtimestamp=C.timestamp(C.valley_ind(vind))+15*60*1000;

    ind22=find(timestamp2>=starttimestamp & timestamp2<=endtimestamp);
    ind11=find(timestamp1>=starttimestamp & timestamp1<=endtimestamp);
    
    if ~isempty(find(value2(ind22)==-1, 1)) || ~isempty(find(value1(ind11)==-1, 1)), continue;end;
    
%    if prctile(value2(ind22),50)>aclmid,continue;end;
    
    
    %    h=figure;
    %    title(['pid= ' pid 'sid=' sid]);
    ind=find(C.timestamp>=starttimestamp & C.timestamp<=endtimestamp);
    now=now+1;
    sample=C.Q9_smooth(ind);
    %    ind=find(sample>=baserr);
    rr{now}.timestamp=C.timestamp(ind);
    
    %rr{now}.timestamp=C.timestamp(1:ind(1)-1);
    %sample=sample(1:ind(1)-1);
    rr{now}.sample=1./sample-1/baserr;
%    rr{now}.sample(find(rr{now}.sample<0))=0;
    %disp('abc');
    continue;
    %{
    ind=find(B.sensor{G.SENSOR.R_ECGID}.rr.quality==G.QUALITY.GOOD);
    if ~isempty(ind)
        ind1=find(B.sensor{G.SENSOR.R_ECGID}.rr.timestamp(ind)>=starttimestamp & B.sensor{G.SENSOR.R_ECGID}.rr.timestamp(ind)<=endtimestamp);
        x=B.sensor{G.SENSOR.R_ECGID}.rr.sample(ind(ind1))-baserr;
        xx=find(x>=0);
        x=x(1:xx(1)-1);
        if xx(1)-1<=50, continue;end;
        xxx(1)=x(1);
        xxx(2)=x(end);
        
        y=B.sensor{G.SENSOR.R_ECGID}.rr.matlabtime(ind(ind1));
        y=y(1:length(x));
        yyy(1)=y(1);
        yyy(2)=y(end);
        now=now+1;
        figure;plot_signal(y,x,'b.',1,0);
        rr{now}.timestamp=yyy;
        rr{now}.sample=-(1./xxx);
        disp(length(rr{now}.timestamp));

        %        rr{now}.timestamp=B.sensor{G.SENSOR.R_ECGID}.rr.matlabtime(ind(ind1));
%        rr{now}.sample=1./(B.sensor{G.SENSOR.R_ECGID}.rr.sample(ind(ind1))-baserr);
        continue;
        hold on;plot_signal(B.sensor{G.SENSOR.R_ECGID}.rr.matlabtime(ind(ind1)),(B.sensor{G.SENSOR.R_ECGID}.rr.sample(ind(ind1)))*200,'g.',1,0);
        hold on;plot_signal([B.sensor{G.SENSOR.R_ECGID}.rr.matlabtime(ind(ind1(1))),B.sensor{G.SENSOR.R_ECGID}.rr.matlabtime(ind(ind1(end)))],[baserr*200,baserr*200],'k-',1,0);
    end
    %}
    %       plot_signal([matlabtime(1) matlabtime(1)],[0,1000],'r-',1,0);
    %       plot_signal([matlabtime(end) matlabtime(end)],[0,1000],'r-',1,0);
    
    if ~isempty(C)
        ind=find(C.timestamp>=starttimestamp & C.timestamp<=endtimestamp);
        hold on; plot_signal(C.matlab_timestamp(ind),C.Q9_smooth(ind)*200,'r-',1);
        %    hold on;plot_signal(C.matlab_timestamp(C.peak_ind),C.Q9_smooth(C.peak_ind)*500,'b*',2);
        %    hold on;plot_signal(C.matlab_timestamp(C.valley_ind),C.Q9_smooth(C.valley_ind)*500,'k*',2);
    end
    %[matlabtime,value]=get_featurevalue(G,F,G.FEATURE.R_ACLID,G.FEATURE.R_ACL.RANGEENERGY);
    %}
    %        hold on;plot_signal(matlabtime1(i:i+9),value1(i:i+9)*10,'b-',1,0);
    ind=find(B.sensor{G.SENSOR.R_ACLXID}.timestamp>=starttimestamp & B.sensor{G.SENSOR.R_ACLXID}.timestamp<=endtimestamp);
    hold on;plot_signal(B.sensor{G.SENSOR.R_ACLXID}.matlabtime(ind),B.sensor{G.SENSOR.R_ACLXID}.sample(ind),'b-',1,600);
    ind=find(B.sensor{G.SENSOR.R_ACLYID}.timestamp>=starttimestamp & B.sensor{G.SENSOR.R_ACLYID}.timestamp<=endtimestamp);
    hold on;plot_signal(B.sensor{G.SENSOR.R_ACLYID}.matlabtime(ind),B.sensor{G.SENSOR.R_ACLYID}.sample(ind),'r-',1,800);
    ind=find(B.sensor{G.SENSOR.R_ACLZID}.timestamp>=starttimestamp & B.sensor{G.SENSOR.R_ACLZID}.timestamp<=endtimestamp);
    hold on;plot_signal(B.sensor{G.SENSOR.R_ACLZID}.matlabtime(ind),B.sensor{G.SENSOR.R_ACLZID}.sample(ind),'k-',1,1000);
    
    %hold on;plot_signal(B.sensor{G.SENSOR.R_ACLXID}.matlabtime,B.sensor{G.SENSOR.R_ACLXID}.sample,'g-',1,1000);
    %hold on;plot_signal(B.sensor{G.SENSOR.R_ACLXID}.matlabtime,B.sensor{G.SENSOR.R_ACLXID}.sample,'r-',1,1200);
    
    %%
    %}
    %hold on;plot_adminmark(G,pid,sid,'formatteddata');
    %hold on; plot_pdamark(G,pid,sid,'formatteddata');
    ylim([0 1200]);
    %saveas(h,[G.DIR.DATA G.DIR.SEP 'figure' G.DIR.SEP MODEL.STUDYTYPE '_' pid '_' sid '_' MODEL.NAME '_smooth.fig']);
    %close(h);
end
end


function [timestamp,matlabtime,value]=get_featurevalue(G,F,fid,ffid)
matlabtime=[];value=[];
for w=1:length(F.window)
    matlabtime(w)=-1;value(w)=-1;timestamp(w)=-1;
    
    if F.window(w).feature{fid}.quality~=G.QUALITY.GOOD, continue;end
    if F.window(w).starttimestamp==0, continue;end;
    if F.window(w).start_matlabtime==0, continue;end;
    if length(F.window(w).feature{fid}.value)<ffid,continue;end;
    matlabtime(w)=F.window(w).start_matlabtime;
    value(w)=F.window(w).feature{fid}.value{ffid};
    timestamp(w)=F.window(w).starttimestamp;
end

end

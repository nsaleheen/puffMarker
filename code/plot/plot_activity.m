function plot_activity(G,pid,sid,MODEL)
indir=[G.DIR.DATA G.DIR.SEP 'basicfeature'];
infile=[pid '_' sid '_' G.FILE.BASICFEATURE_MATNAME];
load([indir G.DIR.SEP infile]);
indir=[G.DIR.DATA G.DIR.SEP 'feature'];
infile=[MODEL.STUDYTYPE '_' pid '_' sid '_' MODEL.NAME '_' G.FILE.FEATURE_MATNAME];
load([indir G.DIR.SEP infile]);
load([G.DIR.DATA G.DIR.SEP 'curve' G.DIR.SEP MODEL.STUDYTYPE '_' pid '_' sid '_' MODEL.NAME '_smooth.mat']);

base=find_base(G,B,F);
[timestamp2,matlabtime2,value2]=get_featurevalue(G,F,G.FEATURE.R_ACLID,G.FEATURE.R_ACL.RANGEENERGY);

[timestamp1,matlabtime1,value1]=get_featurevalue(G,F,G.FEATURE.R_ECGID,G.FEATURE.R_ECG.RRCT);
prev=-100;
for i=1:length(value2)-10
    if i-10<=prev, continue;end;
    if ~isempty(find(value2(i:i+9)==-1, 1)) || ~isempty(find(value1(i:i+9)==-1, 1)), continue;end;
    if median(value2(i:i+3))>5000 && mean(value2(i+4:i+9))<1000
        matlabtime=matlabtime2(i:i+9);
        timestamp=timestamp2(i:i+9);
        value=value2(i:i+9);
        prev=i;
        %%
        h=figure;
        title(['pid= ' pid 'sid=' sid]);
        ind=find(B.sensor{G.SENSOR.R_ECGID}.rr.quality==G.QUALITY.GOOD);
        if ~isempty(ind)
            ind1=find(B.sensor{G.SENSOR.R_ECGID}.rr.timestamp(ind)>=timestamp(1) & B.sensor{G.SENSOR.R_ECGID}.rr.timestamp(ind)<=timestamp(end));
            hold on;plot_signal(B.sensor{G.SENSOR.R_ECGID}.rr.matlabtime(ind(ind1)),(1./B.sensor{G.SENSOR.R_ECGID}.rr.sample(ind(ind1)))*200,'g.',1,0);
        end
%       plot_signal([matlabtime(1) matlabtime(1)],[0,1000],'r-',1,0); 
%       plot_signal([matlabtime(end) matlabtime(end)],[0,1000],'r-',1,0); 
       
%        if ~isempty(C)
%            ind=find(C.matlab_timestamp>=matlabtime(1) & C.matlab_timestamp<=matlabtime(end));
%            hold on; plot_signal(C.matlab_timestamp(ind),C.Q9_smooth(ind)*500,'r-',1);
            %    hold on;plot_signal(C.matlab_timestamp(C.peak_ind),C.Q9_smooth(C.peak_ind)*500,'b*',2);
            %    hold on;plot_signal(C.matlab_timestamp(C.valley_ind),C.Q9_smooth(C.valley_ind)*500,'k*',2);
 %       end
        %[matlabtime,value]=get_featurevalue(G,F,G.FEATURE.R_ACLID,G.FEATURE.R_ACL.RANGEENERGY);
        %}
        hold on;plot_signal(matlabtime1(i:i+9),value1(i:i+9)*10,'b-',1,0);
        ind=find(B.sensor{G.SENSOR.R_ACLXID}.timestamp>=timestamp(1) & B.sensor{G.SENSOR.R_ACLXID}.timestamp<=timestamp(end));
        hold on;plot_signal(B.sensor{G.SENSOR.R_ACLXID}.matlabtime(ind),B.sensor{G.SENSOR.R_ACLXID}.sample(ind),'b-',1,600);
        ind=find(B.sensor{G.SENSOR.R_ACLYID}.matlabtime>=matlabtime(1) & B.sensor{G.SENSOR.R_ACLYID}.matlabtime<=matlabtime(end));
        hold on;plot_signal(B.sensor{G.SENSOR.R_ACLYID}.matlabtime(ind),B.sensor{G.SENSOR.R_ACLYID}.sample(ind),'r-',1,800);
        ind=find(B.sensor{G.SENSOR.R_ACLZID}.matlabtime>=matlabtime(1) & B.sensor{G.SENSOR.R_ACLZID}.matlabtime<=matlabtime(end));
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
    timestamp(w)=F.window(w).starttimestamp+60000;
    matlabtime(w)=convert_timestamp_matlabtimestamp(G,timestamp(w));
end

end

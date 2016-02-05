function plot_rip_peakvalley(G,data,IDS,svm)
for i=IDS
    hold on;
    maxv=prctile(data.sensor{1}.sample_new,99);
    data.sensor{1}.sample_new(data.sensor{1}.sample_new>maxv)=maxv;
    y=ylim;
    offset=y(1)-maxv;
    %    plot(data.wrist{i}.magnitude.matlabtime,data.wrist{i}.magnitude.sample+offset,'b-');
    %    y=smooth(data.wrist{i}.magnitude.sample);
    %    plot(data.wrist{i}.magnitude.matlabtime,y+offset,'r-');
    %    ss=data.wrist{i}.magnitude.sample;
    %    data.wrist{i}.magnitude.sample_filtered=s;
    
    plot(data.sensor{1}.matlabtime,data.sensor{1}.sample_new+offset,'g-');
    plot(xlim,[0,0]+offset,'k-');
    ind=find(data.wrist{i}.gyr.segment.valid_all==0);
    pind=data.wrist{i}.gyr.segment.peak_ind(ind);pind(pind==0)=[];
    len=length(data.sensor{1}.peakvalley_new_3.sample);
    pind(pind>len)=[];
    plot(data.sensor{1}.peakvalley_new_3.matlabtime(pind),data.sensor{1}.peakvalley_new_3.sample(pind)+offset,'ro');
    plot(data.sensor{1}.peakvalley_new_3.matlabtime(pind-1),data.sensor{1}.peakvalley_new_3.sample(pind-1)+offset,'bo');
    plot(data.sensor{1}.peakvalley_new_3.matlabtime(pind+1),data.sensor{1}.peakvalley_new_3.sample(pind+1)+offset,'bo');
    
    if svm~=0,
        rind=find(data.wrist{i}.gyr.segment.svm_predict(ind)==1);
        rind=ind(rind);
        
        pind=data.wrist{i}.gyr.segment.peak_ind(rind);pind(pind==0)=[];
        len=length(data.sensor{1}.peakvalley_new_3.sample);
        pind(pind>len)=[];
        plot(data.sensor{1}.peakvalley_new_3.matlabtime(pind),data.sensor{1}.peakvalley_new_3.sample(pind)+offset,'mo','markerfacecolor','m');
        %    plot(data.sensor{1}.peakvalley_new_3.matlabtime(pind-1),data.sensor{1}.peakvalley_new_3.sample(pind-1)+offset,'ko','markerfacecolor','r');
        %    plot(data.sensor{1}.peakvalley_new_3.matlabtime(pind+1),data.sensor{1}.peakvalley_new_3.sample(pind+1)+offset,'bo','markerfacecolor','r');
    end
    %    plot(data.sensor{1}.peakvalley_new_3.matlabtime(pind),data.sensor{1}.peakvalley_new_3.sample(pind)+offset,'ro','markerfacecolor','r');
    %    plot(data.sensor{1}.peakvalley_new_3.matlabtime(pind-1),data.sensor{1}.peakvalley_new_3.sample(pind-1)+offset,'bo','markerfacecolor','b');
    %    plot(data.sensor{1}.peakvalley_new_3.matlabtime(pind+1),data.sensor{1}.peakvalley_new_3.sample(pind+1)+offset,'bo','markerfacecolor','b');
    
    if i==1,ids=G.SENSOR.WL9_ACLYID;else ids=G.SENSOR.WR9_ACLYID;end
    maxv=prctile(data.sensor{ids}.sample,80);
    y=ylim;
    offset=y(1)-maxv;
    plot(data.sensor{ids}.matlabtime,data.sensor{ids}.sample+offset,'b.');
    plot(xlim,[0,0]+offset,'k-');
    plot(xlim,[-500,-500]+offset,'k--');
    plot(xlim,[+500,+500]+offset,'k--');
    ind=find(data.wrist{i}.gyr.segment.valid_all==0);
    for now=ind
        stime=data.wrist{i}.gyr.segment.starttimestamp(now);
        etime=data.wrist{i}.gyr.segment.endtimestamp(now);
        [a,b]=binarysearch(data.sensor{ids}.timestamp,stime,etime);
        plot(data.sensor{ids}.matlabtime(a:b),data.sensor{ids}.sample(a:b)+offset,'r-','linewidth',2);
    end
    
    %    plot(xlim,[data.wrist{i}.magnitude.threshold,data.wrist{i}.magnitude.threshold]+offset,'k-');
end
end

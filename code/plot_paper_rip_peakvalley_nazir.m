function plot_paper_rip_peakvalley_nazir(G,data,IDS,svm)
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
%     plot(data.sensor{1}.peakvalley_new_3.matlabtime(pind),data.sensor{1}.peakvalley_new_3.sample(pind)+offset,'ro');
%     plot(data.sensor{1}.peakvalley_new_3.matlabtime(pind-1),data.sensor{1}.peakvalley_new_3.sample(pind-1)+offset,'bo');
%     plot(data.sensor{1}.peakvalley_new_3.matlabtime(pind+1),data.sensor{1}.peakvalley_new_3.sample(pind+1)+offset,'bo');
    
    if svm~=0,
        rind=find(data.wrist{i}.gyr.segment.svm_predict(ind)==1);
        rind=ind(rind);
        
        pind=data.wrist{i}.gyr.segment.peak_ind(rind);pind(pind==0)=[];
        len=length(data.sensor{1}.peakvalley_new_3.sample);
        pind(pind>len)=[];
        
        puff_times = data.sensor{1}.peakvalley_new_3.matlabtime(pind);
		cnt=length(puff_times);
              plot(data.sensor{1}.peakvalley_new_3.matlabtime(pind),data.sensor{1}.peakvalley_new_3.sample(pind)+offset,'ro');
      
        if cnt>1
                diff_time = (puff_times(2) - puff_times(1))*24*60;
                if diff_time < 50
                    plot(data.sensor{1}.peakvalley_new_3.matlabtime(pind(1)),data.sensor{1}.peakvalley_new_3.sample(pind(1))+offset,'mo','markerfacecolor','m');            
                    hold on;
                end
                diff_time = (puff_times(length(puff_times)) - puff_times(length(puff_times)-1))*24*60;
                if  diff_time < 50
                    plot(data.sensor{1}.peakvalley_new_3.matlabtime(pind(length(puff_times))),data.sensor{1}.peakvalley_new_3.sample(pind(length(puff_times)))+offset,'mo','markerfacecolor','m');            
                    hold on;
                end			
                for j=2:length(puff_times)-1
                    diff_time1 = (puff_times(j) - puff_times(j-1))*24*60;
                    diff_time2 = (puff_times(j+1) - puff_times(j))*24*60;
%                   fprintf('dif: %d, ', puff_times(j));
                    if diff_time1 < 50  | diff_time2 < 50 
                        plot(data.sensor{1}.peakvalley_new_3.matlabtime(pind(j)),data.sensor{1}.peakvalley_new_3.sample(pind(j))+offset,'mo','markerfacecolor','m');            
                        hold on;
                    end
                end          
               
            end
        
        %    plot(data.sensor{1}.peakvalley_new_3.matlabtime(pind-1),data.sensor{1}.peakvalley_new_3.sample(pind-1)+offset,'ko','markerfacecolor','r');
        %    plot(data.sensor{1}.peakvalley_new_3.matlabtime(pind+1),data.sensor{1}.peakvalley_new_3.sample(pind+1)+offset,'bo','markerfacecolor','r');
    end
    %    plot(data.sensor{1}.peakvalley_new_3.matlabtime(pind),data.sensor{1}.peakvalley_new_3.sample(pind)+offset,'ro','markerfacecolor','r');
    %    plot(data.sensor{1}.peakvalley_new_3.matlabtime(pind-1),data.sensor{1}.peakvalley_new_3.sample(pind-1)+offset,'bo','markerfacecolor','b');
    %    plot(data.sensor{1}.peakvalley_new_3.matlabtime(pind+1),data.sensor{1}.peakvalley_new_3.sample(pind+1)+offset,'bo','markerfacecolor','b');
    
   
    %    plot(xlim,[data.wrist{i}.magnitude.threshold,data.wrist{i}.magnitude.threshold]+offset,'k-');
end
end

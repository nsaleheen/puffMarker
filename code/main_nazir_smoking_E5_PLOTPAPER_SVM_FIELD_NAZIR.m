function main_nazir_smoking_E5_PLOTPAPER_SVM_FIELD_NAZIR()

close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
%G=config_run_monowar_Memphis_Smoking(G);
G=config_run_MinnesotaLab(G);

PS_LIST=G.PS_LIST;
for pp=1:1 % size(PS_LIST,1)
    pid='p6003';
    slist=PS_LIST{pp,2};
    for s=1:1 %slist
        sid='s02';
        fprintf('pid=%s sid=%s\n',pid,sid);
time=[15,5];
 plot_smoking_segment_withpuff_field(G,pid,sid,'svm_output_w','plot_puff_gyr_groundtruth_graph',time);
        disp('abc');
        break;
    end
end
end

function  plot_smoking_segment_withpuff_field( G, pid,sid, INDIR,OUTDIR,time )

indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' INDIR '.mat'];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);
now=0;
data=P;
h=figure;
 
  plot_paper_rip_peakvalley_nazir_field(G,P,[2],1);
            
 
 offset = -8000;
 
 
 
 %plot(P.sensor{1}.matlabtime, P.sensor{1}.sample-4000, 'r--'); % RIP
 hold on;
 

 
 for i=2:2
         plot(data.wrist{i}.matlabtime,data.wrist{i}.magnitude+offset,'b-');hold on;
     plot(data.wrist{i}.matlabtime,data.wrist{i}.magnitude_800+offset,'g-');hold on;
    plot(data.wrist{i}.matlabtime,data.wrist{i}.magnitude_8000+offset,'k-');hold on;
    
    plot(xlim,[50,50]+offset,'k--');hold on;
    plot(xlim,[0,0]+offset,'k-');hold on;
  
        if i==1
            hold on;
            plot(P.sensor{G.SENSOR.WL9_ACLYID}.matlabtime, P.sensor{G.SENSOR.WL9_ACLYID}.sample+offset-7000);
%             offset=offset+2000;
       hold on;
        end
        if i==2
              hold on;
              plot(P.sensor{G.SENSOR.WR9_ACLYID}.matlabtime, P.sensor{G.SENSOR.WR9_ACLYID}.sample+offset+4000);
%               offset=offset+2000;
        hold on;
        end
        
        offset=offset-7000;
 end
 
 
%G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_GYRZID, 
% for s=[G.SENSOR.WR9_ACLYID, G.SENSOR.WR9_GYRXID, G.SENSOR.WR9_GYRZID]
%    hold on;
%    plot(B.sensor{s}.matlabtime, B.sensor{s}.sample+offset);
%    offset=offset+2000;
%  end
%for i=1:length(B.quality{1}.starttimestamp)
%    hold on; plot([B.quality{1}.startmatlabtime(i),B.quality{1}.endmatlabtime(i)],[1.5,1.5],'r-','linewidth',5);
%end
% dynamicDateTicks
% plot_selfreport_smoking(G,P);hold on;
%  plot_smokinglabel_paper_nazir(G,P);hold on;
 dynamicDateTicks;
 plot_selfreport_smoking_field(G, data);
 ylabel('');
filename=['C:\nazir_smoking\data\MinnesotaLab\plot_results' G.DIR.SEP pid '_' sid '.png'];
 saveas(h,[filename '.fig']);
% save_smokingepisode(G,P,pid,sid,OUTDIR,time(1),time(2),h);close();

end

function plot_selfreport_smoking_field(G,data)
if isfield(data,'selfreport')~=1, return;end;
list_selfreport=[G.SELFREPORT.SMKID];
ylimit=ylim;
for s=list_selfreport
    hold on;
    for i=2:2 % length(data.selfreport{s}.matlabtime) 
        hold on;
        plot([data.selfreport{s}.matlabtime(i),data.selfreport{s}.matlabtime(i)],ylimit,'r-','linewidth',2);
        
        hold on;
        if isfield(data.selfreport{s},'label')~=1, continue;end;
        text(data.selfreport{s}.matlabtime(i), ylimit(1)  , [data.selfreport{s}.NAME ' : ' int2str(i) '(',data.selfreport{s}.label{i} ')'], 'Color', 'k','FontSize',18,'Rotation',90);
        
        
         stime=data.selfreport{s}.matlabtime(i)-(1/(24*60));
    etime=data.selfreport{s}.matlabtime(i)+(5/(24*60));
    xlim([stime,etime]);
    
    end
end
end

function save_smokingepisode(G,data,pid,sid,OUTDIR,leftshift,rightshift,h)
if isfield(data,'smoking_episode')~=1, return;end;
for i=1:1 %length(data.smoking_episode)
    text(data.smoking_episode{i}.startmatlabtime+(0.5/(24*60)), -900  , 'RIP ', 'Color', 'k','FontSize',22,'Rotation',0);  
    text(data.smoking_episode{i}.startmatlabtime+(0.5/(24*60)), -4900  , 'A_Y ', 'Color', 'k','FontSize',22,'Rotation',0);  
    text(data.smoking_episode{i}.startmatlabtime+(0.5/(24*60)), -7900  , 'GYR ', 'Color', 'k','FontSize',22,'Rotation',0);  
    
    
    stime=data.smoking_episode{i}.startmatlabtime+(1/(24*60));
    etime=data.smoking_episode{i}.endmatlabtime-(2.5/(24*60));
    xlim([stime,etime]);
    filename=[G.DIR.DATA G.DIR.SEP OUTDIR G.DIR.SEP pid '_' sid '_smokingepisode_' num2str(i) '.png'];
    set(gcf,'PaperUnits','inches','PaperSize',[16,10],'PaperPosition',[0 0 16 10])
    print('-dpng','-r100',filename);
%    saveas(h,[filename '.fig']);

end
end


function plot_paper_rip_peakvalley_nazir_field(G,data,IDS,svm)
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

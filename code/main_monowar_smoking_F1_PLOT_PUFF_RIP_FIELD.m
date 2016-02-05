close all
clear all
G=config();
% G=config_run_monowar_Memphis_Smoking_Lab(G);
G=config_run_MinnesotaLab(G);
PS_LIST=G.PS_LIST;
R.pid=[];R.sid=[];R.episode=[];R.puff=[];R.starttimestamp=[];R.endtimestamp=[];
pid='p6003';sid='s11';
time_scale=60000;
lw=3;
INDIR='svm_output';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
e=1;p=1;

id=2;
stime=P.selfreport{5}.timestamp(1)-45000;
etime=P.selfreport{5}.timestamp(1)+300000;
if id==1, IDS=[G.SENSOR.WL9_GYRZID:-1:G.SENSOR.WL9_ACLXID,G.SENSOR.R_RIPID];
else IDS=[G.SENSOR.WR9_ACLYID,G.SENSOR.R_RIPID];end;
h=figure;hold on;
%title([pid ' ' sid ' episode=' num2str(e) ' puff=' num2str(p) ' missing=' num2str(P.smoking_episode{e}.puff.acl.missing(p)) ' valid=' num2str(P.smoking_episode{e}.puff.acl.valid(p))]);hold on;
xlabel('Time (in minute)');
ylabel('Magnitude');
offset=50;
%color={[0,0.7,0],[0,0.25,0.5],[0.8,0.4,0],[0,0.7,0],[0,0.25,0.5],[0.8,0.4,0]};

color={[0,0.3,0],[0,0.5,0],[0,0.8,0],[0,0,0.45],[0,0,0.75],[0,0,1],[1,0,0]};
%linestyle={'--','--','--','-.','-.','-.','-'};
linestyle={'-','-','-','-','-','-','-'};

now=1;
l=0;
ind=find(P.wrist{id}.timestamp>=stime & P.wrist{id}.timestamp<=etime);
mx=max(P.wrist{id}.magnitude(ind));mn=min(P.wrist{id}.magnitude(ind));
mg=100*(P.wrist{id}.magnitude(ind)-mn)/(mx-mn);
mg_800=100*(P.wrist{id}.magnitude_800(ind)-mn)/(mx-mn);
mg_8000=100*(P.wrist{id}.magnitude_8000(ind)-mn)/(mx-mn);


%offset=offset+110;
%hold on;text((P.smoking_episode{e}.puff.gyr.starttimestamp(p-1)-stime-10000)/time_scale, 800  ,{'Hand Towards';'    Mouth'}, 'Color', 'k','FontSize',18);
% fprintf('number of Puffs: %d\n', length(P.smoking_episode{e}.puff.gyr.endtimestamp));
for pp=1:length(P.wrist{id}.gyr.segment.starttimestamp)
    if(P.wrist{id}.gyr.segment.valid_all(pp) ~=0)
        continue;
    end
    diff = P.wrist{id}.gyr.segment.endtimestamp(pp)-P.wrist{id}.gyr.segment.starttimestamp(pp) ;
    st = P.wrist{id}.gyr.segment.starttimestamp(pp);
    if diff <=0 
        diff = 3000;
        
    end
%plot(([P.smoking_episode{e}.puff.gyr.starttimestamp(pp),P.smoking_episode{e}.puff.gyr.starttimestamp(pp)]-stime)/time_scale,[0,800],'k-','linewidth',lw);
rectangle('facecolor',[1,1,0.5],'edgecolor',[1,1,0.5],'position',[(st-stime)/time_scale,2,diff/time_scale,900]);
%rectangle('facecolor',[0.8,1,1],'edgecolor',[0.8,1,1],'position',[(P.smoking_episode{e}.puff.gyr.starttimestamp(pp)-stime-1000)/time_scale,2,1,900]);
%rectangle('facecolor',[0.8,1,1],'edgecolor',[0.8,1,1],'position',[(P.smoking_episode{e}.puff.gyr.endtimestamp(pp)-stime)/time_scale,2,1,900]);

%hold on;text((P.smoking_episode{e}.puff.gyr.starttimestamp(pp)-stime)/time_scale, 900  ,{' Hand';'   at';' Mouth'}, 'Color', 'k','FontSize',18);

%  plot(([P.smoking_episode{e}.puff.timestamp(pp),P.smoking_episode{e}.puff.timestamp(pp)]-stime)/time_scale,[0,800],'k--');
%text((P.smoking_episode{e}.puff.gyr.endtimestamp(pp)-stime)/time_scale-0.5, 100  ,'Puff End', 'Color', 'k','FontSize',18,'Rotation',90);

end
  
plot(([P.selfreport{5}.timestamp(1),P.selfreport{5}.timestamp(1)]-stime-15000)/time_scale,[0,500],'k--');
text((P.selfreport{5}.timestamp(1)-stime-15000)/time_scale+0.1, 320  ,'Self report', 'Color', 'k','FontSize',18,'Rotation',90);


plot((P.wrist{id}.timestamp(ind)-stime)/time_scale, mg+offset,'k-','linewidth',lw);
%plot((P.wrist{id}.timestamp(ind)-stime)/time_scale, mg_800+offset,'b-','linewidth',lw);
%plot((P.wrist{id}.timestamp(ind)-stime)/time_scale, mg_8000+offset,'g-','linewidth',lw);

offset=offset+100;

for ids=IDS
    if ids==1,
        [a,b]=binarysearch(P.sensor{ids}.timestamp,stime,etime);
        ind=a:b;
        mx=max(P.sensor{ids}.sample_new(ind));mn=min(P.sensor{ids}.sample_new(ind));
        sample=100*(P.sensor{ids}.sample_new(ind)-mn)/(mx-mn);
        plot((P.sensor{ids}.timestamp(ind)-stime)/time_scale,sample+offset,'color',color{7},'linestyle',linestyle{now},'linewidth',lw);
        plot(xlim,[offset,offset]+50,'k--');
      else
        ind=find(P.sensor{ids}.timestamp>=stime & P.sensor{ids}.timestamp<=etime);
        %                    if isempty(ind), continue;end;
        mx=max(P.sensor{ids}.sample(ind));mn=min(P.sensor{ids}.sample(ind));
        sample=100*(P.sensor{ids}.sample(ind)-mn)/(mx-mn);
        %sample=P.sensor{ids}.sample(ind);
        
        plot((P.sensor{ids}.timestamp(ind)-stime)/time_scale,sample+offset,'color',color{now},'linestyle',linestyle{now},'linewidth',lw);
        %                        plot(xlim,[-600,-600]+offset,'k:');
        plot(xlim,[50,50]+offset,'k--');
        %                        plot(xlim,[600,600]+offset,'k:');
    end
    offset=offset+110;now=now+1;
    
end
i=2;
      
ind=find(P.wrist{i}.gyr.segment.valid_all==0);
    pind=P.wrist{i}.gyr.segment.peak_ind(ind);pind(pind==0)=[];
    len=length(P.sensor{1}.peakvalley_new_3.sample);
    pind(pind>len)=[];
%       length(pind)
%       
%      pind=find(P.sensor{1}.peakvalley_new_3.timestamp(pind)>stime);
%      
%     length(pind)
    
   % pind(1)=[];
    %length(pind)
%     for i=1:length(pind)
%         if P.sensor{1}.peakvalley_new_3.timestamp(pind(i)) < stime |  P.sensor{1}.peakvalley_new_3.timestamp(pind(i)) > etime
%             continue;
%         end
%        if P.wrist{i}.gyr.segment.svm_predict == 1
%            plot((P.sensor{1}.peakvalley_new_3.timestamp(pind(i))-stime)/time_scale,400,'mo','markerfacecolor','m');            
%        else          
%             plot((P.sensor{1}.peakvalley_new_3.timestamp(pind(i))-stime)/time_scale,400,'ro');
%        end
%     end
%     plot((P.sensor{1}.peakvalley_new_3.timestamp(pind)-stime)/time_scale,430,'bo');
    plot((P.sensor{1}.peakvalley_new_3.timestamp(pind)-stime)/time_scale,400,'mo','markerfacecolor','m');            
 
set(findall(gcf,'type','text'),'FontSize',28,'fontWeight','bold','fontname','Timesnewroman');
set(gca,'FontSize',28,'fontWeight','bold','fontname','Timesnewroman');

x=xlim;
xlim([0,(etime-stime)/time_scale]);
ylim([0,500]);
ylabel('  MAG_{GYR}   A_Y     RIP   Output    ');
set(gca,'yticklabel',{[]});

leg={'Magnitude','Magnitude (MovAvg=0.8 sec)', 'Magnitude (MovAvg=8 sec)'};
% legend('Ground Truth','Selected Segments');
%legend(leg,'Location','Northoutside','Orientation','horizontal');

%                label=cellstr(strcat(num2str((0:10:(x(2)/time_scale))','%d')))';
%                set(gca,'XTickLabel',label);

%str=sprintf('%d_%s_%s_%02d_%02d_%02d',valid,pid,sid,e,p,floor(missing*100));
filename=['E:\smoking_memphis_nazir\data\Memphis_Smoking_Lab\plot_puff_gyr_groundtruth_graph' G.DIR.SEP  'moving_avg.png'];
%set(gcf,'PaperUnits','inches','PaperSize',[16,8],'PaperPosition',[0 0 16 8])
print('-dpng','-r100',filename);
print('-depsc',[filename '.eps']);
%                saveas(h,[filename '.fig']);
disp('abc');

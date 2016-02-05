function  plot_smoking_segment_withpuff( G, pid,sid, INDIR,OUTDIR,time )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' INDIR '.mat'];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);
now=0;
data=P;
h=figure;
 
offset = 0;

  plot_paper_rip_peakvalley_nazir(G,P,[2],1);
            
 
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
 plot_smokinglabel_paper_nazir(G,P);hold on;
 dynamicDateTicks;
 ylabel('');
filename=[G.DIR.DATA G.DIR.SEP OUTDIR G.DIR.SEP pid '_' sid '.png'];
 saveas(h,[filename '.fig']);
save_smokingepisode(G,P,pid,sid,OUTDIR,time(1),time(2),h);close();

end

function save_smokingepisode(G,data,pid,sid,OUTDIR,leftshift,rightshift,h)
if isfield(data,'smoking_episode')~=1, return;end;
for i=1:1 %length(data.smoking_episode)
    text(data.smoking_episode{i}.startmatlabtime+(0.5/(24*60)), -900  , 'RIP ', 'Color', 'k','FontSize',22,'Rotation',0);  
    text(data.smoking_episode{i}.startmatlabtime+(0.5/(24*60)), -4900  , 'A_Y ', 'Color', 'k','FontSize',22,'Rotation',0);  
    text(data.smoking_episode{i}.startmatlabtime+(0.5/(24*60)), -7900  , 'GYR ', 'Color', 'k','FontSize',22,'Rotation',0);  
    
    
    stime=data.smoking_episode{i}.startmatlabtime-(1/(24*60));
    etime=data.smoking_episode{i}.endmatlabtime+(2.5/(24*60));
    xlim([stime,etime]);
    filename=[G.DIR.DATA G.DIR.SEP OUTDIR G.DIR.SEP pid '_' sid '_smokingepisode_' num2str(i) '.png'];
    set(gcf,'PaperUnits','inches','PaperSize',[16,10],'PaperPosition',[0 0 16 10])
    print('-dpng','-r100',filename);
%    saveas(h,[filename '.fig']);

end
end
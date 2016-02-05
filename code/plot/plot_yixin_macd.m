function plot_yixin_macd(G,pid,sid,f,s,t)
figure;
h=[];
title(['pid=' pid ' sid=' sid],'FontSize',14);
hold on;
indir=[G.DIR.DATA G.DIR.SEP 'preprocess'];
infile=[pid '_' sid '_preprocess.mat'];
load([indir G.DIR.SEP infile]);
load('all_hand.mat');
%indir=[G.DIR.DATA G.DIR.SEP 'basicfeature'];
%infile=[pid '_' sid '_' G.FILE.BASICFEATURE_MATNAME];
%load([indir G.DIR.SEP infile]);

TYPE=G.AVG;
h(1)=plot_signal(P.rr.matlabtime,P.rr.sample,'b.',1,0);
legend_text{1}='RR Interval';

h(2)=plot_signal(P.rr.smoothtime,P.rr.t3600{G.P95},'y-',2,0);
legend_text{2}='95th Percentile (60 Minutes)';

h(3)=plot_signal(P.rr.smoothtime,P.rr.t600{TYPE},'k-',2,0); 
legend_text{3}='Moving Average (10 Minutes)';
h(4)=plot_signal(P.rr.smoothtime,P.rr.t3600{TYPE},'r-',2,0);   
legend_text{4}='Moving Average (60 Minutes)';
pos1=P.rr.macd.mavg{f(1),s(1),t(1)};
pos2=P.rr.macd.mavg{f(2),s(2),t(2)};
pos3=P.rr.macd.mavg{f(3),s(3),t(3)};
sind=[];eind=[];
for i=1:length(pos3)
    [x,ind]=min(abs(P.rr.macd.time(pos1)-P.rr.macd.time(pos3(i))));
    sind(i)=pos1(ind);
    [x,ind]=min(abs(P.rr.macd.time(pos2)-P.rr.macd.time(pos3(i))));
    eind(i)=pos2(ind);    
end
for i=1:length(sind)-1
    stime=P.rr.macd.time(sind(i));
    etime=P.rr.macd.time(eind(i+1));
    h(5)=plot_signal(P.rr.macd.time(sind(i)),P.rr.t600{G.AVG}(sind(i)),'go',4);
    legend_text{5}='Start Window';
    h(6)=plot_signal(P.rr.macd.time(eind(i+1)),P.rr.t600{G.AVG}(eind(i+1)),'ro',4);
    legend_text{6}='End Window';


    
%{
    if mod(i,2)==1,
        p=patch([stime etime etime stime],[400 400 1200 1200],'g');
%        set(p,'FaceAlpha',0.5);        
%        rectangle('position',[stime,400,etime-stime,1200-400],'facecolor','y','edgecolor','none');
        set(p,'edgecolor','none');

    else
        p=patch([stime etime etime stime],[400 400 1200 1200],'r');  
        set(p,'edgecolor','none');
%        rectangle('position',[stime,400,etime-stime,1200-400],'facecolor','c');
    end
%}
end
%h(6)=plot_signal(P.rr.macd.time(sind),P.rr.t600{G.AVG}(sind),'ro',4);
%h(6)=plot_signal(P.rr.macd.time(eind),P.rr.t600{G.AVG}(eind),'go',4);

%legend_text{6}='Crossover btwn MACD & Signal Line';     
%}
%val=(P.rr.macd.mavg3-P.rr.macd.mavg4);
%pos=find(val(1:end-1)>=0 & val(2:end)<0);
%h(7)=plot_signal(P.rr.macd.time(pos),P.rr.t600{G.AVG}(pos),'ro',3);
%{
ppid=str2num(pid(2:end));ssid=str2num(sid(2:end));
handtime=M{1}{ppid,ssid};
sind=[];eind=[];
for i=1:length(handtime)
    [~,sind(i)]=min(abs(P.rr.macd.time-handtime(i)));

end
for i=1:length(sind)
 %   stime=P.rr.macd.time(sind(i));
    h(5)=plot_signal(P.rr.macd.time(sind(i)),P.rr.t600{G.AVG}(sind(i)),'cd',2);
%    legend_text{5}='Start Window';
%    h(6)=plot_signal(P.rr.macd.time(eind(i)),P.rr.t600{G.AVG}(eind(i)),'cd',2);
%    legend_text{6}='End Window';
end
%}
h(7)=plot_signal(P.sensor{G.SENSOR.R_ACLXID}.matlabtime,P.sensor{G.SENSOR.R_ACLXID}.sample,'g-',1,1400);
legend_text{7}=P.sensor{G.SENSOR.R_ACLXID}.NAME;      


%{
data=findfile_pid_sid_dir(G,pid,sid,'formattedraw');

if isfield(data,'adminmark') && isfield(data.adminmark,'matlabtime')
    xmin=min(data.adminmark.matlabtime);
end
if isfield(data,'pdamark') && isfield(data.pdamark,'matlabtime')
    xmin=min(data.pdamark.matlabtime);
end

%xlim([xmin-datenum(0,0,0,1,0,0), xmin+datenum(0,0,0,4,0,0)]);
hold on;
%}
%plot_labstudymark(G,pid,sid,'formattedraw');
plot_adminmark(G,pid,sid,'formattedraw',[400,1500]);
plot_pdamark(G,pid,sid,'formattedraw');
ylim([400,1600]);
set(gca,'FontSize',14);
legend(h,legend_text,'Interpreter', 'none');
xlabel('Time','FontSize',14);
ylabel('RR values','FontSize',14);
return;

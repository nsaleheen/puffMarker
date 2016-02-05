function plot_yixin(G,pid,sid,f,s,t)
h=[];
title(['pid=' pid ' sid=' sid],'FontSize',14);
hold on;
indir=[G.DIR.DATA G.DIR.SEP 'preprocess'];
infile=[pid '_' sid '_preprocess.mat'];
load([indir G.DIR.SEP infile]);

%indir=[G.DIR.DATA G.DIR.SEP 'basicfeature'];
%infile=[pid '_' sid '_' G.FILE.BASICFEATURE_MATNAME];
%load([indir G.DIR.SEP infile]);
TYPE=G.AVG;
h(1)=plot_signal(P.rr.matlabtime,P.rr.sample,'b.',1,0);
legend_text{1}='RR Interval';
%h(2)=plot_signal(P.rr.smoothtime,P.rr.t3600{TYPE},'r-',2,0);
%legend_text{2}='Average (1 Hour)';

%legend_text{2}='Average (10 Minutes)';
%plot_signal(P.rr.smoothtime,P.rr.t10{TYPE},'c-',2,0);   
%plot_signal(P.rr.smoothtime,P.rr.t60{TYPE},'y-',2,0);   
%plot_signal(P.rr.smoothtime,P.rr.t300{TYPE},'c-',2,0);   

h(2)=plot_signal(P.rr.smoothtime,P.rr.t3600{G.P95},'y-',2,0);
legend_text{2}='95th Percentile (60 Minutes)';
h(3)=plot_signal(P.rr.smoothtime,P.rr.t600{TYPE},'k-',2,0); 
legend_text{3}='Moving Average (10 Minutes)';
h(4)=plot_signal(P.rr.smoothtime,P.rr.t3600{TYPE},'r-',2,0);   
legend_text{4}='Moving Average (60 Minutes)';
%plot_signal(P.rr.smoothtime,P.rr.t7200{G.P95},'m-',2,0)
%{
load('drug_hand.mat');
ppid=str2num(pid(2:end));ssid=str2num(sid(2:end));
for j=1:2
if ~isempty(M{j}{ppid,ssid})
    for i=1:3
        x=M{j}{ppid,ssid}(i);
        ind=find(P.rr.smoothtime>=x);
        y=P.rr.t600{G.AVG}(ind(1));
        plot_signal(x,y,'gd',3);
    end
end
end

h(4)=plot_signal(P.rr.macd.time,P.rr.macd.mavg1+500,'b-',2);
legend_text{4}='MACD Line(30 Min & 10 Min) Shift:500';
h(5)=plot_signal(P.rr.macd.time,P.rr.macd.mavg2+500,'r-',2);
legend_text{5}='Signal Line (7 Minutes)';
plot_signal([P.rr.macd.time(1),P.rr.macd.time(end)],[500,500],'k-',2);
%val=(P.rr.macd.mavg1-P.rr.macd.mavg2);
%pos=find(val(1:end-1)>=0 & val(2:end)<0);
%}
pos=P.rr.macd.mavg{f,s,t};
h(5)=plot_signal(P.rr.macd.time(pos),P.rr.t600{G.AVG}(pos),'ro',4);
legend_text{5}='Crossover btwn MACD & Signal Line';     
%}
%val=(P.rr.macd.mavg3-P.rr.macd.mavg4);
%pos=find(val(1:end-1)>=0 & val(2:end)<0);
%h(7)=plot_signal(P.rr.macd.time(pos),P.rr.t600{G.AVG}(pos),'ro',3);


h(6)=plot_signal(P.sensor{G.SENSOR.R_ACLXID}.matlabtime,P.sensor{G.SENSOR.R_ACLXID}.sample,'g-',1,1400);
legend_text{6}=P.sensor{G.SENSOR.R_ACLXID}.NAME;      


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

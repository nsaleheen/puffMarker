function handmark(G,pid,sid, INDIR)
figure;
h=[];
title(['pid=' pid ' sid=' sid]);
hold on;
indir=[G.DIR.DATA G.DIR.SEP INDIR];
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
h(2)=plot_signal(P.rr.smoothtime,P.rr.t600{TYPE},'k-',2,0); 
legend_text{2}='Moving Average (10 Minutes)';

h(3)=plot_signal(P.rr.smoothtime,P.rr.t3600{TYPE},'r-',2,0);   
legend_text{3}='Moving Average (60 Minutes)';
plot_signal(P.rr.smoothtime,P.rr.t7200{G.AVG},'m-',2,0)

h(7)=plot_signal(P.sensor{G.SENSOR.R_ACLXID}.matlabtime,P.sensor{G.SENSOR.R_ACLXID}.sample,'g-',1,1400);
legend_text{7}=P.sensor{G.SENSOR.R_ACLXID}.NAME;      

plot_adminmark(G,pid,sid,'formattedraw',[400,1500]);
plot_pdamark(G,pid,sid,'formattedraw');
ylim([400,1600]);
set(gca,'FontSize',14);
%legend(h,legend_text,'Interpreter', 'none');
xlabel('Time','FontSize',14);
ylabel('RR values','FontSize',14);
return;

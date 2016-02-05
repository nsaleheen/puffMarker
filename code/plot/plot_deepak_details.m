function plot_deepak_details(G,pid,sid)
h=[];
figure;
title(['pid=' pid ' sid=' sid],'FontSize',14);
hold on;
indir=[G.DIR.DATA G.DIR.SEP 'deepak'];
infile=[pid '_' sid '.mat'];
load([indir G.DIR.SEP infile]);

figure; plot_signal(A.smooth.matlabtime,A.smooth.sample,'b-',1);
ind=find(A.peak.type=='P');
hold on; plot_signal(A.peak.matlabtime(ind),A.peak.sample(ind),'y.',1);
ind=find(A.peak.type=='Q');
hold on; plot_signal(A.peak.matlabtime(ind),A.peak.sample(ind),'g.',1);
ind=find(A.peak.type=='R');
hold on; plot_signal(A.peak.matlabtime(ind),A.peak.sample(ind),'r.',1);
ind=find(A.peak.type=='S');
hold on; plot_signal(A.peak.matlabtime(ind),A.peak.sample(ind),'k.',1);
ind=find(A.peak.type=='T');
hold on; plot_signal(A.peak.matlabtime(ind),A.peak.sample(ind),'c.',1);

return;
indir=[G.DIR.DATA G.DIR.SEP 'basicfeature'];
infile=[pid '_' sid '_' G.FILE.BASICFEATURE_MATNAME];
load([indir G.DIR.SEP infile]);

% Our RR Interval
ind=find(B.sensor{G.SENSOR.R_ECGID}.rr.quality==G.QUALITY.GOOD);
sample=scaling(B.sensor{G.SENSOR.R_ECGID}.rr.sample(ind),98,2);
h(2)=plot_signal(B.sensor{G.SENSOR.R_ECGID}.rr.matlabtime(ind),sample,'b.',1,0);
legend_text{2}='Our RR Interval';

%Deepak RR Interval
sample=scaling(A.feature.rr,98,2);
h(3)=plot_signal(A.feature.matlabtime-1/24.0,sample,'r.',1,0);
legend_text{3}='Deepak RR Interval';

sample=scaling(A.feature.th,98,2);
h(4)=plot_signal(A.feature.matlabtime-1/24.0,sample,'g.',1,150);
legend_text{4}='Deepak T Interval';

sample=scaling(A.feature.qt,90,2);
h(5)=plot_signal(A.feature.matlabtime-1/24.0,sample,'m.',1,300);
legend_text{5}='Deepak QT Interval';

sample=scaling(A.feature.qrs,95,2);
h(6)=plot_signal(A.feature.matlabtime-1/24.0,sample,'b.',1,450);
legend_text{6}='Deepak QRS Interval';

sample=scaling(A.feature.pr,98,2);
h(7)=plot_signal(A.feature.matlabtime-1/24.0,sample,'k.',1,600);
legend_text{7}='Deepak PR Interval';

% Accelerometer
sample=scaling(B.sensor{G.SENSOR.R_ACLXID}.sample,99,1);
h(1)=plot_signal(B.sensor{G.SENSOR.R_ACLXID}.matlabtime,sample,'g-',1,800);
legend_text{1}=B.sensor{G.SENSOR.R_ACLXID}.NAME;


plot_adminmark(G,pid,sid,'formattedraw',[0,1500]);
plot_pdamark(G,pid,sid,'formattedraw');
ylim([0,1500]);
set(gca,'FontSize',14);
legend(h,legend_text,'Interpreter', 'none');
xlabel('Time','FontSize',14);
ylabel('RR values','FontSize',14);
return;
end

function sample=scaling(sample,MAXP,MINP)
%MAXP=95;MINP=5;
max=prctile(sample,MAXP);
min=prctile(sample,MINP);
sample=100*(sample-min)/(max-min);
end

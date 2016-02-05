function plot_deepak(G,pid,sid)
h=[];
figure;
title(['pid=' pid ' sid=' sid],'FontSize',14);
hold on;
indir=[G.DIR.DATA G.DIR.SEP 'deepak'];
infile=[pid '_' sid '.mat'];
load([indir G.DIR.SEP infile]);
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
legend_text{3}='Paper RR Interval';

sample=scaling(A.feature.th,98,2);
h(4)=plot_signal(A.feature.matlabtime-1/24.0,sample,'g.',1,200);
legend_text{4}='Paper T Height';

sample=scaling(A.feature.qt,90,2);
h(5)=plot_signal(A.feature.matlabtime-1/24.0,sample,'m.',1,400);
legend_text{5}='Paper QT Interval';

sample=scaling(A.feature.qrs,95,2);
h(6)=plot_signal(A.feature.matlabtime-1/24.0,sample,'b.',1,600);
legend_text{6}='Paper QRS Interval';

sample=scaling(A.feature.pr,98,2);
h(7)=plot_signal(A.feature.matlabtime-1/24.0,sample,'k.',1,800);
legend_text{7}='Paper PR Interval';

% Accelerometer
sample=scaling(B.sensor{G.SENSOR.R_ACLXID}.sample,99,1);
matlabtime=convert_timestamp_matlabtimestamp(G,B.sensor{G.SENSOR.R_ACLXID}.timestamp);

h(1)=plot_signal(matlabtime,sample,'g-',1,1000);
legend_text{1}=B.sensor{G.SENSOR.R_ACLXID}.NAME;


plot_adminmark(G,pid,sid,'formattedraw',[0,1500]);
plot_pdamark(G,pid,sid,'formattedraw');
ylim([-50,1500]);
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

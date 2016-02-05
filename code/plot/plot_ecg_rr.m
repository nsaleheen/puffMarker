function plot_ecg_rr(G,pid,sid)
figure;
hold on;
h=[];
title(['pid=' pid ' sid=' sid]);
hold on;
indir=[G.DIR.DATA G.DIR.SEP 'formatteddata'];
infile=[pid '_' sid '_' G.FILE.FRMTDATA_MATNAME];
load([indir G.DIR.SEP infile]);

indir=[G.DIR.DATA G.DIR.SEP 'basicfeature'];
infile=[pid '_' sid '_' G.FILE.BASICFEATURE_MATNAME];
load([indir G.DIR.SEP infile]);

plot_signal(D.sensor{G.SENSOR.R_ECGID}.matlabtime_all,D.sensor{G.SENSOR.R_ECGID}.sample_all,'r-',1);
plot_signal(D.sensor{G.SENSOR.R_ECGID}.matlabtime,D.sensor{G.SENSOR.R_ECGID}.sample,'b-',1);
index=B.sensor{G.SENSOR.R_ECGID}.rr.index;
plot_signal(D.sensor{G.SENSOR.R_ECGID}.matlabtime(index),D.sensor{G.SENSOR.R_ECGID}.sample(index),'ko',1);

ind=find(B.sensor{G.SENSOR.R_ECGID}.rr.quality==G.QUALITY.GOOD);

if ~isempty(ind)
    h(1)=plot_signal(B.sensor{G.SENSOR.R_ECGID}.rr.matlabtime,B.sensor{G.SENSOR.R_ECGID}.rr.sample*3000+4000,'r.',1,0);
    
    h(1)=plot_signal(B.sensor{G.SENSOR.R_ECGID}.rr.matlabtime(ind),B.sensor{G.SENSOR.R_ECGID}.rr.sample(ind)*3000+4000,'b.',1,0);
    legend_text{1}='RR Interval';
end
sample=B.sensor{G.SENSOR.R_ECGID}.rr.sample(ind)*1000;
matlabtime=B.sensor{G.SENSOR.R_ECGID}.rr.matlabtime(ind);
ylim([500,8000]);
end
function plot_cress_data()
filename='C:\DataProcessingFramework_COC_M\data\Memphis_Smoking\cress\p10_s01_c1_cress.mat';
if exist(filename,'file')~=2,return;end
load(filename);
f=figure;
set(f,'name',filename);
plot_sensor(C);
plot_cress(C);
title('Signal: [Blue-Respiration], [Green-Right Wrist Acclelerometer Y], [Cyan - Left Wrist Acclelerometer Y] Circle: [Green-peak, Cyan-valley], Line: Red-cress puff, Black-ACLY threshold line');
end
function plot_cress(C)
%plot cress data
hold on;
plot([C.cress.startmatlabtime,C.cress.startmatlabtime],ylim,'r-','linewidth',2);
plot([C.cress.endmatlabtime,C.cress.endmatlabtime],ylim,'r-','linewidth',2);
for i=1:length(C.cress.puff)
    plot([C.cress.puff{i}.startmatlabtime,C.cress.puff{i}.startmatlabtime],ylim,'r:','linewidth',2);
    
end
end
function plot_sensor(C)
hold on;plot(C.sensor{1}.matlabtime, C.sensor{1}.sample+8000,'b-');
hold on;plot(C.sensor{1}.peakvalley.matlabtime(1:2:end),C.sensor{1}.peakvalley.sample(1:2:end)+8000,'go','linewidth',5);
hold on;plot(C.sensor{1}.peakvalley.matlabtime(2:2:end),C.sensor{1}.peakvalley.sample(2:2:end)+8000,'co','linewidth',5);

hold on;plot(C.sensor{34}.matlabtime, C.sensor{34}.sample+4000,'g-');
hold on; xx=xlim; plot(xx,[600,600]+4000,'k--','linewidth',2);

hold on;plot(C.sensor{27}.matlabtime, C.sensor{27}.sample,'c-');
hold on; xx=xlim; plot(xx,[600,600],'k--','linewidth',2);
end
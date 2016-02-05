function rr=detect_RR(G,sample,timestamp)
rr.sample=[];
rr.timestamp=[];
FREQ=G.SENSOR.ID(G.SENSOR.R_ECGID).FREQ;
if isempty(sample) || isempty(timestamp), return;end;
if length(sample)<(64*60*15), return;end;

Rpeak_index = ddetect_Rpeak(sample,FREQ,0);

pkT=timestamp(Rpeak_index);   
rr.sample=diff(pkT)/1000;
rr.timestamp=pkT(1:end-1);
rr.index=Rpeak_index;
%plot(timestamp,sample); 
%hold on;
%plot(timestamp(Rpeak_index),sample(Rpeak_index),'r.');

end

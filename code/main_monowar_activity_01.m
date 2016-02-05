clear all
close all
G=config();
%G=config_run_monowar_Memphis_Smoking_Lab(G);
G=config_run_nida(G);
pid='p12';sid='s10';
INDIR='basicfeature';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if isempty([indir G.DIR.SEP infile]),    disp(['FILE NOT FOUND' indir G.DIR.SEP infile]);return;end; load([indir G.DIR.SEP infile]);
disp('abc');
val=prctile(B.sensor{2}.rr.sample,99);
B.sensor{2}.rr.sample(B.sensor{2}.rr.sample>val)=val;

stime=B.sensor{2}.rr.matlabtime(1);
etime=B.sensor{2}.rr.matlabtime(end);
x=1/(10.6666667*60*60*24);
t=stime:x:etime;
sample=[];
for s=4:6
    sample(s,:)=interp1(B.sensor{s}.matlabtime,B.sensor{s}.sample,t);
    
end
mag=sample(4,:).*sample(4,:)+sample(5,:).*sample(5,:)+sample(6,:).*sample(6,:);

plot_signal(B.sensor{2}.rr.matlabtime,B.sensor{2}.rr.sample,'b','.',1,0,1,'b');
plot(B.sensor{4}
function plot_smoking_nazir( G, pid,sid, INDIR,OUTDIR,time )
%PLOT_SMOKING_NAZIR Summary of this function goes here
%   Detailed explanation goes here
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' INDIR '.mat'];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);
now=0;
h=figure;title(['pid=' pid ' sid=' sid]);
offset = 2000;

 plot(B.sensor{1}.matlabtime, B.sensor{1}.sample-2000); % RIP
%G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_GYRZID, 
for s=[G.SENSOR.WR9_ACLYID, G.SENSOR.WR9_GYRXID, G.SENSOR.WR9_GYRZID]
   hold on;
   plot(B.sensor{s}.matlabtime, B.sensor{s}.sample+offset);
   offset=offset+2000;
 end
%for i=1:length(B.quality{1}.starttimestamp)
%    hold on; plot([B.quality{1}.startmatlabtime(i),B.quality{1}.endmatlabtime(i)],[1.5,1.5],'r-','linewidth',5);
%end
% dynamicDateTicks
plot_selfreport_smoking(G,B);
plot_smokinglabel(G,B);
save_figure(G,B,pid,sid,OUTDIR,time(1),time(2),h);close();


end


function plot_missing(G, pid,sid, INDIR,OUTDIR,time)

indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' INDIR '.mat'];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);
now=0;
h=figure;title(['pid=' pid ' sid=' sid]);
for s=[G.SENSOR.R_RIPID, G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_GYRZID, G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_GYRZID]
    if s==G.SENSOR.R_RIPID, th=46.8750*11+50; else, th=62.5*11+50;end;
   ind=find(B.sensor{s}.timestamp(2:end)-B.sensor{s}.timestamp(1:end-1)>=th);
   now=now+1;
   hold on;
   for i=1:length(ind)
       plot([B.sensor{s}.matlabtime(ind(i)+1),B.sensor{s}.matlabtime(ind(i))],[now,now],'k-','linewidth',5);
   end
   fprintf('%d=%d, ',s,length(ind));
end
%for i=1:length(B.quality{1}.starttimestamp)
%    hold on; plot([B.quality{1}.startmatlabtime(i),B.quality{1}.endmatlabtime(i)],[1.5,1.5],'r-','linewidth',5);
%end
dynamicDateTicks
plot_selfreport_smoking(G,B);
plot_smokinglabel(G,B);
save_figure(G,B,pid,sid,OUTDIR,time(1),time(2),h);close();

end

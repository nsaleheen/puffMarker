function res=plot_recover_cocaine(G,pid,sid,M,res,mg)
h=[];
hold on;
title(['pid=' pid ' sid=' sid]);
ppid=str2num(pid(2:end));ssid=str2num(sid(2:end));
timestamp=M{mg}{ppid,ssid};timestamp=sort(timestamp);

hold on;
indir=[G.DIR.DATA G.DIR.SEP 'preprocess'];
infile=[pid '_' sid '_preprocess.mat'];
load([indir G.DIR.SEP infile]);
ind=find(P.rr.smoothtime>=timestamp(1));
x1=P.rr.smoothtime(ind(1));
%y1=P.rr.t600{G.AVG}(ind(1));
y1=P.rr.t3600{G.P95}(ind(1));
ind=find(P.rr.smoothtime>=timestamp(2));
x2=P.rr.smoothtime(ind(1));
y2=P.rr.t600{G.AVG}(ind(1));
%y2=P.rr.t3600{G.P95}(ind(1));

ind=find(P.rr.smoothtime>=timestamp(3));
x3=P.rr.smoothtime(ind(1));
%y3=P.rr.t600{G.AVG}(ind(1));
y3=P.rr.t3600{G.P95}(ind(1));
maxy=max(y1,y3);
miny=y2;
i=0;
colorr={'ro','bo','ko'};
for x=x2:5/(24*60):x3
    i=i+1;
    ind=find(P.rr.smoothtime>=x);
    y=P.rr.t600{G.AVG}(ind(1));
    val=(100*(y-miny))/(maxy-miny);
    res{i}(end+1)=val;
    plot([(i-1)*5,(i-1)*5],[val,val],colorr{str2num(pid(2:end))}, 'MarkerFaceColor',colorr{str2num(pid(2:end))}(1));
end
return;
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

h(2)=plot_signal(P.rr.smoothtime,P.rr.t600{TYPE},'k-',2,0); 
legend_text{2}='Moving Average (10 Minutes)';

h(3)=plot_signal(P.rr.smoothtime,P.rr.t3600{TYPE},'r-',2,0);   
legend_text{3}='Moving Average (60 Minutes)';

plot_adminmark(G,pid,sid,'formattedraw',[400,1500]);
plot_pdamark(G,pid,sid,'formattedraw');
ylim([400,1600]);
set(gca,'FontSize',14);
%legend(h,legend_text,'Interpreter', 'none');
xlabel('Time','FontSize',14);
ylabel('RR values','FontSize',14);
return;

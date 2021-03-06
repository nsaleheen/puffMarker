function plot_macd_paper(G,pid,sid)
hh = figure();
scrsz = get(0,'ScreenSize');
set(hh,'Units','Pixels','Position',[1 1 scrsz(3) scrsz(4)]);title('Lab Study Data','FontSize',20);
hold on;
indir=[G.DIR.DATA G.DIR.SEP 'preprocess'];
infile=[pid '_' sid '_preprocess.mat'];
if exist([indir G.DIR.SEP infile], 'file') ~= 2
    close(hh);
    return;
end
load([indir G.DIR.SEP infile]);
hhh=0;h=[];
hhh=hhh+1;h(hhh)=plot_signal(P.rr.matlabtime,P.rr.sample,'g.',1,0); legend_text{hhh}='RR Interval';
hhh=hhh+1;h(hhh)=plot_signal(P.rr.avg.matlabtime,P.rr.avg.t600,'r--',2,0);legend_text{hhh}='Moving Avg(RR Interval)';
hhh=hhh+1;
for i=1:length(P.rr.macd.MP)
%    p1=P.rr.window.p1(i);p2=P.rr.window.p2(i);
%    v1=P.rr.window.v1(i);v2=P.rr.window.v2(i);
    p1=P.rr.macd.MP(i);
    
%    if P.rr.window.mark(i)<0, 
%        continue;
%    end;
    h(3)=plot_signal(P.rr.avg.matlabtime(p1),P.rr.avg.t600(p1),'bo',4,0);legend_text{hhh}='Window';
    h(4)=plot_signal([P.rr.avg.matlabtime(p1) P.rr.avg.matlabtime(p1)],[500 1800],'k:',2,0);legend_text{hhh+1}='Cross point';

%    h(hhh)=plot_signal(P.rr.avg.matlabtime(p1),P.rr.avg.t600(p1),'bo',4,0);legend_text{hhh}='Activation Start';
%        hhh=hhh+1;h(hhh)=plot_signal(P.rr.avg.matlabtime(v1),P.rr.avg.t600(v1),'bo',4,0);legend_text{hhh}='Activation End';
%        hhh=hhh+1;h(hhh)=plot_signal(P.rr.avg.matlabtime(v2),P.rr.avg.t600(v2),'mo',4,0);legend_text{hhh}='Recovery Start';
%    h(hhh+1)=plot_signal(P.rr.avg.matlabtime(p2),P.rr.avg.t600(p2),'ro',4,0);legend_text{hhh+1}='Recovery End';
end
hhh=hhh+1;
hhh=hhh+1;h(hhh)=plot_signal(P.rr.macd.matlabtime,P.rr.macd.M1,'b-',2,1500,1.5); legend_text{hhh}='MACD Line';
hhh=hhh+1;h(hhh)=plot_signal(P.rr.macd.matlabtime,P.rr.macd.M2,'r-',2,1500,1.5);legend_text{hhh}='Signal Line';
hhh=hhh+1;h(hhh)=plot_signal([P.rr.macd.matlabtime(1),P.rr.macd.matlabtime(end)],[1500,1500],'k-',2);legend_text{hhh}='Base Line';

val=P.acl.value;
threshold=(max(P.acl.value)-min(P.acl.value))/2;
threshold=150*(threshold-min(val))/(max(val)-min(val));
val=150*(val-min(val))/(max(val)-min(val));
val60=150*(P.acl.avg60.value-min(P.acl.avg60.value))/(max(P.acl.avg60.value)-min(P.acl.avg60.value));
%val30=150*(P.acl.avg30.value-min(P.acl.avg30.value))/(max(P.acl.avg30.value)-min(P.acl.avg30.value));

%h(3)=plot_signal(P.acl.matlabtime,val,'g-',1,1000);legend_text{3}='varince of magnitude (accel)';
hhh=hhh+1;h(hhh)=plot_signal(P.acl.avg60.matlabtime,val60,'g-',2,2000);legend_text{hhh}='Activity Indicator(ACCEL)';
%h(3)=plot_signal(P.acl.avg30.matlabtime,val30,'b-',1,1000);legend_text{3}='varince of magnitude (accel)';

hhh=hhh+1;h(hhh)=plot_signal([P.acl.matlabtime(1),P.acl.matlabtime(end)],[threshold,threshold],'k-.',2,2000);legend_text{hhh}='Activity Threshold';
%h(5)=plot_signal(P.rr.avg.matlabtime(P.rr.macd.MP1),P.rr.avg.t600(P.rr.macd.MP1),'go',8,0);legend_text{5}='Window Start';
%h(5)=plot_signal(P.rr.avg.matlabtime(P.rr.macd.LP1),P.rr.avg.t600(P.rr.macd.LP1),'ro',8,0);legend_text{5}='Window Start';



coc_mark_lab=plot_adminmark(G,pid,sid,'formattedraw',[500, 2500],1800);
coc_mark=plot_pdamark(G,pid,sid,'formattedraw');
%ylim([300,3000]);
%time='04/16/2012 10:00:00';timestamp=convert_time_timestamp(G,time);t1=convert_timestamp_matlabtimestamp(G,timestamp);

%time='04/16/2012 16:00:00';timestamp=convert_time_timestamp(G,time);t2=convert_timestamp_matlabtimestamp(G,timestamp);
%time='02/13/2012 11:30:00';timestamp=convert_time_timestamp(G,time);t1=convert_timestamp_matlabtimestamp(G,timestamp);
%time='02/13/2012 15:30:00';timestamp=convert_time_timestamp(G,time);t2=convert_timestamp_matlabtimestamp(G,timestamp);

xlim([t1,t2]);
set(gca,'FontSize',20);
legend(h,legend_text,'Interpreter', 'none');
xlabel('Time','FontSize',20);
ylabel('RR value         MACD           Activity               ','FontSize',20);
columnlegend(3,h, legend_text,'Location', 'NorthWest'); 
export_fig('C:\Users\smhssain\Desktop\drug_fig\paper\macd.pdf');
export_fig('C:\Users\smhssain\Desktop\drug_fig\paper\macd.bmp');
export_fig('C:\Users\smhssain\Desktop\drug_fig\paper\macd.jpg');
export_fig('C:\Users\smhssain\Desktop\drug_fig\paper\macd.eps');

%saveas(hh,[G.DIR.DATA G.DIR.SEP 'figure' G.DIR.SEP pid '_' sid '.jpg']);
saveas(hh,[G.DIR.DATA G.DIR.SEP 'figure_act' G.DIR.SEP pid '_' sid '.fig']);

return;

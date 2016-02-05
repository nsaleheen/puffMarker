function plot_macd_paper_new(G,pid,sid)
hh = figure();
scrsz = get(0,'ScreenSize');
set(hh,'Units','Pixels','Position',[1 1 scrsz(3) scrsz(4)]);%title('In-Residence Study Data','FontSize',36);
hold on;
indir=[G.DIR.DATA G.DIR.SEP 'segment'];
infile=[pid '_' sid '_segment.mat'];
if exist([indir G.DIR.SEP infile], 'file') ~= 2
    close(hh);
    return;
end
load([indir G.DIR.SEP infile]);
hhh=0;h=[];
hhh=hhh+1;h(hhh)=plot(P.rr.matlabtime,P.rr.sample,'g.','markersize',15);
%plot_signal(P.rr.matlabtime,P.rr.sample,'g.',2,0); 
legend_text{hhh}='RR Interval';
hhh=hhh+1;h(hhh)=plot_signal(P.rr.avg.matlabtime,P.rr.avg.t600,'r-',4,0);legend_text{hhh}='Moving Avg(RR Interval)';
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
hhh=hhh+1;h(hhh)=plot_signal(P.rr.macd.matlabtime,P.rr.macd.M1,'b-',2,1300,1.5); legend_text{hhh}='MACD Line';
hhh=hhh+1;h(hhh)=plot_signal(P.rr.macd.matlabtime,P.rr.macd.M2,'r-',2,1300,1.5);legend_text{hhh}='Signal Line';
hhh=hhh+1;h(hhh)=plot_signal([P.rr.macd.matlabtime(1),P.rr.macd.matlabtime(end)],[1300,1300],'k-',2);legend_text{hhh}='Base Line';

val=P.acl.value;
threshold=(max(P.acl.value)-min(P.acl.value))/2;
threshold=150*(threshold-min(val))/(max(val)-min(val));
val=150*(val-min(val))/(max(val)-min(val));
val60=150*(P.acl.avg.t60-min(P.acl.avg.t60))/(max(P.acl.avg.t60)-min(P.acl.avg.t60));
%val30=150*(P.acl.avg30.value-min(P.acl.avg30.value))/(max(P.acl.avg30.value)-min(P.acl.avg30.value));

%h(3)=plot_signal(P.acl.matlabtime,val,'g-',1,1000);legend_text{3}='varince of magnitude (accel)';
hhh=hhh+1;h(hhh)=plot_signal(P.acl.avg.matlabtime,val60,'b-',3,1800);legend_text{hhh}='Activity Indicator(Accel)';
%h(3)=plot_signal(P.acl.avg30.matlabtime,val30,'b-',1,1000);legend_text{3}='varince of magnitude (accel)';

hhh=hhh+1;h(hhh)=plot_signal([P.acl.matlabtime(1),P.acl.matlabtime(end)],[threshold,threshold],'r-.',3,1800);legend_text{hhh}='Activity Threshold';
%h(5)=plot_signal(P.rr.avg.matlabtime(P.rr.macd.MP1),P.rr.avg.t600(P.rr.macd.MP1),'go',8,0);legend_text{5}='Window Start';
%h(5)=plot_signal(P.rr.avg.matlabtime(P.rr.macd.LP1),P.rr.avg.t600(P.rr.macd.LP1),'ro',8,0);legend_text{5}='Window Start';



coc_mark_lab=plot_adminmark(G,pid,sid,'formattedraw',[500, 2200],1200);
%ylim([300,3000]);
%time='04/16/2012 10:00:00';timestamp=convert_time_timestamp(G,time);t1=convert_timestamp_matlabtimestamp(G,timestamp);

%time='04/16/2012 16:00:00';timestamp=convert_time_timestamp(G,time);t2=convert_timestamp_matlabtimestamp(G,timestamp);
time='02/13/2012 11:30:00';timestamp=convert_time_timestamp(G,time);t1=convert_timestamp_matlabtimestamp(G,timestamp);
time='02/13/2012 15:30:00';timestamp=convert_time_timestamp(G,time);t2=convert_timestamp_matlabtimestamp(G,timestamp);

xlim([t1,t2]);
ylim([500,3000]);
%set(gca,'FontSize',20);
legend(h,legend_text,'Interpreter', 'none');
%xlabel('Time','FontSize',20);
%ylabel('RR value         MACD           Activity               ','FontSize',20);


set(0,'DefaultAxesFontSize', 36);
set(0,'DefaultTextFontSize', 36);

set(gca,'FontSize',36,'FontName','Times New Roman');
set(findall(gcf,'type','text'),'FontSize',36,'FontName','Times New Roman')
set(gcf, 'Color', 'w');
xlabel('Time', 'FontSize', 36,'FontName','Times New Roman');
ylabel('  RRInterval  MACD  Activity                           ', 'FontSize', 36,'FontName','Times New Roman');
set(gca,'ytick',[]);
columnlegend(2,h, legend_text,'Location', 'NorthWest'); 




%export_fig('C:\Users\smhssain\Desktop\drug_fig\paper\macd.pdf');
%export_fig('C:\Users\smhssain\Desktop\drug_fig\paper\macd.bmp');
%export_fig('C:\Users\smhssain\Desktop\drug_fig\paper\macd.jpg');
export_fig('C:\DataProcessingFramework_COC_M\Figures\macd.eps');

%saveas(hh,[G.DIR.DATA G.DIR.SEP 'figure' G.DIR.SEP pid '_' sid '.jpg']);
%saveas(hh,[G.DIR.DATA G.DIR.SEP 'figure_act' G.DIR.SEP pid '_' sid '.fig']);

return;

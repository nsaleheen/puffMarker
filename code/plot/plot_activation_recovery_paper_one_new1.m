function [h,legend_text]=plot_activation_recovery_paper_one_new1(G,pid,sid,wlarge,wsmall,field)
hh = figure();
scrsz = get(0,'ScreenSize');
set(hh,'Units','Pixels','Position',[1 1 scrsz(3) scrsz(4)]);%title(['pid=' pid ' sid=' sid],'FontSize',14);
hold on;
indir=[G.DIR.DATA G.DIR.SEP 'segment'];
infile=[pid '_' sid '_segment.mat'];
if exist([indir G.DIR.SEP infile], 'file') ~= 2
    close(hh);
    return;
end
load([indir G.DIR.SEP infile]);

%ylim([400,1600]);
%h(1)=plot_signal(P.rr.matlabtime,P.rr.sample,'g.',1,0); legend_text{1}='RR Interval';
h(1)=plot(P.rr.matlabtime,P.rr.sample,'g.','markersize',15); 
legend_text{1}='RR Interval';

hold on;
%h(3)=plot_signal(P.rr.avg.matlabtime,P.rr.avg.(['t' num2str(wsmall)]),'y-',2,0);
h(2)=plot_signal(P.rr.avg.matlabtime,P.rr.avg.(['t' num2str(wlarge)]),'r-',4,0);legend_text{2}='Moving Average(RR Interval)';
val=P.acl.avg.t60;
threshold=(prctile(P.acl.avg.t60,95)-prctile(P.acl.avg.t60,5))*0.35;
threshold=150*(threshold-min(val))/(max(val)-min(val));
val=150*(val-min(val))/(max(val)-min(val));
val60=150*(P.acl.avg.t60-min(P.acl.avg.t60))/(max(P.acl.avg.t60)-min(P.acl.avg.t60));
%val120=150*(P.acl.avg.t120.value-min(P.acl.avg120.value))/(max(P.acl.avg120.value)-min(P.acl.avg120.value));

%h(3)=plot_signal(P.acl.matlabtime,val,'g-',1,1000);legend_text{3}='varince of magnitude (accel)';
h(3)=plot_signal(P.acl.avg.matlabtime,val60,'b-',3,1400);legend_text{3}='Activity Indicator (Accel)';
%h(3)=plot_signal(P.acl.avg120.matlabtime,val120,'b-',1,1000);legend_text{3}='varince of magnitude (accel)';

h(4)=plot_signal([P.acl.matlabtime(1),P.acl.matlabtime(end)],[threshold,threshold],'r-.',3,1400);legend_text{4}='Activity Threshold';
%h(5)=plot_signal(P.rr.avg.matlabtime(P.rr.macd.MP1),P.rr.avg.t600(P.rr.macd.MP1),'go',8,0);legend_text{5}='Window Start';
%h(5)=plot_signal(P.rr.avg.matlabtime(P.rr.macd.LP1),P.rr.avg.t600(P.rr.macd.LP1),'ro',8,0);legend_text{5}='Window Start';

for i=1:length(P.rr.window.p1)
    stime=P.rr.avg.matlabtime(P.rr.window.p1(i));
    if i<length(P.rr.window.p1)
        etime=P.rr.avg.matlabtime(P.rr.window.p1(i+1));
    else         etime=P.rr.avg.matlabtime(P.rr.window.p2(i));
    end
    midtime=(stime+etime)/2;
    h(5)=plot_signal([stime,stime],[400,1700],'k:',2,0);
    legend_text{5}='Crossover Point';
    if i==9 || i==10
            h(7)=plot(midtime,1800,'r.','markersize',40);legend_text{6}='Cocaine window';
%            h(7)=plot_signal(midtime,1800,'ro',4,0);legend_text{6}='Cocaine window';
            
    else
    h(6)=plot(midtime,1800,'bx','markersize',15);legend_text{6}='Noncocaine window';
        
%    h(6)=plot_signal(midtime,1800,'bx',4,0);legend_text{6}='Noncocaine window';
    end
end



%coc_mark_lab=plot_adminmark(G,pid,sid,'formattedraw',[0,1000],50);
coc_mark=plot_pdamark(G,pid,sid);
legend_text{6}='Noncocaine Event';
legend_text{7}='Cocaine Event';
xx=legend(h,legend_text,'Interpreter', 'none');

%xlabel('Time','FontSize',20);
%ylabel('RR values','FontSize',20);
ylim([500,2800]);
time='02/22/2012 8:00:00';timestamp=convert_time_timestamp(G,time);t1=convert_timestamp_matlabtimestamp(G,timestamp);
time='02/22/2012 22:00:00';timestamp=convert_time_timestamp(G,time);t2=convert_timestamp_matlabtimestamp(G,timestamp);

xlim([t1,t2]);

set(0,'DefaultAxesFontSize', 36);
set(0,'DefaultTextFontSize', 36);

set(gca,'FontSize',36,'FontName','Times New Roman');
set(findall(gcf,'type','text'),'FontSize',36,'FontName','Times New Roman');
set(gcf, 'Color', 'w');
xlabel('Time', 'FontSize', 36,'FontName','Times New Roman');
ylabel('   RRInterval   Activity  Output                      ', 'FontSize', 36,'FontName','Times New Roman');
set(gca,'yticklabel',[]);
columnlegend(2,h, legend_text,'Location', 'NorthWest'); 

%saveas(hh,[G.DIR.DATA G.DIR.SEP 'figure' G.DIR.SEP pid '_' sid '.jpg']);
%{
if field==1
    if coc_mark==1
        temp=[G.DIR.DATA G.DIR.SEP 'figure_act\mark' G.DIR.SEP pid '_' sid '.jpg'];
        
    else
        if coc==0,
            temp=[G.DIR.DATA G.DIR.SEP 'figure_act\no' G.DIR.SEP pid '_' sid '.jpg'];
        elseif coc==1
            temp=[G.DIR.DATA G.DIR.SEP 'figure_act\cocaine' G.DIR.SEP pid '_' sid '.jpg'];
        else
            temp=[G.DIR.DATA G.DIR.SEP 'figure_act\notsure' G.DIR.SEP pid '_' sid '.jpg'];
        end
    end
else
    if coc_mark_lab==0
        temp=[G.DIR.DATA G.DIR.SEP 'figure_act\no' G.DIR.SEP pid '_' sid '.jpg'];
        
    else
        temp=[G.DIR.DATA G.DIR.SEP 'figure_act\cocaine' G.DIR.SEP pid '_' sid '.jpg'];
    end
end
saveas(hh,[G.DIR.DATA G.DIR.SEP 'figure_act' G.DIR.SEP pid '_' sid '.fig']);
temp=[G.DIR.DATA G.DIR.SEP 'figure_act' G.DIR.SEP pid '_' sid '.jpg'];
export_fig(temp);
%}
%close(hh);
export_fig('C:\DataProcessingFramework_COC_M\Figures\field_feb8.eps');

return;
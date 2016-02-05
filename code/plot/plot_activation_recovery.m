function plot_activation_recovery(G,pid,sid,wlarge,wsmall,field)
hh = figure();
scrsz = get(0,'ScreenSize');
set(hh,'Units','Pixels','Position',[1 1 scrsz(3) scrsz(4)]);title(['pid=' pid ' sid=' sid],'FontSize',14);
hold on;
indir=[G.DIR.DATA G.DIR.SEP 'segment'];
infile=[pid '_' sid '_segment.mat'];
if exist([indir G.DIR.SEP infile], 'file') ~= 2
    close(hh);
    return;
end
load([indir G.DIR.SEP infile]);

ylim([-200,1600]);
h(1)=plot_signal(P.rr.matlabtime,P.rr.sample,'b.',1,0); legend_text{1}='RR Interval';
%h(3)=plot_signal(P.rr.avg.matlabtime,P.rr.avg.(['t' num2str(wsmall)]),'y-',2,0);
h(2)=plot_signal(P.rr.avg.matlabtime,P.rr.avg.(['t' num2str(wlarge)]),'r-',2,0);legend_text{2}='Moving Average(10 minute)';
val=P.acl.avg.t60;
threshold=P.acl.avg.th60;
threshold=150*(threshold-min(val))/(max(val)-min(val));
val=150*(val-min(val))/(max(val)-min(val));
val60=150*(P.acl.avg.t60-min(P.acl.avg.t60))/(max(P.acl.avg.t60)-min(P.acl.avg.t60));

%h(3)=plot_signal(P.acl.matlabtime,val,'g-',1,1000);legend_text{3}='varince of magnitude (accel)';
h(3)=plot_signal(P.acl.avg.matlabtime,val60,'k-',1,1000);legend_text{3}='varince of magnitude (accel)';
%h(3)=plot_signal(P.acl.avg120.matlabtime,val120,'b-',1,1000);legend_text{3}='varince of magnitude (accel)';

h(4)=plot_signal([P.acl.matlabtime(1),P.acl.matlabtime(end)],[threshold,threshold],'r-',1,1000);legend_text{4}='Activity Threshold';
%h(5)=plot_signal(P.rr.avg.matlabtime(P.rr.macd.MP1),P.rr.avg.t600(P.rr.macd.MP1),'go',8,0);legend_text{5}='Window Start';
%h(5)=plot_signal(P.rr.avg.matlabtime(P.rr.macd.LP1),P.rr.avg.t600(P.rr.macd.LP1),'ro',8,0);legend_text{5}='Window Start';

for i=1:length(P.rr.window.p1)
    p1=P.rr.window.p1(i);p2=P.rr.window.r2(i);
    v1=P.rr.window.v1(i);v2=P.rr.window.r1(i);

    if P.rr.window.mark(i)<0, 
        h(6)=plot_signal(P.rr.avg.matlabtime(p1),P.rr.avg.t600(p1),'kx',4,0);
        h(7)=plot_signal(P.rr.avg.matlabtime(p2),P.rr.avg.t600(p2),'kx',4,0);
        continue;
    end;
    if P.rr.window.mark(i)~=0,
        h(5)=plot_signal(P.rr.avg.matlabtime(p1),P.rr.avg.t600(p1),'go',8,0);legend_text{5}='Window Start';
        h(6)=plot_signal(P.rr.avg.matlabtime(p2),P.rr.avg.t600(p2),'ro',8,0);legend_text{6}='Window End';
        h(7)=plot_signal(P.rr.avg.matlabtime(v1),P.rr.avg.t600(v1),'co',8,0);legend_text{7}='Activation End';
        h(8)=plot_signal(P.rr.avg.matlabtime(v2),P.rr.avg.t600(v2),'mo',8,0);legend_text{8}='Recovery Start';
        
    elseif P.rr.window.mark(i)==0
        h(5)=plot_signal(P.rr.avg.matlabtime(p1),P.rr.avg.t600(p1),'go',4,0);legend_text{5}='Window Start';
        h(6)=plot_signal(P.rr.avg.matlabtime(p2),P.rr.avg.t600(p2),'ro',4,0);legend_text{6}='Window End';
        h(7)=plot_signal(P.rr.avg.matlabtime(v1),P.rr.avg.t600(v1),'co',4,0);legend_text{7}='Activation End';
        h(8)=plot_signal(P.rr.avg.matlabtime(v2),P.rr.avg.t600(v2),'mo',4,0);legend_text{8}='Recovery Start';
    end
end



coc_mark_lab=plot_adminmark(G,pid,sid,'formattedraw',[0,1000],50);
coc_mark=plot_pdamark(G,pid,sid);

set(gca,'FontSize',14);
%legend(h,legend_text,'Interpreter', 'none');
xlabel('Time','FontSize',14);
ylabel('RR values','FontSize',14);
%saveas(hh,[G.DIR.DATA G.DIR.SEP 'figure' G.DIR.SEP pid '_' sid '.jpg']);
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
%close(hh);

return;

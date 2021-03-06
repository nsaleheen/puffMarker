function [h,legend_text]=plot_activation_recovery_sandiago_one(G,pid,sid,wlarge,wsmall,field)
hh = figure();
scrsz = get(0,'ScreenSize');
set(hh,'Units','Pixels','Position',[1 1 scrsz(3) scrsz(4)]);%title(['pid=' pid ' sid=' sid],'FontSize',14);
hold on;
indir=[G.DIR.DATA G.DIR.SEP 'preprocess'];
infile=[pid '_' sid '_preprocess.mat'];
if exist([indir G.DIR.SEP infile], 'file') ~= 2
    close(hh);
    return;
end
load([indir G.DIR.SEP infile]);
indir=[G.DIR.DATA G.DIR.SEP 'basicfeature'];
infile=[pid '_' sid '_basicfeature.mat'];
load([indir G.DIR.SEP infile]);
ylim([500,2000]);
h(1)=plot_signal(B.sensor{2}.matlabtime,B.sensor{2}.sample,'g-',1,-2600); legend_text{1}='RR Interval';
%h(1)=plot_signal(P.rr.matlabtime,P.rr.sample,'g.',1,0); legend_text{1}='RR Interval';
%h(3)=plot_signal(P.rr.avg.matlabtime,P.rr.avg.(['t' num2str(wsmall)]),'y-',2,0);
h(2)=plot_signal(B.sensor{1}.matlabtime,B.sensor{1}.sample/9,'b-',1,950);legend_text{2}='Resp..';
%h(2)=plot_signal(P.rr.avg.matlabtime,P.rr.avg.(['t' num2str(wlarge)]),'r-',2,0);legend_text{2}='Moving Average(RR Interval)';
val=P.acl.avg60.value;
threshold=(prctile(P.acl.avg60.value,95)-prctile(P.acl.avg60.value,5))*0.35;
threshold=150*(threshold-min(val))/(max(val)-min(val));
val=150*(val-min(val))/(max(val)-min(val));
val60=150*(P.acl.avg60.value-min(P.acl.avg60.value))/(max(P.acl.avg60.value)-min(P.acl.avg60.value));
val120=150*(P.acl.avg120.value-min(P.acl.avg120.value))/(max(P.acl.avg120.value)-min(P.acl.avg120.value));

%h(3)=plot_signal(P.acl.matlabtime,val,'g-',1,1000);legend_text{3}='varince of magnitude (accel)';
h(3)=plot_signal(B.sensor{4}.matlabtime(1:length(B.sensor{4}.sample)),B.sensor{4}.sample*14,'k-',1,1530);%legend_text{3}='Activity Indicator (ACCEL)';
%h(3)=plot_signal(P.acl.avg60.matlabtime,val60,'k-',2,1800);legend_text{3}='Activity Indicator (ACCEL)';
%h(3)=plot_signal(P.acl.avg120.matlabtime,val120,'b-',1,1000);legend_text{3}='varince of magnitude (accel)';

%h(4)=plot_signal([P.acl.matlabtime(1),P.acl.matlabtime(end)],[threshold,threshold],'r-',2,1800);legend_text{4}='Activity Threshold';
%h(5)=plot_signal(P.rr.avg.matlabtime(P.rr.macd.MP1),P.rr.avg.t600(P.rr.macd.MP1),'go',8,0);legend_text{5}='Window Start';
%h(5)=plot_signal(P.rr.avg.matlabtime(P.rr.macd.LP1),P.rr.avg.t600(P.rr.macd.LP1),'ro',8,0);legend_text{5}='Window Start';


%coc_mark_lab=plot_adminmark(G,pid,sid,'formattedraw',[0,2000],500);
%coc_mark=plot_pdamark(G,pid,sid,'formattedraw');
%legend_text{6}='Noncocaine Event';
%legend_text{7}='Cocaine Event';
ylim([400,3000]);
x(1)=734975.58925;
x(2)=734975.58948;
xlim(x);

set(gca,'FontSize',20);
%xx=legend(h,legend_text,'Interpreter', 'none');

%set(xx,'FontSize',24);
xlabel('Time ->','FontSize',20);
ylabel('                            ECG        Resp.     Accl.                                                                   ','FontSize',20);
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

return;

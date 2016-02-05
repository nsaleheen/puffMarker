function [hh,legend_text]=plot_rr_avg_threshold_macd_recovery_cocaine_activity(G,pid,sid)
hh = figure();
legend_text=[];
title(['pid=' pid ' sid=' sid]);
scrsz = get(0,'ScreenSize');
set(hh,'Units','Pixels','Position',[1 1 scrsz(3) scrsz(4)]);%title(['pid=' pid ' sid=' sid],'FontSize',14);
hold on;
indir=[G.DIR.DATA G.DIR.SEP 'segment'];
infile=[pid '_' sid '_segment.mat'];
load([indir G.DIR.SEP infile]);

if ~isempty(P.rr.avg.matlabtime)
    h(1)=plot_signal(P.rr.matlabtime,P.rr.sample,'g.',1);legend_text{1}='RR Interval';
    h(2)=plot_signal(P.rr.avg.matlabtime,P.rr.avg.t600,'b-',2);legend_text{2}='Moving Average (RR Interval)';
end
if ~isempty(P.acl.avg.matlabtime)
    h(3)=plot_signal(P.acl.avg.matlabtime,P.acl.avg.t60*50+1200,'g-',1);legend_text{3}='Activity Indicator(ACCEL)';
    h(4)=plot_signal([P.acl.avg.matlabtime(1),P.acl.avg.matlabtime(end)],[P.acl.avg.th60,P.acl.avg.th60]*50+1200,'r-',2);legend_text{4}='Activity Threshold';
end

type=0;
if ~isempty(P.rr.matlabtime) && ~isempty(P.rr.avg.matlabtime) && ~isempty(P.rr.window.p1) && ~isempty(P.rr.window.v1)
    for i=1:length(P.rr.window.p1)
        if P.rr.window.p1(i)==-1 || P.rr.window.v1(i)==-1 || P.rr.window.v2(i)==-1 || P.rr.window.p2(i)==-1, continue;end;
        stime=convert_timestamp_matlabtimestamp(G,P.rr.avg.timestamp(P.rr.window.p1(i)));
        h(5)=plot_signal([stime,stime],[500,2200],'k--',2);legend_text{5}='Crossover Point';
        if P.rr.window.mark(i)==1,
            st=convert_timestamp_matlabtimestamp(G,P.rr.avg.timestamp(P.rr.window.p1(i)));
            et=convert_timestamp_matlabtimestamp(G,P.rr.avg.timestamp(P.rr.window.p2(i)));
            plot_signal([st,et],[500,2000],'r-',8);
            fprintf('%s,%s,%.0f,%.0f,%.0f,%.0f\n',pid,sid,P.rr.avg.timestamp(P.rr.window.p1(i)),P.rr.avg.timestamp(P.rr.window.v1(i)),P.rr.avg.timestamp(P.rr.window.v2(i)),P.rr.avg.timestamp(P.rr.window.p2(i)));

        end    
    end
    
end


coc_mark_lab=plot_adminmark(G,pid,sid,'formattedraw',[450,2000],1200);
coc_mark=plot_pdamark(G,pid,sid);
%saveas(hh,[G.DIR.DATA G.DIR.SEP 'figure_1' G.DIR.SEP pid '_' sid '.fig']);
if type==1
temp=[G.DIR.DATA G.DIR.SEP 'figure_all\cocaine' G.DIR.SEP pid '_' sid '.jpg'];
else
    temp=[G.DIR.DATA G.DIR.SEP 'figure_all\noncocaine' G.DIR.SEP pid '_' sid '.jpg'];
end
%export_fig(temp);
%close(hh);

return;

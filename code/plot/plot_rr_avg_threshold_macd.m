function [h,legend_text]=plot_rr_avg_threshold_macd(G,pid,sid)
hh = figure();
title(['pid=' pid ' sid=' sid]);
scrsz = get(0,'ScreenSize');
set(hh,'Units','Pixels','Position',[1 1 scrsz(3) scrsz(4)]);%title(['pid=' pid ' sid=' sid],'FontSize',14);
hold on;
indir=[G.DIR.DATA G.DIR.SEP 'segment'];
infile=[pid '_' sid '_segment.mat'];
load([indir G.DIR.SEP infile]);
if ~isempty(P.rr.matlabtime)
    h(1)=plot_signal(P.rr.matlabtime,P.rr.sample,'g.',1);legend_text{1}='RR Interval';
    h(2)=plot_signal(P.rr.avg.matlabtime,P.rr.avg.t30,'b-',1);legend_text{1}='RR Interval';
end
if ~isempty(P.acl.avg.matlabtime)
    h(1)=plot_signal(P.acl.avg.matlabtime,P.acl.avg.t30*50+1200,'g-',1);legend_text{1}='RR Interval';
    h(1)=plot_signal([P.acl.avg.matlabtime(1),P.acl.avg.matlabtime(end)],[P.acl.avg.th30,P.acl.avg.th30]*50+1200,'r-',1);legend_text{1}='RR Interval';
end
if ~isempty(P.rr.matlabtime) & ~isempty(P.rr.avg.matlabtime) & ~isempty(P.rr.window.p1) & ~isempty(P.rr.window.v1)
    for i=1:min(length(P.rr.window.p1),length(P.rr.window.v1))
        disp([num2str(P.rr.window.p1(i)) '  ' num2str(P.rr.window.v1(i))]);
        if P.rr.window.v1(i)==-1 || P.rr.window.p1(i)==-1, continue, end;
        stime=P.rr.avg.matlabtime(P.rr.window.p1(i));
        etime=P.rr.avg.matlabtime(P.rr.window.v1(i));
        if P.rr.window.mark(i)<0
            p=patch([stime etime etime stime],[400 400 1700 1700],[.2,0.2,0.2],'edgecolor','none');
        elseif P.rr.window.mark(i)>0
            p=patch([stime etime etime stime],[400 400 1700 1700],[1,0.4,0.4],'edgecolor','none');
        else
            p=patch([stime etime etime stime],[400 400 1700 1700],[1,0.7,0.7],'edgecolor','none');
        end
        %    set(p,'FaceAlpha',0.5);
        %    fill([stime etime etime stime], [400 400 1700 1700], 'r', 'FaceAlpha', 0.4);
        %    h(5)=plot_signal([stime,stime],[400,1700],'k-',2,0);
        %    legend_text{5}='Crossover Point';
    end
    
    
    for i=1:length(P.rr.window.p2)
        stime=P.rr.avg.matlabtime(P.rr.window.v2(i));
        etime=P.rr.avg.matlabtime(P.rr.window.p2(i));
        if P.rr.window.mark(i)<0
            p=patch([stime etime etime stime],[400 400 1700 1700],[.2,0.2,0.2],'edgecolor','none');
        elseif P.rr.window.mark(i)>0
            p=patch([stime etime etime stime],[400 400 1700 1700],[0.4,1,0.4],'edgecolor','none');
        else
            p=patch([stime etime etime stime],[400 400 1700 1700],[0.7,1,0.7],'edgecolor','none');
        end
    end
    for i=1:length(P.rr.window.p2)
        if P.rr.window.mark(i)>0
            
            stime=P.rr.avg.matlabtime(P.rr.window.r1(i));
            etime=P.rr.avg.matlabtime(P.rr.window.r2(i));
            p=patch([stime etime etime stime],[400 400 1200 1200],[0.2,1,0.2],'edgecolor','none');
        end
        
        %    set(p,'FaceAlpha',0.5);
        
        %    h(5)=plot_signal([stime,stime],[400,1700],'b-',2,0);
        %    legend_text{5}='Crossover Point';
    end
end
%{
for i=1:length(P.rr.window.v1)
    stime=P.rr.avg.matlabtime(P.rr.window.v1(i));
    h(5)=plot_signal([stime,stime],[400,1700],'r-',2,0);
%    legend_text{5}='Crossover Point';
end
for i=1:length(P.rr.window.v2)
    stime=P.rr.avg.matlabtime(P.rr.window.v2(i));
    h(5)=plot_signal([stime,stime],[400,1700],'m-',2,0);
%    legend_text{5}='Crossover Point';
end
%}

coc_mark_lab=plot_adminmark(G,pid,sid,'formattedraw',[450,2000],1200);
coc_mark=plot_pdamark(G,pid,sid,'formattedraw');
saveas(hh,[G.DIR.DATA G.DIR.SEP 'figure_1' G.DIR.SEP pid '_' sid '.fig']);
temp=[G.DIR.DATA G.DIR.SEP 'figure_1' G.DIR.SEP pid '_' sid '.jpg'];
export_fig(temp);
%close(hh);

return;

function [h,legend_text]=plot_rr_avg_threshold_macd_recovery_general(G,pid,sid)
hh = figure();
title(['pid=' pid ' sid=' sid]);
scrsz = get(0,'ScreenSize');
set(hh,'Units','Pixels','Position',[1 1 scrsz(3) scrsz(4)]);%title(['pid=' pid ' sid=' sid],'FontSize',14);
hold on;
indir=[G.DIR.DATA G.DIR.SEP 'segment'];
infile=[pid '_' sid '_segment.mat'];
load([indir G.DIR.SEP infile]);

if ~isempty(P.rr.avg.matlabtime)
    h(1)=plot_signal(P.rr.matlabtime,P.rr.sample,'g.',1);legend_text{1}='RR Interval';
    h(2)=plot_signal(P.rr.avg.matlabtime,P.rr.avg.t60,'b-',1);legend_text{1}='RR Interval';
end
if ~isempty(P.acl.avg.matlabtime)
    h(1)=plot_signal(P.acl.avg.matlabtime,P.acl.avg.t60*50+1200,'g-',1);legend_text{1}='RR Interval';
    h(1)=plot_signal([P.acl.avg.matlabtime(1),P.acl.avg.matlabtime(end)],[P.acl.avg.th30,P.acl.avg.th30]*50+1200,'r-',1);legend_text{1}='RR Interval';
end
type=0;
if ~isempty(P.rr.matlabtime) && ~isempty(P.rr.avg.matlabtime) && ~isempty(P.rr.window.p1) && ~isempty(P.rr.window.v1)
    for i=1:length(P.rr.window.p1)
        if P.rr.window.p1(i)==-1 || P.rr.window.v1(i)==-1 || P.rr.window.v2(i)==-1 || P.rr.window.p2(i)==-1, continue;end;
        if P.rr.window.mark(i)<0
            stime=P.rr.avg.matlabtime(P.rr.window.p1(i));
            etime=P.rr.avg.matlabtime(P.rr.window.p2(i));    
            p=patch([stime etime etime stime],[400 400 1700 1700],[.5,0.5,0.5],'edgecolor','none');        
        elseif P.rr.window.mark(i)>0            
%            stime=P.rr.avg.matlabtime(P.rr.window.p1(i));
%            etime=P.rr.avg.matlabtime(P.rr.window.v1(i));
%            if a1(i)==-1, continue;end;
%            stime=P.rr.avg.matlabtime(P.rr.window.a1(i));
%            etime=P.rr.avg.matlabtime(P.rr.window.a2(i));

%            p=patch([stime etime etime stime],[400 400 1700 1700],[1,0.4,0.4],'edgecolor','none');            
            stime=P.rr.avg.matlabtime(P.rr.window.v2(i));
            etime=P.rr.avg.matlabtime(P.rr.window.p2(i));
            p=patch([stime etime etime stime],[400 400 1700 1700],[0.4,1,1],'edgecolor','none');
            plot_signal(stime,P.rr.avg.t60(P.rr.window.v2(i)),'r*',5);
            plot_signal(etime,P.rr.avg.t60(P.rr.window.p2(i)),'r*',5);
            stime=P.rr.avg.matlabtime(P.rr.window.p1(i));
            etime=P.rr.avg.matlabtime(P.rr.window.v1(i));
            type=1;

            plot_signal(stime,P.rr.avg.t60(P.rr.window.p1(i)),'k*',5);
            plot_signal(etime,P.rr.avg.t60(P.rr.window.v1(i)),'k*',5);

        else
%            stime=P.rr.avg.matlabtime(P.rr.window.p1(i));
%            etime=P.rr.avg.matlabtime(P.rr.window.v1(i));
%            if a1(i)==-1, continue;end;
%            stime=P.rr.avg.matlabtime(P.rr.window.a1(i));
%            etime=P.rr.avg.matlabtime(P.rr.window.a2(i));
            
%            p=patch([stime etime etime stime],[400 400 1700 1700],[1,0.7,0.7],'edgecolor','none');
            stime=P.rr.avg.matlabtime(P.rr.window.v2(i));
            etime=P.rr.avg.matlabtime(P.rr.window.p2(i));
            plot_signal(stime,P.rr.avg.t60(P.rr.window.v2(i)),'r*',2);
            plot_signal(etime,P.rr.avg.t60(P.rr.window.p2(i)),'r*',2);
            p=patch([stime etime etime stime],[400 400 1700 1700],[1,1,0.2],'edgecolor','none');                
            stime=P.rr.avg.matlabtime(P.rr.window.p1(i));
            etime=P.rr.avg.matlabtime(P.rr.window.v1(i));
            plot_signal(stime,P.rr.avg.t60(P.rr.window.p1(i)),'k*',2);
            plot_signal(etime,P.rr.avg.t60(P.rr.window.v1(i)),'k*',2);

            
        end        
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

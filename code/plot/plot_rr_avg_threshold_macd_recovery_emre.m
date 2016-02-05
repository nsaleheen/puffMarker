function [h,legend_text]=plot_rr_avg_threshold_macd_recovery_emre(G,pid,sid,C,N)
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
    h(2)=plot_signal(P.rr.avg.matlabtime,P.rr.avg.t30,'b-',1);legend_text{1}='RR Interval';
end
if ~isempty(P.acl.avg.matlabtime)
    h(1)=plot_signal(P.acl.avg.matlabtime,P.acl.avg.t60*50+1200,'g-',1);legend_text{1}='RR Interval';
    h(1)=plot_signal([P.acl.avg.matlabtime(1),P.acl.avg.matlabtime(end)],[P.acl.avg.th30,P.acl.avg.th30]*50+1200,'r-',1);legend_text{1}='RR Interval';
end

for i=1:length(C)
            hold on;
            stime=convert_timestamp_matlabtimestamp(G,C{i}.window_time(3));
            etime=convert_timestamp_matlabtimestamp(G,C{i}.window_time(4));
           p=patch([stime etime etime stime],[400 400 1700 1700],[0.2,1,1],'edgecolor','none');   
            
            pt1= P.rr.avg.timestamp==C{i}.window_time(3);
            pt2= P.rr.avg.timestamp==C{i}.window_time(4);            
            plot_signal(stime,P.rr.avg.t30(pt1),'mo',4);
            plot_signal(etime,P.rr.avg.t30(pt2),'mo',4);
 
            stime=convert_timestamp_matlabtimestamp(G,C{i}.window_time(1));
            etime=convert_timestamp_matlabtimestamp(G,C{i}.window_time(2));            
           p=patch([stime etime etime stime],[400 400 1700 1700],[0.5,1,1],'edgecolor','none');   
 
            pt1= P.rr.avg.timestamp==C{i}.window_time(1);
            pt2= P.rr.avg.timestamp==C{i}.window_time(2);            
            plot_signal(stime,P.rr.avg.t30(pt1),'yo',4);
            plot_signal(etime,P.rr.avg.t30(pt2),'yo',4);  
end
for i=1:length(N)
            stime=convert_timestamp_matlabtimestamp(G,N{i}.window_time(3));
            etime=convert_timestamp_matlabtimestamp(G,N{i}.window_time(4));
            p=patch([stime etime etime stime],[400 400 1700 1700],[1,0.2,1],'edgecolor','none');
            
            pt1= P.rr.avg.timestamp==N{i}.window_time(3);
            pt2= P.rr.avg.timestamp==N{i}.window_time(4);            
            plot_signal(stime,P.rr.avg.t30(pt1),'ro',4);
            plot_signal(etime,P.rr.avg.t30(pt2),'ro',4);

            stime=convert_timestamp_matlabtimestamp(G,N{i}.window_time(1));
            etime=convert_timestamp_matlabtimestamp(G,N{i}.window_time(2));            
            p=patch([stime etime etime stime],[400 400 1700 1700],[1,0.4,1],'edgecolor','none');            
            pt1= P.rr.avg.timestamp==N{i}.window_time(1);
            pt2= P.rr.avg.timestamp==N{i}.window_time(2);            
            plot_signal(stime,P.rr.avg.t30(pt1),'ko',4);
            plot_signal(etime,P.rr.avg.t30(pt2),'ko',4);  
            
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
saveas(hh,[G.DIR.DATA G.DIR.SEP 'figure_2' G.DIR.SEP pid '_' sid '.fig']);
temp=[G.DIR.DATA G.DIR.SEP 'figure_2' G.DIR.SEP pid '_' sid '.jpg'];
export_fig(temp);
%close(hh);

return;

function [h,legend_text]=plot_rr_avg_threshold(G,pid,sid,MODEL)
hh = figure();
scrsz = get(0,'ScreenSize');
set(hh,'Units','Pixels','Position',[1 1 scrsz(3) scrsz(4)]);%title(['pid=' pid ' sid=' sid],'FontSize',14);
hold on;
indir=[G.DIR.DATA G.DIR.SEP 'new_preprocess'];
infile=[pid '_' sid '_preprocess.mat'];
load([indir G.DIR.SEP infile]);
h(1)=plot_signal(P.rr.matlabtime,P.rr.sample,'g.',1);legend_text{1}='RR Interval';
h(2)=plot_signal(P.rr.avg.matlabtime,P.rr.avg.t120,'b-',1);legend_text{1}='RR Interval';
h(3)=plot_signal(P.rr.avg.matlabtime,P.rr.avg.t600,'r-',1);legend_text{1}='RR Interval';
h(1)=plot_signal(P.acl.matlabtime,P.acl.value*50+1200,'g-',1);legend_text{1}='RR Interval';
h(1)=plot_signal(P.acl.avg.matlabtime,P.acl.avg.t10*50+1200,'b-',1);legend_text{1}='RR Interval';
h(1)=plot_signal(P.acl.avg.matlabtime,P.acl.avg.t30*50+1200,'r-',1);legend_text{1}='RR Interval';

h(1)=plot_signal([P.acl.avg.matlabtime(1),P.acl.avg.matlabtime(end)],[P.acl.avg.th10,P.acl.avg.th60]*50+1200,'c-',1);legend_text{1}='RR Interval';
h(1)=plot_signal([P.acl.avg.matlabtime(1),P.acl.avg.matlabtime(end)],[P.acl.avg.th30,P.acl.avg.th120]*50+1200,'m-',1);legend_text{1}='RR Interval';


coc_mark_lab=plot_adminmark(G,pid,sid,'formattedraw',[450,2000],1200);
coc_mark=plot_pdamark(G,pid,sid,'formattedraw');

return;

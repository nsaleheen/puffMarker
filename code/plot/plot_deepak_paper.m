function plot_deepak_paper(G,pid,sid)
hh = figure();
scrsz = get(0,'ScreenSize');
set(hh,'Units','Pixels','Position',[1 1 scrsz(3) scrsz(4)]);%title('Lab Study Data','FontSize',20);
hold on;
indir=[G.DIR.DATA G.DIR.SEP 'segment'];
infile=[pid '_' sid '_segment.mat'];
if exist([indir G.DIR.SEP infile], 'file') ~= 2
    close(hh);
    return;
end
load([indir G.DIR.SEP infile]);
%[res,time]=deepak_result(G,pid,sid);
%save('p01_s01_deepak.mat','res','time');
load('p02_s06_deepak.mat');
res1=str2num(res(:));
time=time-(60*60)/(24*60*60);
hhh=0;h=[];
%hhh=hhh+1;h(hhh)=plot_signal(P.rr.matlabtime,P.rr.sample,'g.',1,0); legend_text{hhh}='RR Interval';
hhh=hhh+1;h(hhh)=plot(P.rr.matlabtime,P.rr.sample,'g.','markersize',15);
legend_text{hhh}='RR Interval';

val=P.acl.avg.t60;
threshold=(max(P.acl.avg.t60)-min(P.acl.avg.t60))/2;
threshold=150*(threshold-min(val))/(max(val)-min(val));
val=150*(val-min(val))/(max(val)-min(val));
val60=150*(P.acl.avg.t60-min(P.acl.avg.t60))/(max(P.acl.avg.t60)-min(P.acl.avg.t60));

%h(3)=plot_signal(P.acl.matlabtime,val,'g-',1,1000);legend_text{3}='varince of magnitude (accel)';
hhh=hhh+1;h(hhh)=plot_signal(P.acl.avg.matlabtime,val60,'b',3,1500);legend_text{hhh}='Activity Indicator(ACCEL)';
%h(3)=plot_signal(P.acl.avg30.matlabtime,val30,'b-',1,1000);legend_text{3}='varince of magnitude (accel)';

hhh=hhh+1;h(hhh)=plot_signal([P.acl.matlabtime(1),P.acl.matlabtime(end)],[threshold,threshold],'r-.',3,1500);legend_text{hhh}='Activity Threshold';
ind=find(res=='1');
hhh=hhh+1;
h(hhh)=plot(time(ind),res(ind)+1850,'r.','markersize',20);legend_text{hhh}='Cocaine Cycle';
ind=find(res=='0');
hhh=hhh+1;
h(hhh)=plot(time(ind),res(ind)+1800,'bx','markersize',15);
%plot_signal(time(ind),res(ind),'b.',1,1800);
legend_text{hhh}='Non Cocaine Cycle';

%plot_signal(time,res1,'k-',1,1800,50);
ylim([400,2500]);
time='04/16/2012 11:00:00';timestamp=convert_time_timestamp(G,time);t1=convert_timestamp_matlabtimestamp(G,timestamp);
time='04/16/2012 16:00:00';timestamp=convert_time_timestamp(G,time);t2=convert_timestamp_matlabtimestamp(G,timestamp);
coc_mark_lab=plot_adminmark(G,pid,sid,'formattedraw',[500, 2000],1200);
%time='05/17/2012 10:30:00';timestamp=convert_time_timestamp(G,time);t1=convert_timestamp_matlabtimestamp(G,timestamp);
%time='05/17/2012 15:30:00';timestamp=convert_time_timestamp(G,time);t2=convert_timestamp_matlabtimestamp(G,timestamp);
xlim([t1,t2]);
%set(gca,'FontSize',20);
%legend(h,legend_text,'Interpreter', 'none');
%^xlabel('Time','FontSize',20);
set(0,'DefaultAxesFontSize', 36);
set(0,'DefaultTextFontSize', 36);

set(gca,'FontSize',36,'FontName','Times New Roman');
set(findall(gcf,'type','text'),'FontSize',36,'FontName','Times New Roman')
set(gcf, 'Color', 'w');
set(gca,'yticklabel',[]);
xlabel('Time', 'FontSize', 36,'FontName','Times New Roman');

ylabel('    RR Interval       Activity   Output           ', 'FontSize', 36,'FontName','Times New Roman');
columnlegend(3,h, legend_text,'Location', 'NorthWest'); 
export_fig('C:\DataProcessingFramework_COC_M\Figures\deepak_feb8.eps');

%export_fig('C:\Users\smhssain\Desktop\drug_fig\paper\deepak.bmp');
%export_fig('C:\Users\smhssain\Desktop\drug_fig\paper\deepak.pdf');
%export_fig('C:\Users\smhssain\Desktop\drug_fig\paper\deepak.eps');
%export_fig('C:\Users\smhssain\Desktop\drug_fig\paper\deepak.jpg');

%saveas(hh,[G.DIR.DATA G.DIR.SEP 'figure' G.DIR.SEP pid '_' sid '.jpg']);
%saveas(hh,[G.DIR.DATA G.DIR.SEP 'figure_act' G.DIR.SEP pid '_' sid '.fig']);
return;
end
function [res,time]=deepak_result(G,pid,sid)
[N,time]=deepak_get_feature_day(G,pid,sid,'deepak');
featurenames=[];
for i=1:100,        featurenames{i}=['s' num2str(i) ','];end
featurenames{101}='qt';featurenames{102}='qtc';featurenames{103}='pr';featurenames{104}='qrs';featurenames{105}='th';
categorynames{1}='c';categorynames{2}='n';
features=N;
NN=(cellstr(char((zeros(1,size(N,1))+'?')')));
categories=NN;
write_arff([pid '_' sid] ,featurenames,categorynames,features,categories);
TestSVM(pid,[pid '_' sid]);
[b,s,res]=Results([pid '_' sid '_output_SMO'],'n','c');

end
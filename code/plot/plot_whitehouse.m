function plot_whitehouse(G,pid,sid,f,s,t)
figure;
h=[];
title('Lab Study Data','FontSize',16);
hold on;
indir=[G.DIR.DATA G.DIR.SEP 'preprocess'];
infile=[pid '_' sid '_preprocess.mat'];
load([indir G.DIR.SEP infile]);
indir=[G.DIR.DATA G.DIR.SEP 'formatteddata'];
infile=[pid '_' sid '_frmtdata.mat'];
load([indir G.DIR.SEP infile]);

indir=[G.DIR.DATA G.DIR.SEP 'feature'];
infile=['field_' pid '_' sid '_act10_feature.mat'];
load([indir G.DIR.SEP infile]);


load('all_hand.mat');
%indir=[G.DIR.DATA G.DIR.SEP 'basicfeature'];
%infile=[pid '_' sid '_' G.FILE.BASICFEATURE_MATNAME];
%load([indir G.DIR.SEP infile]);

TYPE=G.AVG;
h(1)=plot_signal(P.rr.matlabtime,P.rr.sample,'b.',1,0);
legend_text{1}='RR Interval';

%h(2)=plot_signal(P.rr.smoothtime,P.rr.t3600{G.P95},'y-',2,0);
%legend_text{2}='95th Percentile (60 Minutes)';

h(2)=plot_signal(P.rr.smoothtime,P.rr.t600{TYPE},'r-',2,0); 
legend_text{2}='Moving Average (10 Minutes)';
time=[];val=[];
for i=1:length(F.window)
    if F.window(i).feature{4}.quality~=0, continue;end;
    time(end+1)=F.window(i).end_matlabtime;
    val(end+1)=F.window(i).feature{4}.value{30};
end
k=prctile(val,98);
val(find(val>k))=k;
val=150*(val-min(val))/(max(val)-min(val));
h(3)=plot_signal(time,val,'g-',1,1400);
%h(3)=plot_signal(P.sensor{G.SENSOR.R_ACLXID}.matlabtime,P.sensor{G.SENSOR.R_ACLXID}.sample,'g-',1,1400);
legend_text{3}='Accelerometer (Variance of Magnitude)';      


%{
data=findfile_pid_sid_dir(G,pid,sid,'formattedraw');

if isfield(data,'adminmark') && isfield(data.adminmark,'matlabtime')
    xmin=min(data.adminmark.matlabtime);
end
if isfield(data,'pdamark') && isfield(data.pdamark,'matlabtime')
    xmin=min(data.pdamark.matlabtime);
end

%xlim([xmin-datenum(0,0,0,1,0,0), xmin+datenum(0,0,0,4,0,0)]);
hold on;
%}
%plot_labstudymark(G,pid,sid,'formattedraw');
plot_adminmark(G,pid,sid,'formattedraw',[400,2000]);
ylim([400,2000]);
plot_pdamark(G,pid,sid,'formattedraw');
set(gca,'FontSize',16);
legend(h,legend_text,'Interpreter', 'none');
xlabel('Time','FontSize',16);
ylabel('Magnitude','FontSize',16);
return;

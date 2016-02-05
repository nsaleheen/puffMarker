function plot_recover_activity(G,pid,sid,A)

scrsz = get(0,'ScreenSize');
hh = figure();
set(hh,'Units','Pixels','Position',[1 1 scrsz(3) scrsz(4)]);title(['pid=' pid ' sid=' sid],'FontSize',14);
hold on;
indir=[G.DIR.DATA G.DIR.SEP INDIR1];
infile=[pid '_' sid '_preprocess.mat'];
if exist([indir G.DIR.SEP infile], 'file') ~= 2
    close(hh);
    return;
end
load([indir G.DIR.SEP infile]);

indir=[G.DIR.DATA G.DIR.SEP INDIR2];
infile=[MODEL.STUDYTYPE '_' pid '_' sid '_' MODEL.NAME '_' G.FILE.FEATURE_MATNAME];

if exist([indir G.DIR.SEP infile], 'file') ~= 2
    close(hh);
    return;
end
load([indir G.DIR.SEP infile]);

ylim([-200,1600]);
%indir=[G.DIR.DATA G.DIR.SEP 'basicfeature'];
%infile=[pid '_' sid '_' G.FILE.BASICFEATURE_MATNAME];
%load([indir G.DIR.SEP infile]);
h(1)=plot_signal(P.rr.matlabtime,P.rr.sample,'b.',1,0);
legend_text{1}='RR Interval';

h(2)=plot_signal(P.rr.avg.matlabtime,P.rr.avg.(['t' num2str(w)]),'r-',2,0);
legend_text{2}=['Moving Average (' num2str(w) ' seconds)'];
ind=P.rr.win_ind;
if length(ind)>0,
    h(6)=plot_signal(P.rr.avg.matlabtime(ind(1:2:end)),P.rr.avg.t600(ind(1:2:end)),'go',4,0);
    legend_text{6}='Start Window';
end
if length(ind)>1,
    h(7)=plot_signal(P.rr.avg.matlabtime(ind(2:2:end)),P.rr.avg.t600(ind(2:2:end)),'ro',4,0);
    legend_text{7}='End Window';
end
%{
if ~isempty(P.sensor{G.SENSOR.R_ACLXID}.sample)
    sample=P.sensor{G.SENSOR.R_ACLXID}.sample;
    x=prctile(sample,99); sample(sample>x)=x;
    x=prctile(sample,1); sample(sample<x)=x;
    
    sample=150*(sample-min(sample))/(max(sample)-min(sample));
    h(8)=plot_signal(P.sensor{G.SENSOR.R_ACLXID}.matlabtime,sample,'g-',1,1400);
    legend_text{8}=P.sensor{G.SENSOR.R_ACLXID}.NAME;
end
%}
time=[];val=[];
for i=1:length(F.window)
    if F.window(i).feature{4}.quality~=0, continue;end;
    time(end+1)=F.window(i).end_matlabtime;
    val(end+1)=F.window(i).feature{4}.value{30};
end
k=prctile(val,98);
val(find(val>k))=k;
val=150*(val-min(val))/(max(val)-min(val));
h(8)=plot_signal(time,val,'g-',1,1400);
%h(3)=plot_signal(P.sensor{G.SENSOR.R_ACLXID}.matlabtime,P.sensor{G.SENSOR.R_ACLXID}.sample,'g-',1,1400);
legend_text{8}='Accelerometer (Variance of Magnitude)';      

%plot_labstudymark(G,pid,sid,'formattedraw');
coc_mark_lab=plot_adminmark(G,pid,sid,'formattedraw',[-200,1500]);
coc_mark=plot_pdamark(G,pid,sid,'formattedraw');

set(gca,'FontSize',14);
%legend(h,legend_text,'Interpreter', 'none');
xlabel('Time','FontSize',14);
ylabel('RR values','FontSize',14);
%saveas(hh,[G.DIR.DATA G.DIR.SEP 'figure' G.DIR.SEP pid '_' sid '.jpg']);
if field==1
    if coc_mark==1
        temp=[G.DIR.DATA G.DIR.SEP 'figure\mark' G.DIR.SEP pid '_' sid '.jpg'];
        
    else
        if coc==0,
            temp=[G.DIR.DATA G.DIR.SEP 'figure\no' G.DIR.SEP pid '_' sid '.jpg'];
        elseif coc==1
            temp=[G.DIR.DATA G.DIR.SEP 'figure\cocaine' G.DIR.SEP pid '_' sid '.jpg'];
        else
            temp=[G.DIR.DATA G.DIR.SEP 'figure\notsure' G.DIR.SEP pid '_' sid '.jpg'];
        end
    end
else
    if coc_mark_lab==0
        temp=[G.DIR.DATA G.DIR.SEP 'figure\no' G.DIR.SEP pid '_' sid '.jpg'];
        
    else
        temp=[G.DIR.DATA G.DIR.SEP 'figure\cocaine' G.DIR.SEP pid '_' sid '.jpg'];
    end
end
saveas(hh,[G.DIR.DATA G.DIR.SEP 'figure' G.DIR.SEP pid '_' sid '.fig']);
export_fig(temp);
%close(hh);

return;

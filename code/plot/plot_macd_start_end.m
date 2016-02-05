function plot_macd_start_end(G,pid,sid,INDIR1,INDIR2,MODEL,w,field)

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

if field==1,
    load('urine.mat');
    if ~isempty(P.rr.matlabtime)
        date=P.rr.matlabtime(1);
        date_str=datestr(date,'mm/dd/yyyy');
        date_num=datenum(date_str);
        p=str2num(pid(2:end));
        ind=find([urine.pid]==p); if ~isempty(ind), ind1=find([urine(ind).date]==date_num);end;
        if isempty(ind1), coc=-1;cocaine='Not sure';elseif urine(ind(ind1(1))).cocaine==0, coc=0;cocaine='No'; else coc=1;cocaine='Yes';end;
        x=[pid ' ' sid ' ' date_str ' urine=' cocaine];
        title(x,'FontSize',14);
    end
end
ylim([-200,1600]);
%indir=[G.DIR.DATA G.DIR.SEP 'basicfeature'];
%infile=[pid '_' sid '_' G.FILE.BASICFEATURE_MATNAME];
%load([indir G.DIR.SEP infile]);
h(1)=plot_signal(P.rr.matlabtime,P.rr.sample,'b.',1,0);
legend_text{1}='RR Interval';

h(2)=plot_signal(P.rr.avg.matlabtime,P.rr.avg.(['t' num2str(w)]),'r-',2,0);
legend_text{2}=['Moving Average (' num2str(w) ' seconds)'];
h(3)=plot_signal(P.rr.macd.matlabtime,P.rr.macd.M1,'b-',2,0); legend_text{3}='MACD 1';
h(4)=plot_signal(P.rr.macd.matlabtime,P.rr.macd.M2,'r-',2,0);legend_text{4}='MACD 2';
h(5)=plot_signal([P.rr.macd.matlabtime(1),P.rr.macd.matlabtime(end)],[0,0],'k-',2,0);legend_text{5}='Middle Line';
%h(6)=plot_signal(P.rr.macd.matlabtime,P.rr.macd.M1-P.rr.macd.M2,'k-',2,0);legend_text{4}='MACD 2';
%{
ind=[];
start=P.rr.macd.pos(2:2:end);
endd=P.rr.macd.pos(1:2:end);
now=1;
%ind=P.rr.macd.pos;
%h(6)=plot_signal(P.rr.avg.matlabtime(ind),P.rr.avg.t600(ind),'yo',4,0);
ind=[];
while now<=length(start)
    while now<=length(start) & P.rr.macd.M1(start(now))<0, now=now+1;end
    sind=start(now);
    while now+1<=length(start) & P.rr.macd.M1(start(now+1))>0,
        sind=start(now);
        eind=endd(now+1);
        mx=max(P.rr.macd.M1(sind:eind));
        mn=min(P.rr.macd.M1(sind:eind));
        if mx>=0 & mn>=0, now=now+1;sind=start(now); continue;
        else, break;
        end;
        
        %    if P.rr.macd.M1(start(now+1))>0, now=now+1;end
    end
    if now<=length(start), ind(end+1)=sind;end;
    now=now+1;
    while now<=length(start)
        while now<=length(start) & P.rr.macd.M1(endd(now))<0, now=now+1;end
        if now<=length(start),
            eind=endd(now);
            mx=max(P.rr.macd.M1(sind:eind));
            mn=min(P.rr.macd.M1(sind:eind));
            if mx>0 & mn<0, ind(end+1)=eind;break;end;
            now=now+1;
        end
    end
    %    h(6)=plot_signal(P.rr.avg.matlabtime(ind(end-1:end)),P.rr.avg.t600(ind(end-1:end)),'co',4,0);
    
end
%{
for i=2:2:length(P.rr.macd.pos)-1
    sind=P.rr.macd.pos(i);
    eind=P.rr.macd.pos(i+1);
    mx=max(P.rr.macd.M1(sind:eind));
    mn=min(P.rr.macd.M1(sind:eind));
    if mn<0 & mx>0  & P.rr.macd.M1(sind)>=0 & P.rr.macd.M1(eind)>=0,
        ind(end+1)=sind;
        ind(end+1)=eind;
    end
end
%}
%}
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

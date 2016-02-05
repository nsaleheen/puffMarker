function main_monowar_smoking_A7_WRIST_LEFTRIGHT()
close all
clear all
G=config();
%G=config_run_monowar_Memphis_Smoking_Lab(G);tp='lab';
G=config_run_monowar_Memphis_Smoking(G);tp='field';
lr_id=fopen(['C:\Users\smh\Desktop\smoking_fig\orientation_leftright\' tp '_lr_count.csv'],'w');

PS_LIST=G.PS_LIST;
LR_LTIME=0;LR_RTIME=0;
LR_LCOUNT=0;LR_RCOUNT=0;
LR_LTIME_ALL=[]; LR_RTIME_ALL=[];
LR_LCOUNT_DAY=0;LR_RCOUNT_DAY=0;LR_DAY=0;

for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s\n',pid,sid);
        LR_DAY=LR_DAY+1;
        
        INDIR='preprocess_wrist1';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
        P=fix_wrist_leftright(G,P,10*60*1000,pid,sid);
        OUTDIR='preprocess_wrist2';outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];outfile=[pid '_' sid '_' OUTDIR '.mat'];if isempty(dir(outdir)), mkdir(outdir);end; save([outdir G.DIR.SEP outfile],'P');
        LR_LCOUNT=LR_LCOUNT+length(P.sensor{G.SENSOR.WL9_ACLYID}.LR.stime);
        LR_RCOUNT=LR_RCOUNT+length(P.sensor{G.SENSOR.WR9_ACLYID}.LR.stime);
        if ~isempty(P.sensor{G.SENSOR.WL9_ACLYID}.LR.stime), LR_LCOUNT_DAY=LR_LCOUNT_DAY+1;end;
        if ~isempty(P.sensor{G.SENSOR.WR9_ACLYID}.LR.stime), LR_RCOUNT_DAY=LR_RCOUNT_DAY+1;end;
        
        for i=1:length(P.sensor{G.SENSOR.WL9_ACLYID}.LR.stime),time=(P.sensor{G.SENSOR.WL9_ACLYID}.LR.etime(i)-P.sensor{G.SENSOR.WL9_ACLYID}.LR.stime(i))/(60*1000);LR_LTIME=LR_LTIME+time;LR_LTIME_ALL(end+1)=time;end
        for i=1:length(P.sensor{G.SENSOR.WR9_ACLYID}.LR.stime),time=(P.sensor{G.SENSOR.WR9_ACLYID}.LR.etime(i)-P.sensor{G.SENSOR.WR9_ACLYID}.LR.stime(i))/(60*1000);LR_RTIME=LR_RTIME+time;LR_RTIME_ALL(end+1)=time;end
%        plot_custom(G,pid,sid,'preprocess_wrist1','plot_svm_output',[],'smokinglabel','selfreport','orientation','bar',[-700,0,700]);
        fprintf(lr_id,'pid,%s,sid,%s,L_count,%d,L_time=%.2f minute,R_count,%d,R_time,%0.2f minute\n',pid,sid,LR_LCOUNT,LR_LTIME,LR_RCOUNT,LR_RTIME);
        fprintf('pid,%s,sid,%s,L_count,%d,L_time=%.2f minute,R_count,%d,R_time,%0.2f minute\n',pid,sid,LR_LCOUNT,LR_LTIME,LR_RCOUNT,LR_RTIME);
        
%        plot_custom(G,pid,sid,'preprocess_wrist2','plot_svm_output',[],'smokinglabel','selfreport','orientation','bar',[-700,0,700]);
    end
end
fclose(lr_id);
fprintf('day,%d,lday,%d,rday,%d\n',LR_DAY,LR_LCOUNT_DAY,LR_RCOUNT_DAY);
h=figure;hold on;hist(LR_LTIME_ALL,50);title('Left Hand');xlabel('Minutes');
saveas(h,['C:\Users\smh\Desktop\smoking_fig\orientation_leftright\' tp '_Left_leftright_duration.jpg']);
h=figure;hold on;hist(LR_RTIME_ALL,50);title('Right Hand');xlabel('Minutes');
saveas(h,['C:\Users\smh\Desktop\smoking_fig\orientation_leftright\' tp '_right_leftright_duration.jpg']);

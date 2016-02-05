function main_monowar_smoking_A6_WRIST_ORIENTATION()
close all
clear all
G=config();
%G=config_run_monowar_Memphis_Smoking_Lab(G);tp='lab';
G=config_run_monowar_Memphis_Smoking(G);tp='field';
ci_id=fopen(['C:\Users\smh\Desktop\smoking_fig\orientation_leftright\' tp 'field_ci_count.csv'],'w');

PS_LIST=G.PS_LIST;
CI_LTIME=0;CI_RTIME=0;
CI_LCOUNT=0;CI_RCOUNT=0;
CI_LTIME_ALL=[]; CI_RTIME_ALL=[];
CI_LCOUNT_DAY=0;CI_RCOUNT_DAY=0;CI_DAY=0;
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s\n',pid,sid);
        CI_DAY=CI_DAY+1;
        INDIR='preprocess_wrist';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
        P=fix_wrist_orientation(G,P,10*60*1000,pid,sid);
        OUTDIR='preprocess_wrist1';outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];outfile=[pid '_' sid '_' OUTDIR '.mat'];if isempty(dir(outdir)), mkdir(outdir);end; save([outdir G.DIR.SEP outfile],'P');
        CI_LCOUNT=CI_LCOUNT+length(P.sensor{G.SENSOR.WL9_ACLXID}.CI.stime);
        CI_RCOUNT=CI_RCOUNT+length(P.sensor{G.SENSOR.WR9_ACLXID}.CI.stime);
        if ~isempty(P.sensor{G.SENSOR.WL9_ACLXID}.CI.stime), CI_LCOUNT_DAY=CI_LCOUNT_DAY+1;end;
        if ~isempty(P.sensor{G.SENSOR.WR9_ACLXID}.CI.stime), CI_RCOUNT_DAY=CI_RCOUNT_DAY+1;end;
        
        for i=1:length(P.sensor{G.SENSOR.WL9_ACLXID}.CI.stime),time=(P.sensor{G.SENSOR.WL9_ACLXID}.CI.etime(i)-P.sensor{G.SENSOR.WL9_ACLXID}.CI.stime(i))/(60*1000);CI_LTIME=CI_LTIME+time;CI_LTIME_ALL(end+1)=time;end
        for i=1:length(P.sensor{G.SENSOR.WR9_ACLXID}.CI.stime),time=(P.sensor{G.SENSOR.WR9_ACLXID}.CI.etime(i)-P.sensor{G.SENSOR.WR9_ACLXID}.CI.stime(i))/(60*1000);CI_RTIME=CI_RTIME+time;CI_RTIME_ALL(end+1)=time;end
%        plot_custom(G,pid,sid,'preprocess_wrist1','plot_svm_output',[],'smokinglabel','selfreport','orientation','bar',[-700,0,700]);
        fprintf(ci_id,'pid,%s,sid,%s,L_count,%d,L_time=%.2f minute,R_count,%d,R_time,%0.2f minute\n',pid,sid,CI_LCOUNT,CI_LTIME,CI_RCOUNT,CI_RTIME);
        fprintf('pid,%s,sid,%s,L_count,%d,L_time=%.2f minute,R_count,%d,R_time,%0.2f minute\n',pid,sid,CI_LCOUNT,CI_LTIME,CI_RCOUNT,CI_RTIME);
    end
end
fclose(ci_id);
fprintf('day,%d,lday,%d,rday,%d\n',CI_DAY,CI_LCOUNT_DAY,CI_RCOUNT_DAY);
h=figure;hold on;hist(CI_LTIME_ALL,50);title('Left Hand');xlabel('Minutes');
saveas(h,['C:\Users\smh\Desktop\smoking_fig\orientation_leftright\' tp '_Left_orientation_duration.jpg']);
h=figure;hold on;hist(CI_RTIME_ALL,50);title('Right Hand');xlabel('Minutes');
saveas(h,['C:\Users\smh\Desktop\smoking_fig\orientation_leftright\' tp '_right_orientation_duration.jpg']);

disp('here');
end

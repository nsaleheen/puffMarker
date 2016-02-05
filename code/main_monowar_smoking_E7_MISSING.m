close all
clear all
G=config();
%G=config_run_monowar_Memphis_Smoking_Lab(G);
G=config_run_monowar_Memphis_Smoking(G);
PS_LIST=G.PS_LIST;
for pp=1:size(PS_LIST,1)
    pid=char(PS_LIST{pp,1});
    slist=PS_LIST{pp,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s\n',pid,sid);
%        plot_custom(G,pid,sid,'svm_output','plot_svm_output',[],'smokinglabel','map',[2,1],'selfreport','svm');
        INDIR='svm_output';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];load([indir G.DIR.SEP infile]);
        for i=1:length(P.selfreport{2}.timestamp)
            stime=P.selfreport{2}.timestamp(i)-15*60*1000;
            etime=P.selfreport{2}.timestamp(i)+10*60*1000;
            flag=0;
            for ids=[G.SENSOR.R_RIPID,G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_GYRZID, G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_GYRZID]
                size=length(find(P.sensor{ids}.timestamp>=stime & P.sensor{ids}.timestamp<=etime));
                tot=G.SENSOR.ID(ids).FREQ*(etime-stime)/(1000);
                if tot*0.7>size, flag=1;break;end;
            end
            fprintf('pid=%s sid=%s episode=%d valid=%d\n',pid,sid,i,flag);
            P.selfreport{2}.valid(i)=flag;
        end
        OUTDIR='svm_output';outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];outfile=[pid '_' sid '_' OUTDIR '.mat'];if isempty(dir(outdir)),   mkdir(outdir);end, save([outdir G.DIR.SEP outfile],'P');
        plot_custom(G,pid,sid,'svm_output','plot_svm_output_episode',[],'smokinglabel','segment_gyr','map',[2,1],'selfreport','svm','episode');
%        plot_custom(G,pid,sid,'svm_output','plot_svm_output_episode',[],'smokinglabel','gyrmag',[2,1],'segment_gyr','map',[2,1],'selfreport','svm','episode');
        
        disp('abc');
    end
end

close all
clear all
G=config();
%G=config_run_monowar_Memphis_Smoking_Lab(G);

G=config_run_monowar_Memphis_Smoking(G);
PS_LIST=G.PS_LIST;
M=field_miss();
for pp=1:size(PS_LIST,1)
    pid=char(PS_LIST{pp,1});
    ppid=str2num(pid(2:end));
    slist=PS_LIST{pp,2};
    for s=slist
        sid=char(s);
        ssid=str2num(sid(2:end));
        fprintf('pid=%s sid=%s\n',pid,sid);
        %        plot_custom(G,pid,sid,'svm_output','plot_svm_output',[],'smokinglabel','map',[2,1],'selfreport','svm');
        INDIR='svm_output';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];load([indir G.DIR.SEP infile]);
        %        B.
        for i=1:2
            S.wrist{i}.svm_predict=P.wrist{i}.gyr.segment.svm_predict;
            S.wrist{i}.svm_probability=P.wrist{i}.gyr.segment.svm_probability;
            ind=find(P.wrist{i}.gyr.segment.peak_ind~=0 & P.wrist{i}.gyr.segment.svm_predict==1);
            peak_ind=P.wrist{i}.gyr.segment.peak_ind(ind);
            S.wrist{i}.puff_time=P.sensor{1}.peakvalley_new_3.timestamp(peak_ind);
            S.self_report.time=P.selfreport{2}.timestamp';
            mind=find(M(:,1)==ppid & M(:,2)==ssid);
            S.self_report.missing=M(mind,4);
            fprintf('%d %d\n',length(S.self_report.time),length(S.self_report.missing));
%            S.self_report.missing=
        end
        OUTDIR='ben_svm_selfreport';outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];outfile=[pid '_' sid '_' OUTDIR '.mat'];if isempty(dir(outdir)),   mkdir(outdir);end, save([outdir G.DIR.SEP outfile],'S');
        
    end
end

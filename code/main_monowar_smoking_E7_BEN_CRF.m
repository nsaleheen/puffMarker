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
        INDIR='ben_svm_selfreport';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];load([indir G.DIR.SEP infile]);
        demo_episodes(S,pid,sid);
    end
end

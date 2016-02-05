% Both for NIDA and JHU
% Operation: RR interval, Activity feature Standard Daviation of magnitude
function main_monowar_cocaine_4_PDA_URINE()
clear all
G=config();
G=config_run_monowar_nida(G);

PS_LIST=G.PS_LIST;
%urine=report_urine('C:\DataProcessingFramework\data\nida\studyinfo\urineprofile_jan27.csv');
%save('urine.mat','urine');

%pda=report_pda_nida('C:\DataProcessingFramework\data\nida\studyinfo\nida_pda_selfreport_jan27.csv');
%save('nida_pda.mat','pda');

load('urine.mat');load('nida_pda.mat');
urine_pda=combine_urine_pda('nida_all_session_1.csv',urine,pda);
save('urine_pda.mat','urine_pda');
return;
load('urine_pda.mat'); load('nida_pda.mat');
%find_missed_to_report(urine_pda);
find_missed_to_report_revised('C:\DataProcessingFramework\code\nida_sessions.csv');
plot_all_cocaine(G,urine_pda,pda);
return;
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    C=[];N=[];RR=[];
    ppid=str2num(pid(2:end));

    for s=slist
        sid=char(s);
%        plot_rr_avg_threshold_macd_recovery(G,pid,sid);
        [c,rr]=get_emre_recovery(G,pid,sid,1);C=[C, c];
        [n,rr]=get_emre_recovery(G,pid,sid,0);N=[N,n];RR=[RR,rr];
        plot_rr_avg_threshold_macd_recovery_emre(G,pid,sid,c,n);

    end
    E{ppid+sppid}.C=C;
    E{ppid+sppid}.N=N;
    E{ppid+sppid}.rr.prctile_1=prctile(RR,1);
    E{ppid+sppid}.rr.prctile_2=prctile(RR,2);    
    E{ppid+sppid}.rr.prctile_5=prctile(RR,5);
    E{ppid+sppid}.rr.prctile_10=prctile(RR,10);
    E{ppid+sppid}.rr.prctile_50=prctile(RR,50);
    E{ppid+sppid}.rr.prctile_90=prctile(RR,90);
    E{ppid+sppid}.rr.prctile_95=prctile(RR,95);
    E{ppid+sppid}.rr.prctile_98=prctile(RR,98);
    E{ppid+sppid}.rr.prctile_99=prctile(RR,99);
    
end
save('newE.mat','E');

end

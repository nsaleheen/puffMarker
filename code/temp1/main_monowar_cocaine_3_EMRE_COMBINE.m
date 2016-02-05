% Both for NIDA and JHU
% Operation: RR interval, Activity feature Standard Daviation of magnitude
function main_monowar_cocaine_3_EMRE_COMBINE()
clear all
G=config();
G=config_run_monowar_jhu(G);sppid=0;
%G=config_run_monowar_nida(G);
%G=config_run_monowar_NIDAc(G);sppid=3;load('newE.mat');

% NIDAc
PS_LIST_NIDAc={
    {'p01'},{'s06','s09','s12'};    {'p02'},{'s04'};    {'p03'},{'s05'}; {'p04'},{'s01','s05','s08'};
};
%JHU
PS_LIST_JHU= {
    %    all
    {'p01'},{'s01','s02','s03','s08','s09','s12'};
    {'p02'},{'s01','s06','s07','s09','s13','s16','s21'};
    {'p03'},{'s01','s04','s05','s08','s15','s18'};
};
PS_LIST=G.PS_LIST;
%PS_LIST=PS_LIST_JHU;
%PS_LIST=PS_LIST_NIDAc;

for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    C=[];N=[];AA=[];RR=[];
    
    ppid=str2num(pid(2:end));

    for s=slist
        sid=char(s);
%        plot_rr_avg_threshold_macd_recovery(G,pid,sid);
        [c,rr]=get_emre_recovery(G,pid,sid,1);C=[C, c];
        [n,rr]=get_emre_recovery(G,pid,sid,0);N=[N,n];RR=[RR,rr];
       % [a,rr]=get_emre_activation(G,pid,sid,0);A=[A,a];
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

% Both for NIDA and JHU
% Operation: RR interval, Activity feature Standard Daviation of magnitude
function main_monowar_cocaine_2_MA_TH_MACD()
clear all
G=config();
%G=config_run_monowar_jhu(G);
G=config_run_monowar_nida(G);
%G=config_run_monowar_NIDAc(G);

% NIDAc
PS_LIST_NIDAc={
    {'p01'},{'s06','s09','s12'};    {'p02'},{'s04'};    {'p03'},{'s05','s10'}; {'p04'},{'s01','s05','s08'};
    {'p05'},{'s03','s06'};{'p06'},{'s01','s04','s08'};
    
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
    for s=slist
        sid=char(s);
%        calculate_movingavg_threshold(G,pid,sid,'segment',G.MODEL.ACT10SLIDE);
%        continue;
%        if strcmp(G.STUDYNAME,'NIDAc')==1, load_NIDAc_pda_labreport_segment(G,pid,sid,'studyinfo', 'segment');end;
%        if strcmp(G.STUDYNAME,'JHU')==1, load_JHU_pda_labreport_segment(G,pid,sid);end;
%        fprintf('%s %s\n',pid,sid);
        pid='p21';sid='s12';
        if strcmp(G.STUDYNAME,'NIDA')==1 || strcmp(G.STUDYNAME,'nida')==1, load_nida_pda_selfreport_new(G,pid,sid);end;
        M.W=600;M.SLOW=2100;M.FAST=240;M.SIGNAL=220;
        L.W=600;L.SLOW=4800;L.FAST=30;L.SIGNAL=20;
        R.W=600;R.SLOW=1200;R.FAST=90;R.SIGNAL=80;
        calculate_macd(G,pid,sid,'segment',600,M,L,R);
        
        mark_cocaine_segment(G,pid,sid);        
%        pid='p03';sid='s19';
        correct_recovery(G,pid,sid);
        disp('abc');
       % plot_rr_avg_threshold(G,pid,sid,G.MODEL.ACT10SLIDE);
%        mark_cocaine_segment(G,pid,sid);
%        mark_cocaine_recovery(G,pid,sid);
        %mark_activity_activation(G,pid,sid);
        %mark_cocaine_activation(G,pid,sid);
        
%        plot_rr_avg_threshold_macd(G,pid,sid);
        plot_rr_avg_threshold_macd_recovery_cocaine_activity(G,pid,sid);
        disp('abc');
        
    end
end
end

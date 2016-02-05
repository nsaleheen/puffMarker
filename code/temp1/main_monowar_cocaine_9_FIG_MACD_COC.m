% Both for NIDA and JHU
% Operation: RR interval, Activity feature Standard Daviation of magnitude
function main_monowar_cocaine_9_FIG_MACD_COC()
clear all
G=config();
G=config_run_monowar_nida(G);
PS_LIST=G.PS_LIST;
load('NIDA_test.mat');
pid='p41';
sid='s11';
plot_rr_avg_threshold_macd_recovery_cocaine_activity(G,pid,sid);

for e=1:length(E)
    if isempty(E{e}), continue;end;
    for c=1:length(E{e}.C)
        pid=E{e}.C{c}.pid;
        sid=E{e}.C{c}.sid;
%        st=convert_timestamp_matlabtimestamp(G,E{e}.C{c}.window_time(1));
%        et=convert_timestamp_matlabtimestamp(G,E{e}.C{c}.window_time(4));
        
        plot_rr_avg_threshold_macd_recovery_cocaine_activity(G,pid,sid);
        
%        plot_signal([st,et],[500,2000],'r-',8);
%        fprintf('%s,%s,%.0f,%.0f,%.0f,%.0f\n',pid,sid,E{e}.C{c}.window_time(1),E{e}.C{c}.window_time(2),E{e}.C{c}.window_time(3),E{e}.C{c}.window_time(4));
%        x=10;
    end
end
end

% Both for NIDA and JHU
% Operation: RR interval, Activity feature Standard Daviation of magnitude
function main_monowar_cocaine_9_FIG_MACD()
clear all
G=config();
G=config_run_monowar_jhu(G);

pid='p01';sid='s01';plot_macd_paper_new(G,pid,sid);

%pid='p02';sid='s06';plot_deepak_paper(G,pid,sid);

end

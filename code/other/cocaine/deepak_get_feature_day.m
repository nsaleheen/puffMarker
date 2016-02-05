function [N,time]=deepak_get_feature_day(G,pid,sid,INDIR)
%% Load Data (Formatted Raw, Formatted Data)
fprintf('%-6s %-6s %-20s Task (',pid,sid,'main_deepak_get_feature_day');

indir=[G.DIR.DATA G.DIR.SEP INDIR];
load([indir G.DIR.SEP pid '_' sid '.mat']);
N=[];
N=[A.feature.sample(:,:) A.feature.qt A.feature.qtc A.feature.pr A.feature.qrs A.feature.th];
time=A.feature.matlabtime;

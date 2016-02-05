%% Data Processing Framework
% Overview: starting point of the framework.
function main_nida_monowar_window()
clear all
%% Basic Configureation files
%
G=config();
G=config_run_nida(G);

PS_LIST=G.PS_LIST;
M.W=600;M.SLOW=2100;M.FAST=240;M.SIGNAL=220;
L.W=600;L.SLOW=4800;L.FAST=30;L.SIGNAL=20;
R.W=600;R.SLOW=1200;R.FAST=90;R.SIGNAL=80;
% GOOD 
PS_LIST={ {'p01'},{'s10','s16','s21'};{'p03'},{'s18'};{'p06'},{'s01','s03'};{'p09'},{'s10'};{'p12'},{'s27'};{'p14'},{'s16'};{'p15'},{'s10','s13'};};
% MEDIUM: 
%PS_LIST={ {'p01'},{'s04'};{'p06'},{'s13','s16','s32'};{'p12'},{'s10'};{'p14'},{'s10'};{'p15'},{'s02','s16'};{'p18'},{'s05'};{'p21'},{'s12'};};
% BAD: 
%PS_LIST={ {'p01'},{'s12'};{'p06'},{'s19'};{'p08'},{'s06'};{'p12'},{'s15','s22','s24'};{'p14'},{'s11','s24'};{'p15'},{'s05','s25'};{'p18'},{'s12'};{'p19'},{'s18'};};

% NONCOCAINE:

pno=size(PS_LIST,1);
%fid=fopen('temp.txt','w');
for p=1:pno
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        plot_activation_recovery(G,pid,sid,600,600,2);
    end
end
end

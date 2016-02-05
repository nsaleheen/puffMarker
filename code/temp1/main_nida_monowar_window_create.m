%% Data Processing Framework
% Overview: starting point of the framework.
function main_nida_monowar_window_create()
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
%PS_LIST={ {'p01'},{'s10','s16','s21'};{'p03'},{'s18'};{'p06'},{'s01','s03'};{'p09'},{'s10'};{'p12'},{'s27'};{'p14'},{'s16'};{'p15'},{'s10','s13'};};
% MEDIUM: 
%PS_LIST={ {'p01'},{'s04'};{'p06'},{'s13','s16','s32'};{'p12'},{'s10'};{'p14'},{'s10'};{'p15'},{'s02','s16'};{'p18'},{'s05'};{'p21'},{'s12'};};
% BAD: 
%PS_LIST={ {'p01'},{'s12'};{'p06'},{'s19'};{'p08'},{'s06'};{'p12'},{'s15','s22','s24'};{'p14'},{'s11','s24'};{'p15'},{'s05','s25'};{'p18'},{'s12'};{'p19'},{'s18'};};

% FINAL:
PS_LIST={ {'p01'},{'s04','s10','s16','s21'};{'p03'},{'s18'};{'p06'},{'s01','s03','s32'};{'p09'},{'s10'};{'p12'},{'s10','s27'};{'p14'},{'s16'};{'p15'},{'s02','s10','s13'};
{'p01'},{'s02','s03','s17','s19','s23'};{'p03'},{'s02','s03','s04','s08','s11'};
    {'p06'},{'s07','s11','s12','s14','s30'};{'p09'},{'s01','s03','s07','s08'};
    {'p12'},{'s01','s03','s11','s12','s23'};{'p14'},{'s02','s03','s04','s05','s06','s22'};{'p15'},{'s01'};};

pno=size(PS_LIST,1);
%fid=fopen('temp.txt','w');
for p=1:pno
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    ppid=str2num(pid(2:end));
    RR=[];
    for s=slist
        sid=char(s);
        ssid=str2num(sid(2:end));
        [P{ppid}.S{ssid}.N,rr]=generate_activity_recovery(G,pid,sid);
        RR=[RR rr];        
    end
    P{ppid}.RR_low=prctile(RR,1);
    P{ppid}.RR_high=prctile(RR,99);
end
save('NIDA_all.mat','P');
end

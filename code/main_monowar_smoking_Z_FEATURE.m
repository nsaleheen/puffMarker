% Both for NIDA and JHU
% Operation: RR interval, Activity feature Standard Daviation of magnitude
close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking(G);
PS_LIST=G.PS_LIST;
LISTS={{10,1,1},{10,1,2},{10,2,2},{10,2,3},{10,2,4},{10,3,1},{10,3,2},{11,1,1},{11,1,4},{11,2,1},{11,2,2},{11,2,3},{14,3,3},{16,1,2}};
PP=[];SS=[];EE=[];IN=[];EX=[];HG=[],PF=[];
for l=1:length(LISTS)
    pid=sprintf('p%02d',LISTS{l}{1});
    sid=sprintf('s%02d',LISTS{l}{2});
    eno=LISTS{l}{3};
    [in,ex,hg]=getfeature(G,pid,sid,eno,'basicfeature');
    pp=ones(1,length(in))*LISTS{l}{1};
    ss=ones(1,length(in))*LISTS{l}{2};
    ee=ones(1,length(in))*LISTS{l}{3};
    pf=[1:length(in)];
    PP=[PP,pp];    SS=[SS,ss];    EE=[EE,ee];PF=[PF,pf];
    IN=[IN,in];EX=[EX,ex];HG=[HG,hg];
    disp('abc');
end
matx=[IN',EX',HG',PP',SS',EE',PF'];

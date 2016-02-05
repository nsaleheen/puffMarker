%% Data Processing Framework
% Overview: starting point of the framework.
clear all
%% Basic Configureation files
%
G=config();
G=config_run_nida(G);


PS_LIST={ {'p01'},{'s04','s10','s16','s21'};{'p03'},{'s18'};{'p06'},{'s01','s03','s32'};{'p09'},{'s10'};{'p12'},{'s10','s27'};{'p14'},{'s16'};{'p15'},{'s02','s10','s13'};
    {'p01'},{'s02','s03','s17','s19','s23'};{'p03'},{'s02','s03','s04','s08','s11'};
    {'p06'},{'s07','s11','s12','s14','s30'};{'p09'},{'s01','s03','s07','s08'};
    {'p12'},{'s01','s03','s11','s12','s23'};{'p14'},{'s02','s03','s04','s05','s06','s22'};{'p15'},{'s01'};
};

count=0;
pno=size(PS_LIST);
E=[];
P=[];
ppid=0;
for p=1:pno
    pid=char(PS_LIST{p,1});
    ppid=str2num(pid(2:end));
    slist=PS_LIST{p,2};
    N=[];
    C=[];
    RR=[];
    for s=slist
        sid=char(s);
       [n,rr]=generate_emre_activity_field(G,pid,sid);
       if length(n)~=0, N=[N,n];RR=[RR rr];end
       c=generate_emre_cocaine_field(G,pid,sid);
       if length(c)~=0, C=[C,c];end;
    end
    if length(E)<ppid | ~isfield(E{ppid},'N'),    E{ppid}.N=N;
    else, E{ppid}.N=[E{ppid}.N N];end;
    if length(E)<ppid | ~isfield(E{ppid},'C'),    E{ppid}.C=C;
    else, E{ppid}.C=[E{ppid}.C C];end;
    E{ppid}.RR_low=prctile(RR,1);
    E{ppid}.RR_high=prctile(RR,99);
end
save('NIDA_train.mat','E');
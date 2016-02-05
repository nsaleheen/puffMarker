function main_nida_monowar_window_global()
clear all
G=config();
G=config_run_nida(G);
PS_LIST={ {'p01'},{'s04','s10','s16','s21'};{'p03'},{'s18'};{'p06'},{'s01','s03','s32'};{'p09'},{'s10'};{'p12'},{'s10','s27'};{'p14'},{'s16'};{'p15'},{'s02','s10','s13'};
    {'p01'},{'s02','s03','s17','s19','s23'};{'p03'},{'s02','s03','s04','s08','s11'};
    {'p06'},{'s07','s11','s12','s14','s30'};{'p09'},{'s01','s03','s07','s08'};
    {'p12'},{'s01','s03','s11','s12','s23'};{'p14'},{'s02','s03','s04','s05','s06','s22'};{'p15'},{'s01'};};

load NIDA_all;
n_c=0;
t_c=0;
c_c=0;
C=[];N=[];
TOT=0;
%    fid1=fopen(['roc_mse.txt'],'w');
%    fid2=fopen(['roc_dose.txt'],'w');
MA=[];MC=[];D=[];O=[];
fid1=fopen(['roc_mse_nida_all.txt'],'w');
fid2=fopen(['roc_dose_nida_all.txt'],'w');

for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    ppid=str2num(pid(2:end));
    for s=slist
        sid=char(s);
        ssid=str2num(sid(2:end));
        
        %{
        plot_activation_recovery(G,pid,sid,600,600,2);

        for n=1:length(P{ppid}.S{ssid}.N)
            if P{ppid}.S{ssid}.N{n}.mark<0, continue;end
            [v,t]=filter_data(P,ppid,ssid,n);

            datatest{ppid}.samples=v;  datatest{ppid}.time=t-t(1);
        
        %{
            plot_signal(t,v,'k-',2);
            midtime=(P{ppid}.S{ssid}.N{n}.rr.avg.matlabtime(end)+P{ppid}.S{ssid}.N{n}.rr.avg.matlabtime(1))/2
            [ma,mc,d]=test_emre(ppid,datatest);
            text(midtime,50  , [ 'ma/mc=' num2str(ma/mc) 'dose=' num2str(d) ], 'Color', 'r','FontSize',14,'Rotation',90);

            fprintf('ma=%f mc=%f d=%f\n',ma,mc,d);

            MA=[MA, ma];
            MC=[MC, mc];
            D=[D, d];
            O=[O, P{ppid}.S{ssid}.N{n}.mark];
        %}
        end
%        continue;
        %        P{ppid}.S{ssid}.N
        %}
        TOT=TOT+length(P{ppid}.S{ssid}.N);
        c=find_cocaine_other_all(P{ppid}.S{ssid}.N,'c',ppid);
        n=find_cocaine_other_all(P{ppid}.S{ssid}.N,'n',ppid);
        C=[C,c];
        N=[N,n];
        
        %        t_c=t_c+length(P{1}.S{1}.N);
        %        c_c=c_c+length(C);
        %        n_c=n_c+length(N);
    end
end
load NIDA_tau
for n=1:length(C)
    disp(n)
    [datatest{ppid}.samples,datatest{ppid}.time]=filter_data(C{n});
    if length(datatest{ppid}.samples)==0, continue;end;
    
    datatest{ppid}.time=datatest{ppid}.time-datatest{ppid}.time(1);
    data{1}.samples=datatest{ppid}.samples;
    data{1}.time=datatest{ppid}.time;
    ppid=C{n}.pid;
    Basesol{4}=C{n}.rr.avg.max;
    base=result{ppid}.base;
    tau1=result{ppid}.tau1;
    tau2=4;
    
    if length(data{1}.samples)<3, continue;end;
    [ma,mc,d]=test_emre(1,data,base,tau1,tau2);
    MA=[MA, ma]; MC=[MC, mc];            D=[D, d];O=[O, C{n}.mark];
    
end
for n=1:length(N)
    [datatest{ppid}.samples,datatest{ppid}.time]=filter_data(N{n});
    if length(datatest{ppid}.samples)==0,continue;end;
    datatest{ppid}.time=datatest{ppid}.time-datatest{ppid}.time(1);
    if length(datatest{ppid}.samples)==0, continue;end;
    data{1}.samples=datatest{ppid}.samples;
    data{1}.time=datatest{ppid}.time;
    
    ppid=N{n}.pid;
    base=result{ppid}.base;
    tau1=result{ppid}.tau1;
    tau2=3.5;
    
    [ma,mc,d]=test_emre(1,data,base,tau1,tau2);
    MA=[MA, ma]; MC=[MC, mc];            D=[D, d];O=[O, N{n}.mark];
end
ACC=0;
MCA=MC./MA;
TOT=TOT-length(C)-length(N);
k=0;TP=[];FP=[];
for i=min(MCA)-0.01:0.001:max(MCA)+0.01
    %            for i=1:length(MAC)
    %                v=MAC(i);
    %v=0.101030;
    v=i;
    no_c=length(find(O>0));
    no_a=length(O)-no_c;
    c_c=length(find(MCA(1:no_c)<=v));
    c_i=length(find(MCA(1:no_c)>v));
    a_c=length(find(MCA(no_c+1:end)>v))+TOT;
    a_i=length(find(MCA(no_c+1:end)<=v));
    acc=(c_c+a_c)/(c_c+c_i+a_c+a_i);
    fprintf(fid1,'th=%f acc=%f c_c=%d c_i=%d a_c=%d a_i=%d\n',v,acc,c_c, c_i, a_c, a_i);
    k=k+1;
    TP(k)=c_c/(c_c+c_i);
    FP(k)=a_i/(a_c+a_i);
    
end
figure; plot(FP,TP,'r-','linewidth',2);
xlabel('False Positive Rate', 'FontSize', 20);
ylabel('True Positive Rate', 'FontSize', 20);
title('3 Participants Combined', 'FontSize', 20);
set(0,'DefaultAxesFontSize', 20);
set(0,'DefaultTextFontSize', 20);

set(gca,'FontSize',20);

xlim([0,1]);
ylim([0,1]);
TP=[];FP=[];k=0;


fclose(fid1);
fclose(fid2);
return;
%{
d=[];w=[];
for c=1:length(C)
    d=[d max(C{c}.rr.avg.sample)-min(C{c}.rr.avg.sample)];
    w=[w (C{c}.rr.avg.matlabtime(end)-C{c}.rr.avg.matlabtime(1))*24*60*60];
end
disp('abc');
%}
end

function [v,t]=filter_data(N)
v=N.rr.avg.sample;        t=N.rr.avg.matlabtime;
[x,y]=min(v);        v(1:y)=[];t(1:y)=[];
%{
ind=find(N.acl.avg.sample>N.acl.threshold);
strt=1;count=0;
for ii=2:length(ind)
    if ind(ii-1)+1==ind(ii), count=count+1;
    else
        if count>60, 
            
            strt=ind(ii);count=0;end;
        
    end
end

etime=N.acl.avg.matlabtime(strt);
ind=find(t<etime);
if ~isempty(ind)
    v(1:ind(end))=[];t(1:ind(end))=[];
end
%}
end
function res=find_cocaine_other_all(P,c_n,pid)

res=[];now=0;
for i=1:length(P)
    if P{i}.mark<0, continue;end;
    if c_n=='n', if P{i}.mark==0, now=now+1;res{now}=P{i};res{now}.pid=pid;end
    else
        if P{i}.mark>0
            now=now+1;res{now}=P{i};res{now}.pid=pid;
        end
    end
end
end
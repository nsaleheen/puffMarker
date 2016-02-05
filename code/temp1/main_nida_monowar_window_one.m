function main_nida_monowar_window_one()
clear all
G=config();
G=config_run_nida(G);

load NIDA_all;
C=[];N=[];
TOT=0;
MA=[];MC=[];D=[];O=[];
pid='p01';
sid='s10';
ppid=1;ssid=10;

load NIDA_tau
who=0;
[h,legend_text]=plot_activation_recovery_paper_one_new1(G,pid,sid,600,600,2);
return;
ylim([500,2400]);
for n=1:length(P{ppid}.S{ssid}.N)
    if P{ppid}.S{ssid}.N{n}.mark<0, 
        st=P{ppid}.S{ssid}.N{n}.rr.avg.matlabtime(1);
        h(6)=plot_signal(st,1800,'bo',4,0);legend_text{6}='Noncocaine window';
        continue;end
    
    [datatest{ppid}.samples,datatest{ppid}.time]=filter_data(P{ppid}.S{ssid}.N{n});
    if length(datatest{ppid}.samples)==0, continue;end;
    
    datatest{ppid}.time=datatest{ppid}.time-datatest{ppid}.time(1);
    data{1}.samples=datatest{ppid}.samples;
    data{1}.time=datatest{ppid}.time;
    
    base=result{ppid}.base;
    tau1=result{ppid}.tau1;
    tau2=4;
    
    if length(data{1}.samples)<3, continue;end;
    [ma,mc,d]=test_emre(1,data,base,tau1,tau2);
    st=P{ppid}.S{ssid}.N{n}.rr.avg.matlabtime(1);

    if mc/ma<0.065021
        if who==0, who=1;        h(7)=plot_signal(st,1800,'bo',4,0);legend_text{7}='Cocaine window';
        else
        h(6)=plot_signal(st,2000,'ro',4,0);legend_text{7}='Cocaine window';       
        end
    else
        h(7)=plot_signal(st,1800,'bo',4,0);legend_text{7}='Cocaine window';

    end
end
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
%{
TOT=TOT+length(P{ppid}.S{ssid}.N);
c=find_cocaine_other_all(P{ppid}.S{ssid}.N,'c',ppid);
n=find_cocaine_other_all(P{ppid}.S{ssid}.N,'n',ppid);
C=[C,c];
N=[N,n];

%        t_c=t_c+length(P{1}.S{1}.N);
%        c_c=c_c+length(C);
%        n_c=n_c+length(N);
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
%}
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
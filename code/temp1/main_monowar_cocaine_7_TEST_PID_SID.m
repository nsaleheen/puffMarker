function main_monowar_cocaine_7_TEST_PID_SID(P,base,tau1,tau2)
for p=1:size(PS_LIST,1)
    
    [ma,mc,pass,d,o]=test_one(E{p}.C,base,tau1,tau2,'c');MA=[MA ma];MC=[MC mc];D=[D,d];O=[O,o];C_I=length(E{p}.C)-pass;
    [ma,mc,pass,d,o]=test_one(E{p}.N,base,tau1,tau2,'n');MA=[MA ma];MC=[MC mc];D=[D,d];O=[O,o];A_C=length(E{p}.N)-pass;
    %NONPASS=length(E{p}.C)+length(E{p}.N)-PASS;    
end
end
function [MA,MC,pass,D,O]=test_one(CN,base,tau1,tau2,type)
MA=[];MC=[];pass=0;V=[];D=[];O=[];non_pass=0;
for n=1:length(CN)
    disp(n);
    %        if CN{n}.rr.avg.
    if type=='n' && isvalid(CN{n})==0, continue;end;
 %   if filter_data(CN{n})
    %   figure;plot(datatest{ppid}.time,datatest{ppid}.samples);
 %   if length(CN{n}.rr.avg.t60)==0, non_pass=non_pass+1;continue;end;
    pass=pass+1;
    %        if length(data{1}.samples)<3, continue;end;
    [v,ma,mc,d]=test_emre(CN{n},base,tau1,tau2);
    if v==0, pass=pass-1;else
    MA=[MA, ma]; MC=[MC, mc];            D=[D, d];O=[O, CN{n}.window.mark];
    end
end

end
function valid=isvalid(CN)
   p1time= CN.window_time(1);
   p2time= CN.window_time(4);
   v1time= CN.window_time(2);
   v2time= CN.window_time(3);
   
   if p2time-p1time<10*60*1000, valid=0;return;end;
   a=2*60*1000;
   ind=find(CN.acl.timestamp>=p1time & CN.acl.timestamp<=p1time+a);
   val=CN.acl.avg.t60(ind);
   ind1=find(val>CN.acl.avg.th60);
   if length(val) *0.5<length(ind1), valid=0;return;end;
   b=2*60*1000;
   ind=find(CN.acl.timestamp>=v2time-a & CN.acl.timestamp<=v2time);
   val=CN.acl.avg.t60(ind);
   ind1=find(val>CN.acl.avg.th60);
   if length(val) *0.5<length(ind1), valid=0;return;end;
   valid=1;
   return;
end
%{
function N=filter_data(N)

p1=N.window_time(1);v1=N.window_time(2);v2=N.window_time(3);p2=N.window_time(4);
ind=find(N.acl.timestamp>=p1 & N.acl.timestamp<=v1);
ind1=find(N.acl.avg.t60(ind)>N.acl.avg.th60);
if length(ind1)>length(ind)*0.50
    N=[];
    return 
end;
count=length(find(N.acl.avg.t60(i-60:i)>N.acl.avg.th60));

v=N.rr.avg.t60;        t=N.rr.avg.timestamp;
[x,y]=min(v);        v(1:y)=[];t(1:y)=[];
valid_ind=0;
for i=61:length(v)
    count=length(find(N.acl.avg.t60(i-60:i)>N.acl.avg.th60));
    if count/60>.25, 
        break;
    else valid_ind=i-60;
    end
end
H=max(N.rr.avg.t60)-min(N.rr.avg.t60);
h=max(N.rr.avg.t60(1:valid_ind))-min(N.rr.avg.t60(1:valid_ind));
if H*.95>h,
    v=[];t=[];
end
N.rr.avg.t60=v;
N.rr.avg.timestamp=t;
end
%}
%{


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
        TOT=TOT+length(P{ppid}.S{ssid}.A);
        c=find_cocaine_other_all(P{ppid}.S{ssid}.A,'c',ppid);
        n=find_cocaine_other_all(P{ppid}.S{ssid}.A,'n',ppid);
        C=[C,c];
        N=[N,n];
        
        %        t_c=t_c+length(P{1}.S{1}.N);
        %        c_c=c_c+length(C);
        %        n_c=n_c+length(N);
    end
end
load([G.STUDYNAME '_tau.mat']);
non_pass=0;pass=0;
for n=1:length(C)
    disp(n)
    [datatest{ppid}.samples,datatest{ppid}.time]=filter_data(C{n});
 %   figure;plot(datatest{ppid}.time,datatest{ppid}.samples);
    if length(datatest{ppid}.samples)==0, non_pass=non_pass+1;continue;end;
    pass=pass+1;
    datatest{ppid}.time=datatest{ppid}.time-datatest{ppid}.time(1);
    data{1}.samples=datatest{ppid}.samples;
    data{1}.time=datatest{ppid}.time;
    ppid=C{n}.pid;
    Basesol{4}=C{n}.rr.avg.max;
    base=result{ppid}.base;
    tau1=result{ppid}.tau1;
    tau2=result{ppid}.tau2;
    if length(data{1}.samples)<3, continue;end;
    [ma,mc,d]=test_emre(1,data,base,tau1,tau2);
    MA=[MA, ma]; MC=[MC, mc];            D=[D, d];O=[O, C{n}.mark];
    
end
pass
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
v=N.rr.avg.t60;        t=N.rr.avg.timestamp;
return;
[x,y]=min(v);        v(1:y)=[];t(1:y)=[];
H=max(N.rr.avg.t60)-min(N.rr.avg.t60);
h=max(N.rr.avg.t60(1:valid_ind))-min(N.rr.avg.t60(1:valid_ind));
if H*.95>h,
    v=[];t=[];
end
end
function res=find_cocaine_other_all(P,c_n,pid)

res=[];now=0;
for i=1:length(P)
    if P{i}.window.mark<0, continue;end;
    if c_n=='n', if P{i}.window.mark==0, now=now+1;res{now}=P{i};res{now}.pid=pid;end
    elseif c_n=='c'
        if P{i}.window.mark>0
            now=now+1;res{now}=P{i};res{now}.pid=pid;
        end
    end
end
end
%}

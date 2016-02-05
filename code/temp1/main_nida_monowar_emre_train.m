function main_nida_monowar_emre_train()
clear all
G=config();
G=config_run_nida(G);
PS_LIST={'p01','p03','p06','p09','p12','p14','p15'};
load('NIDA_train.mat');

for p=1:size(PS_LIST,2)
    pid=PS_LIST{p};
    ppid=str2num(pid(2:end));
    base=E{ppid}.RR_high/1000;
    
    [tau1,tau2]=calculate_tau1_tau2(base,E{ppid}.N,E{ppid}.C);
    result{ppid}.base=base;
    result{ppid}.tau1=tau1;
    result{ppid}.tau2=tau2;
    fprintf('%f %f %f\n',base,tau1,tau2);
    disp('abc');
end
save('NIDA_tau.mat','result');
end
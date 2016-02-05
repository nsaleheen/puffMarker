% Both for NIDA and JHU
% Operation: RR interval, Activity feature Standard Daviation of magnitude
function main_monowar_cocaine_6_TRAIN()
clear all
G=config();
%G=config_run_monowar_jhu(G);
G=config_run_monowar_nida(G);
%G=config_run_monowar_NIDAc(G);

PS_LIST=G.PS_LIST;

main_monowar_cocaine_5_TRAIN_PREP(G,PS_LIST);
%return;
load([G.STUDYNAME '_train.mat']);
%return;
%load('newE.mat');
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    ppid=str2num(pid(2:end));
    base=E{ppid}.rr.prctile_95;

%    [tau1,tau2]=calculate_tau1_tau2(base,E{ppid}.N,E{ppid}.C);
    cocaine=-1; % -1 (all), 10, 20, 40
    [tau1sol,tau2sol,mse1,mse2]=calculate_tau1_tau2(E,cocaine,ppid);
%    recoveryfit3(E,cocaine,ppid);
    result{ppid}.base=base;
    result{ppid}.tau1=tau1sol{ppid};
    if isempty(tau2sol) || isempty(tau2sol{ppid}), continue;end;
    result{ppid}.tau2=tau2sol{ppid};
    fprintf('%f %f %f\n',base,tau1sol{ppid},tau2sol{ppid});
    disp('abc');
end
save([G.STUDYNAME '_tau.mat'],'result');
end

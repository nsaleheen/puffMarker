% Both for NIDA and JHU
% Operation: RR interval, Activity feature Standard Daviation of magnitude
function main_monowar_cocaine_5_TRAIN_PREP()
clear all
G=config();
G=config_run_monowar_jhu(G);
%G=config_run_monowar_nida(G);
%G=config_run_monowar_NIDAc(G);

PS_LIST=G.PS_LIST;
%PS_LIST=PS_LIST_JHU;
%PS_LIST=PS_LIST_NIDAc;

for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    ppid=str2num(pid(2:end));
    RR=[];
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        ssid=str2num(sid(2:end));
        [P{ppid}.S{ssid}.C,rr]=get_emre_recovery_new(G,pid,sid,1);
        [P{ppid}.S{ssid}.N,rr]=get_emre_recovery_new(G,pid,sid,0);RR=[RR, rr];
        P{ppid}.S{ssid}.A=[P{ppid}.S{ssid}.C, P{ppid}.S{ssid}.N];
    end
    P{ppid}.base=prctile(RR,95);    
end
save([G.STUDYNAME '_train_all.mat'],'P');
end

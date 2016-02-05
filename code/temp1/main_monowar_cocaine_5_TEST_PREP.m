% Both for NIDA and JHU
% Operation: RR interval, Activity feature Standard Daviation of magnitude
function main_monowar_cocaine_5_TEST_PREP(G,PS_LIST)
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    ppid=str2num(pid(2:end));
    slist=PS_LIST{p,2};
    RR=[];N=[];C=[];
    for s=slist
        sid=char(s);
        ssid=str2num(sid(2:end));
%        [P{ppid}.S{ssid}.N,rr]=generate_activity_recovery(G,pid,sid);
%        [c,rr]=get_emre_cocaine_recovery(G,pid,sid,1); if ~isempty(c), C=[C,c];end; RR=[RR,rr];
%        [n,rr]=get_emre_recovery_activity(G,pid,sid,0);if ~isempty(n),N=[N,n];end
        [c,rr]=get_emre_recovery_new_test(G,pid,sid,1); if ~isempty(c), C=[C,c];end; RR=[RR,rr];
        [n,rr]=get_emre_recovery_new_test(G,pid,sid,0);if ~isempty(n),N=[N,n];end
    end
    E{ppid}.base=prctile(RR,95);
    E{ppid}.rr.prctile_95=E{ppid}.base;
    E{ppid}.rr.prctile_5=prctile(RR,5);
    
    E{ppid}.C=C;
    E{ppid}.N=N;
end
save([G.STUDYNAME '_test.mat'],'E');


end

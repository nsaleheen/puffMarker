% Both for NIDA and JHU
% Operation: RR interval, Activity feature Standard Daviation of magnitude
function main_monowar_cocaine_5_TRAIN_PREP(G,PS_LIST)

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
        [c,rr]=get_emre_recovery_new(G,pid,sid,1); if ~isempty(c), C=[C,c];end; RR=[RR,rr];
        [n,rr]=get_emre_recovery_new(G,pid,sid,0);if ~isempty(n),N=[N,n];end

    end
    E{ppid}.base=prctile(RR,95);
    E{ppid}.rr.prctile_95=E{ppid}.base;
    E{ppid}.rr.prctile_5=prctile(RR,5);
    d=E{ppid}.rr.prctile_95-E{ppid}.rr.prctile_5;
    E{ppid}.C=[];E{ppid}.N=[];
    k=0;
    for i=1:length(C)        
        %e=prctile(C{i}.rr.sample,95)-prctile(C{i}.rr.sample,5);
        %if d*0.5>e, continue;end;
        %k=k+1;
        E{ppid}.C{i}=C{i};
    end
    k=0;
    for i=1:length(N)
        ind=find(N{i}.rr.timestamp>N{i}.window_time(3) & N{i}.rr.timestamp<=N{i}.window_time(4));
        e=prctile(N{i}.rr.sample(ind),95)-prctile(N{i}.rr.sample(ind),5);
        if d*0.5>e, continue;end;
        k=k+1;
        E{ppid}.N{k}=N{i};
    end
    
%    E{ppid}.C=C;
%    E{ppid}.N=N;
    
end
save([G.STUDYNAME '_train.mat'],'E');

end

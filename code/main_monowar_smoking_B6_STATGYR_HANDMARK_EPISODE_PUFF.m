close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
%G=config_run_monowar_Memphis_Smoking(G);
PS_LIST=G.PS_LIST;
R.pid=[];R.sid=[];R.episode=[];R.puff=[];R.valid=[];R.p_starttime=[];R.p_endtime=[];R.missing=[];
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    ppid=str2num(pid(2:end));
    for s=slist
        sid=char(s);
        ssid=str2num(sid(2:end));
        fprintf('pid=%s sid=%s\n',pid,sid);
        INDIR='segment_gyr';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
        for e=1:length(P.smoking_episode)
            if isempty(P.smoking_episode{e}.puff), continue;end;
            if isempty(find(P.smoking_episode{e}.puff.gyr.valid==0,1)), continue;end;
            v=P.smoking_episode{e}.puff.gyr.valid;lenv=length(v);
            R.pid(end+1:end+lenv)=ppid;R.sid(end+1:end+lenv)=ssid;R.episode(end+1:end+lenv)=e;R.puff(end+1:end+lenv)=1:lenv;
            R.valid(end+1:end+lenv)=P.smoking_episode{e}.puff.gyr.valid;
            R.p_starttime(end+1:end+lenv)=P.smoking_episode{e}.puff.gyr.starttimestamp;R.p_endtime(end+1:end+lenv)=P.smoking_episode{e}.puff.gyr.endtimestamp;
            R.missing(end+1:end+lenv)=P.smoking_episode{e}.puff.gyr.missing;
        end
    end
end
fprintf('Total Person=%d\n',length(unique(R.pid)));
fprintf('Total Episode=%d\n',length(unique([R.pid',R.sid',R.episode'],'rows')));
fprintf('Total Puff=%d\n',length(R.puff(R.valid==0)));
for MISSING=[1,0.5,0.33, 0.2, 0.1, 0]
fprintf('Total Valid Puff=%d (missing=%2f)\n',length(R.missing(R.missing(R.valid==0)<=MISSING)),MISSING);
fprintf('Min Distance=%f second\n',min(R.p_endtime(find(R.missing<=MISSING & R.valid==0))-R.p_starttime(find(R.missing<=MISSING & R.valid==0)))/1000);
fprintf('Max Distance=%f second\n',max(R.p_endtime(find(R.missing<=MISSING & R.valid==0))-R.p_starttime(find(R.missing<=MISSING & R.valid==0)))/1000);
end
disp('abc');

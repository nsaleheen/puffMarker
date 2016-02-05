clear all
close all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
nonepisode_len=0;all_len=0;

PS_LIST=G.PS_LIST;
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    ppid=str2num(pid(2:end));
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        ssid=str2num(sid(2:end));
        fprintf('pid=%s sid=%s ',pid,sid);
        INDIR='basicfeature';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if isempty([indir G.DIR.SEP infile]),    disp(['FILE NOT FOUND' indir G.DIR.SEP infile]);return;end; load([indir G.DIR.SEP infile]);
        max_len=0;
        for ids=[G.SENSOR.R_RIPID,G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_GYRZID,G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_GYRZID]
            len=length(B.sensor{ids}.sample)/G.SENSOR.ID(ids).FREQ;
            if len>max_len, max_len=len;end
        end
        all_len=all_len+max_len;
        for e=1:length(B.smoking_episode)
            if isfield(B.smoking_episode{e},'puff')==0, continue;end
            if isempty(B.smoking_episode{e}.puff), continue;end;
            nonepisode_len=nonepisode_len+(B.smoking_episode{e}.endtimestamp-B.smoking_episode{e}.starttimestamp)/1000;
            
            if ~exist('R','var'), R.puff.timestamp=[];R.puff.puffno=[];R.puff.pid=[];R.puff.sid=[];R.puff.eid=[];
            R.episode.starttimestamp=[];R.episode.endtimestamp=[];R.episode.puffno=[];R.episode.pid=[];R.episode.sid=[];R.episode.eid=[];
            end;
            puffno=length(B.smoking_episode{e}.puff.timestamp);
            R.puff.timestamp(end+1:end+puffno-1)=diff(B.smoking_episode{e}.puff.timestamp)/1000;
            R.puff.puffno(end+1:end+puffno-1)=1:puffno-1;
            R.puff.pid(end+1:end+puffno-1)=ones(1,puffno-1)*ppid;
            R.puff.sid(end+1:end+puffno-1)=ones(1,puffno-1)*ssid;
            R.puff.eid(end+1:end+puffno-1)=ones(1,puffno-1)*e;

            R.episode.starttimestamp(end+1)=B.smoking_episode{e}.starttimestamp;
            R.episode.endtimestamp(end+1)=B.smoking_episode{e}.endtimestamp;
            R.episode.puffno(end+1)=puffno;
            R.episode.pid(end+1)=ppid;
            R.episode.sid(end+1)=ssid;
            R.episode.eid(end+1)=e;
        end
        disp('abc');
    end
end
fprintf('total data=%.2f minutes episode=%.2f minutes\n',all_len/60,nonepisode_len/60);
h=figure;hold on;hist(R.episode.puffno);xlabel('Number of puffs');ylabel('Frequency');title(['Number of puffs in each episode (Mean=' num2str(mean(R.episode.puffno)) ', STD=' num2str(std(R.episode.puffno)) ')']);
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold');
saveas(h,'D:\smoking_memphis\data\Memphis_Smoking_Lab\smoking_fig\puffno.png');
h=figure;hold on;hist(R.puff.timestamp,40);xlabel('Inter Puff Duration (in second)');ylabel('Frequency');title(['Inter Puff Duration (Mean=' num2str(mean(R.puff.timestamp)) ', STD=' num2str(std(R.puff.timestamp)) ')']);
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold');
saveas(h,'D:\smoking_memphis\data\Memphis_Smoking_Lab\smoking_fig\interpuff_duration.png');
save('D:\smoking_memphis\data\Memphis_Smoking_Lab\smoking_fig\puff_episode.mat','R');
pse=unique([R.puff.pid;R.puff.sid;R.puff.eid]','rows');

h=figure;hold on;
a=[];
for i=1:length(pse)
    ind=find(R.puff.pid==pse(i,1) & R.puff.sid==pse(i,2) & R.puff.eid==pse(i,3));
    plot(R.puff.timestamp(ind)+20*i,'-bo');
    plot(xlim,[20,20]*i,'k:');
    a{i}=R.puff.timestamp(ind);
%    if i==10, break;end;
end
xlabel('Time difference between two puffs');ylabel('Episodes');title('Time difference between two puffs throughout the smoking episode');
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold');
saveas(h,'D:\smoking_memphis\data\Memphis_Smoking_Lab\smoking_fig\timediff_between_puffs.png');

function P=select_groundtruth_acl(G,pid,sid,P,PICDIR)
for e=1:length(P.smoking_episode)
    if ~isfield(P.smoking_episode{e},'puff'), continue;end;
    if isempty(P.smoking_episode{e}.puff), continue;end;
    len=length(P.smoking_episode{e}.puff.acl.starttimestamp);
    P.smoking_episode{e}.puff.acl.valid=zeros(1,len);
end
picdir=[G.DIR.DATA G.DIR.SEP PICDIR];
filenames=dir(picdir);
for f=3:length(filenames)
    name=filenames(f).name;
    valid=str2num(name(1));
    if valid==0, continue;end;
    ppid=name(3:5);
    ssid=name(7:9);
    if strcmp(ppid,pid)~=1 || strcmp(ssid,sid)~=1, continue;end;
    e=str2num(name(11:12));
    p=str2num(name(14:15));
    P.smoking_episode{e}.puff.acl.valid(p)=1;    
end
end
%{
if strcmp(pid,'p02')==1 && strcmp(sid,'s03')==1, P=correct_p02_s03(G,P);end;
if strcmp(pid,'p02')==1 && strcmp(sid,'s04')==1, P=correct_p02_s04(G,P);end;
if strcmp(pid,'p02')==1 && strcmp(sid,'s08')==1, P=correct_p02_s08(G,P);end;
if strcmp(pid,'p03')==1 && strcmp(sid,'s01')==1, P=correct_p03_s01(G,P);end;
if strcmp(pid,'p03')==1 && strcmp(sid,'s02')==1, P=correct_p03_s02(G,P);end;
if strcmp(pid,'p03')==1 && strcmp(sid,'s03')==1, P=correct_p03_s03(G,P);end;
end

function P=correct_p02_s03(G,P)
P.smoking_episode{2}.puff.acl.valid(:)=1;
P.smoking_episode{3}.puff.acl.valid(1)=-1;
end
function P=correct_p02_s04(G,P)
P.smoking_episode{1}.puff.acl.valid(1)=-1;
end

function P=correct_p02_s08(G,P)
time=735811.134317;timestamp=convert_time_timestamp(G,datestr(time,G.TIME.FORMAT));P.smoking_episode{3}.puff.acl.starttimestamp(11)=timestamp;P.smoking_episode{3}.puff.acl.startmatlabtime(11)=time;
time=735811.134344;timestamp=convert_time_timestamp(G,datestr(time,G.TIME.FORMAT));P.smoking_episode{3}.puff.acl.endtimestamp(11)=timestamp;P.smoking_episode{3}.puff.acl.endmatlabtime(11)=time;
time=735811.134443;timestamp=convert_time_timestamp(G,datestr(time,G.TIME.FORMAT));P.smoking_episode{3}.puff.acl.starttimestamp(12)=timestamp;P.smoking_episode{3}.puff.acl.startmatlabtime(12)=time;
time=735811.134465;timestamp=convert_time_timestamp(G,datestr(time,G.TIME.FORMAT));P.smoking_episode{3}.puff.acl.endtimestamp(12)=timestamp;P.smoking_episode{3}.puff.acl.endmatlabtime(12)=time;
P.smoking_episode{4}.puff.acl.valid(1)=-1;
end


function P=correct_p03_s01(G,P)
P.smoking_episode{1}.puff.acl.valid(1)=-1;
P.smoking_episode{3}.puff.acl.valid(1)=-1;
end
function P=correct_p03_s02(G,P)
P.smoking_episode{2}.puff.acl.valid(14)=-1;
end

function P=correct_p03_s03(G,P)

episode=2;P.smoking_episode{episode}.puff.acl.id=2;
len=length(P.smoking_episode{episode}.puff.timestamp);
starttimestamp=[1406917033658.5,1406917033658.5,1406917045283.5,1406917064054,1406917098179,1406917117991.5,1406917133804,1406917150804,1406917169679,1406917194866.5,1406917213741.5,1406917225366.5];
endtimestamp=  [1406917036471,1406917036471,1406917048783.5,1406917067366.5,1406917102116.5,1406917121866.5,1406917137366.5,1406917154554,1406917173116.5,1406917198116.5,1406917217616.5,1406917228116.5];
P.smoking_episode{episode}.puff.acl.valid(1)=-1;
ind=find(starttimestamp~=-1);
P.smoking_episode{episode}.puff.acl.starttimestamp=starttimestamp;
P.smoking_episode{episode}.puff.acl.endtimestamp=endtimestamp;
P.smoking_episode{episode}.puff.acl.startmatlabtime=ones(1,len)*-1;P.smoking_episode{episode}.puff.acl.startmatlabtime(ind)=convert_timestamp_matlabtimestamp(G,starttimestamp(ind));
P.smoking_episode{episode}.puff.acl.endmatlabtime  =ones(1,len)*-1;P.smoking_episode{episode}.puff.acl.endmatlabtime(ind)=convert_timestamp_matlabtimestamp(G,endtimestamp(ind));
%P.smoking_episode{episode}.puff.acl.valid(:)=-1;
end
%}
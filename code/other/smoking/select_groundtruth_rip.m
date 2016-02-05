function P=select_groundtruth_rip(G,pid,sid,P,PICDIR)
    for e=1:length(P.smoking_episode)
        if ~isfield(P.smoking_episode{e},'puff'), continue;end;
        if isempty(P.smoking_episode{e}.puff), continue;end;
        len=length(P.smoking_episode{e}.puff.acl.starttimestamp);
        P.smoking_episode{e}.puff.gyr.valid_rip=zeros(1,len);
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
        P.smoking_episode{e}.puff.gyr.valid_rip(p)=1;    
    end
end

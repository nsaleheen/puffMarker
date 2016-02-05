function P=calculate_missing_handmark(G, P)
for i=1:2
    if i==2, IDS=G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_GYRZID;else IDS=G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_GYRZID;end
    P.wrist{i}.acl.segment.missing=zeros(1,length(P.wrist{i}.acl.segment.starttimestamp));
    
    for j=1:length(P.wrist{i}.acl.segment.starttimestamp)
        stime=P.wrist{i}.acl.segment.starttimestamp(j)-1000;
        etime=P.wrist{i}.acl.segment.endtimestamp(j)+1000;
        for id=IDS
            ind=find(P.sensor{id}.timestamp>=stime & P.sensor{id}.timestamp<=etime);
            P.wrist{i}.acl.segment.missing(j)=max(P.wrist{i}.acl.segment.missing(j),1-length(ind)/(G.SENSOR.ID(id).FREQ*(etime-stime)/1000));
        end
   
    end
end
for e=1:length(P.smoking_episode)
    if isempty(P.smoking_episode{e}.puff), continue;end;
    if P.smoking_episode{e}.puff.acl.id==2, IDS=G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_GYRZID;else IDS=G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_GYRZID;end
    P.smoking_episode{e}.puff.acl.missing=zeros(1,length(P.smoking_episode{e}.puff.acl.starttimestamp));
    for p=1:length(P.smoking_episode{e}.puff.acl.starttimestamp)
%        if P.smoking_episode{e}.puff.acl.valid(p)~=0, continue;end;
        stime=P.smoking_episode{e}.puff.acl.starttimestamp(p)-1000;
        etime=P.smoking_episode{e}.puff.acl.endtimestamp(p)+1000;
        P.smoking_episode{e}.puff.acl.missing(p)=0;
        for id=IDS
            ind=find(P.sensor{id}.timestamp>=stime & P.sensor{id}.timestamp<=etime);
            P.smoking_episode{e}.puff.acl.missing(p)=max(P.smoking_episode{e}.puff.acl.missing(p),1-length(ind)/(G.SENSOR.ID(id).FREQ*(etime-stime)/1000));
        end
    end
end
%fprintf('%s %s total=%d missing=%d ok=%d\n',pid,sid,total,missing,total-missing);
end

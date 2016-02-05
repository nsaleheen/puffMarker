function P=find_mark_gyr(G,P)
P.wrist{1}.gyr.segment.puff=zeros(1,length(P.wrist{1}.gyr.segment.starttimestamp));
P.wrist{2}.gyr.segment.puff=zeros(1,length(P.wrist{2}.gyr.segment.starttimestamp));
P.wrist{1}.gyr.segment.episode=zeros(1,length(P.wrist{1}.gyr.segment.starttimestamp));
P.wrist{2}.gyr.segment.episode=zeros(1,length(P.wrist{2}.gyr.segment.starttimestamp));

for e=1:length(P.smoking_episode)
    if isempty(P.smoking_episode{e}.puff), continue;end;
    P.smoking_episode{e}.puff.gyr=P.smoking_episode{e}.puff.acl;
    len=length(P.smoking_episode{e}.puff.acl.starttimestamp);
    P.smoking_episode{e}.puff.gyr.starttimestamp=ones(1,len)*-1;P.smoking_episode{e}.puff.gyr.endtimestamp=ones(1,len)*-1;
    P.smoking_episode{e}.puff.gyr.startmatlabtime=ones(1,len)*-1;P.smoking_episode{e}.puff.gyr.endmatlabtime=ones(1,len)*-1;
    P.smoking_episode{e}.puff.gyr.seg_ind=ones(1,len)*-1;
    P.smoking_episode{e}.puff.gyr.valid=zeros(1,len);
    
    i=P.smoking_episode{e}.puff.acl.id;
    ind=find(P.wrist{i}.gyr.segment.valid_height==0);
    starttimestamp=P.wrist{i}.gyr.segment.starttimestamp(ind);
    endtimestamp=P.wrist{i}.gyr.segment.endtimestamp(ind);
    se=P.smoking_episode{e}.starttimestamp;ee=P.smoking_episode{e}.endtimestamp;
    ii= P.wrist{1}.gyr.segment.starttimestamp>=se & P.wrist{1}.gyr.segment.endtimestamp<=ee;P.wrist{1}.gyr.segment.episode(ii)=e;
    ii= P.wrist{2}.gyr.segment.starttimestamp>=se & P.wrist{2}.gyr.segment.endtimestamp<=ee;P.wrist{2}.gyr.segment.episode(ii)=e;    
    for p=1:length(P.smoking_episode{e}.puff.acl.starttimestamp)
%        if P.smoking_episode{e}.puff.acl.missing(p)>0.33, continue;end;
        P.smoking_episode{e}.puff.gyr.valid(p)=P.smoking_episode{e}.puff.acl.valid(p);
        if P.smoking_episode{e}.puff.acl.valid(p)~=0, continue;end;
        pstime=P.smoking_episode{e}.puff.acl.starttimestamp(p)-1500;
        petime=P.smoking_episode{e}.puff.acl.endtimestamp(p)+1500;
        x=find(starttimestamp>=pstime & endtimestamp<=petime);
        if ~isempty(x),
            [~,b]=max(endtimestamp(x)-starttimestamp(x));
            P.wrist{i}.gyr.segment.puff(ind(x(b)))=1;
            P.smoking_episode{e}.puff.gyr.missing(p)=P.smoking_episode{e}.puff.acl.missing(p);
            P.wrist{i}.gyr.segment.missing(ind(x(b)))=P.smoking_episode{e}.puff.gyr.missing(p);
            P.smoking_episode{e}.puff.gyr.starttimestamp(p)=starttimestamp(x(b));
            P.smoking_episode{e}.puff.gyr.endtimestamp(p)=endtimestamp(x(b));
            P.smoking_episode{e}.puff.gyr.startmatlabtime(p)=convert_timestamp_matlabtimestamp(G,starttimestamp(x(b)));
            P.smoking_episode{e}.puff.gyr.endmatlabtime(p)=convert_timestamp_matlabtimestamp(G,endtimestamp(x(b)));
            P.smoking_episode{e}.puff.gyr.valid(p)=0;
            P.smoking_episode{e}.puff.gyr.seg_ind(p)=ind(x(b));
        else
            P.smoking_episode{e}.puff.gyr.valid(p)=-2;
        end
    end
end
end

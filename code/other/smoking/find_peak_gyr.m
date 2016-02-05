function P=find_peak_gyr(G,P)

for e=1:length(P.smoking_episode)
    if isempty(P.smoking_episode{e}.puff), continue;end;
    i=P.smoking_episode{e}.puff.acl.id;
    P.smoking_episode{e}.puff.gyr_peak.id=i;
    for p=1:length(P.smoking_episode{e}.puff.acl.starttimestamp)
        %        if P.smoking_episode{e}.puff.acl.missing(p)==1, continue;end;
        if P.smoking_episode{e}.puff.acl.valid(p)~=0, continue;end;
            pstime=P.smoking_episode{e}.puff.acl.starttimestamp(p)-1000;
            petime=P.smoking_episode{e}.puff.acl.endtimestamp(p)+1000;
            ind=find(P.wrist{i}.gyr.magnitude.timestamp>=pstime & P.wrist{i}.gyr.magnitude.timestamp<=petime);
            [a,b]=max(P.wrist{i}.gyr.magnitude.sample(ind));            loc=ind(b);
            P.smoking_episode{e}.puff.gyr_peak.starttimestamp(p)=P.wrist{i}.gyr.magnitude.timestamp(loc);
            P.smoking_episode{e}.puff.gyr_peak.startmatlabtime(p)=P.wrist{i}.gyr.magnitude.startmatlabtime(loc);
            P.smoking_episode{e}.puff.gyr_peak.peakvalue_s(p)=P.wrist{i}.gyr.magnitude.sample(loc);
            P.smoking_episode{e}.puff.gyr_peak.peak_sind(p)=loc;
        
    end
end
end

function P=find_mark_acl(G, P)
P.wrist{1}.acl.segment.puff=zeros(1,length(P.wrist{1}.acl.segment.starttimestamp));
P.wrist{2}.acl.segment.puff=zeros(1,length(P.wrist{2}.acl.segment.starttimestamp));

for episode=1:length(P.smoking_episode)
    dist(1)=0;dist(2)=0;seg_ind=[];seg_ind{1}=[];seg_ind{2}=[];
    if ~isfield(P.smoking_episode{episode},'puff'), continue;end
    if ~isfield(P.smoking_episode{episode}.puff,'timestamp'), continue;end
    
    for i=1:2
        for p=1:length(P.smoking_episode{episode}.puff.timestamp)
            [s,d]=find_segment(P.wrist{i}.acl.segment.starttimestamp,P.wrist{i}.acl.segment.endtimestamp,P.smoking_episode{episode}.puff.timestamp(p));
            dist(i)=dist(i)+d;seg_ind{i}=[seg_ind{i},s];
        end
    end
    if dist(1)<dist(2), id=1;else   id=2; end
    seg_ind=seg_ind{id};
    P.smoking_episode{episode}.puff.acl.id=id;
    P.smoking_episode{episode}.puff.acl.starttimestamp=P.wrist{id}.acl.segment.starttimestamp(seg_ind);
    P.smoking_episode{episode}.puff.acl.endtimestamp=P.wrist{id}.acl.segment.endtimestamp(seg_ind);
    P.smoking_episode{episode}.puff.acl.startmatlabtime=P.wrist{id}.acl.segment.startmatlabtime(seg_ind);
    P.smoking_episode{episode}.puff.acl.endmatlabtime=P.wrist{id}.acl.segment.endmatlabtime(seg_ind);
    P.smoking_episode{episode}.puff.acl.valid=zeros(1,length(seg_ind));
    P.smoking_episode{episode}.puff.acl.META_VALID='0:valid -1:wrong_mark  1:missing';
    P.smoking_episode{episode}.puff.acl.seg_ind=seg_ind;
    P.wrist{id}.acl.segment.puff(seg_ind)=1;
end
end

function [segid,dist]=find_segment(starttimestamp,endtimestamp,marktime)
segid=-1;dist=inf;
if isempty(starttimestamp), return;end;
[dist1,pos1]=min(abs(starttimestamp-marktime));
[dist2,pos2]=min(abs(endtimestamp-marktime));
if dist1<dist2,segid=pos1;dist=dist1;else segid=pos2;dist=dist2;end
end

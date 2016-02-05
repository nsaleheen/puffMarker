function P=segmentation2_gyr(G, P,TH)

for i=1:2
    i=2;
%    sample=smooth(medfilt1(P.wrist{i}.gyr.magnitude.sample,25),25,'moving');    
    sample=smooth(P.wrist{i}.gyr.magnitude.sample,25,'moving');    
    
    timestamp=P.wrist{i}.gyr.magnitude.timestamp;
    sample(isnan(sample))=0;
    [mv1,mv2,pos1,pos2]=find_macd_intersect(sample,161,17,12);
%    x=find(pos1-pos2<15 | pos1-pos2>160);
%    pos1(x)=[];pos2(x)=[];
    length(pos1)
    plot(timestamp,sample);hold on;
    plot(timestamp(pos1),sample(pos1),'g.');
    plot(timestamp(pos2),sample(pos2),'r.');
    
    sample_800=smooth(sample,17,'moving');
    sample_8000=smooth(sample,161,'moving');
    res=sample_8000-sample_800;
    res(isnan(res))=0;
    segment=gyr_segmentation(res,TH,1);
    sind=segment(1:2:end);eind=segment(2:2:end);
    P.wrist{i}.gyr.segment.starttimestamp=P.wrist{i}.gyr.magnitude.timestamp(sind);
    P.wrist{i}.gyr.segment.endtimestamp=P.wrist{i}.gyr.magnitude.timestamp(eind);
    P.wrist{i}.gyr.segment.startmatlabtime=P.wrist{i}.gyr.magnitude.matlabtime(sind);
    P.wrist{i}.gyr.segment.endmatlabtime=P.wrist{i}.gyr.magnitude.matlabtime(eind);
    P.wrist{i}.gyr.segment.length_gyr=P.wrist{i}.gyr.segment.endtimestamp-P.wrist{i}.gyr.segment.starttimestamp;
end
end

function segment=gyr_segmentation(sample,THRESHOLD,NEAR)
segment=[];
ind=find(sample>=THRESHOLD);
if isempty(ind), return;end;
segment(1)=ind(1);
segment(2)=ind(1);
now=2;
for i=2:length(ind)
    if ind(i)<=segment(now)+NEAR, segment(now)=ind(i);
    else now=now+1;segment(now)=ind(i);now=now+1;segment(now)=ind(i);
    end
end
end

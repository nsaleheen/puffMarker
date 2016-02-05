function P=segmentation_gyr(G, P, TH)

for i=1:2
    P.wrist{i}.gyr.magnitude.threshold=TH;
    sample=medfilt1(P.wrist{i}.gyr.magnitude.sample,9);
    P.wrist{i}.gyr.magnitude.sample_filtered=sample;
    segment=gyr_segmentation(sample,P.wrist{i}.gyr.magnitude.threshold,4);
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
ind=find(sample<=THRESHOLD);
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

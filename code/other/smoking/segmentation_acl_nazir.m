function P=segmentation_acl_nazir(G, P, YTHRESHOLD)

P.wrist{1}.acl.sample=-P.sensor{G.SENSOR.WL9_ACLYID}.sample;P.wrist{1}.acl.matlabtime=P.sensor{G.SENSOR.WL9_ACLYID}.matlabtime;P.wrist{1}.acl.timestamp=P.sensor{G.SENSOR.WL9_ACLYID}.timestamp;
P.wrist{2}.acl.sample= P.sensor{G.SENSOR.WR9_ACLYID}.sample;P.wrist{2}.acl.matlabtime=P.sensor{G.SENSOR.WR9_ACLYID}.matlabtime;P.wrist{2}.acl.timestamp=P.sensor{G.SENSOR.WR9_ACLYID}.timestamp;

for i=1:2
    [ss,aaa]= smooth(P.wrist{i}.acl.sample, 150,'moving');
    
    P.wrist{i}.acl.threshold=YTHRESHOLD;
    s=medfilt1(P.wrist{i}.acl.sample,11);
    
    P.wrist{i}.acl.sample_filtered=s;
   
    segment=acl_segmentation_nazir(s,ss,P.wrist{i}.acl.threshold,4);
    
    sind=segment(1:2:end);eind=segment(2:2:end);
    eind=eind+1;
    x=find(eind>length(P.wrist{i}.acl.timestamp));
    eind(x)=eind(x)-1;
    P.wrist{i}.acl.segment.starttimestamp=P.wrist{i}.acl.timestamp(sind);
    P.wrist{i}.acl.segment.endtimestamp=P.wrist{i}.acl.timestamp(eind);
    P.wrist{i}.acl.segment.startmatlabtime=P.wrist{i}.acl.matlabtime(sind);
    P.wrist{i}.acl.segment.endmatlabtime=P.wrist{i}.acl.matlabtime(eind);
end
end
function segment=acl_segmentation_nazir(sample,baseline, THRESHOLD,NEAR)
 size(sample)
    size(baseline)
sample1 = sample - baseline';
segment=[];
ind=find(sample1>THRESHOLD*.15);
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

function segment=acl_segmentation(sample,THRESHOLD,NEAR)
segment=[];
ind=find(sample>THRESHOLD);
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

function sample=max_smooth(sample, val)
%     max_sample = zeros(length(sample));
    for i=2:length(sample)
        offset=max(1, i-val);
        max_val=max(sample(offset:i));
        sample(i)=max_val;
    end
end

function segment=acl_segmentation_based_on_max(sample,THRESHOLD,NEAR)
segment=[];
ind=find(sample>THRESHOLD);
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



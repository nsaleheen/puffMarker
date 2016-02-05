function hand=wrist_features(G,P)
IDS{1}=G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_GYRZID;
IDS{2}=G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_GYRZID;
P.sensor{G.SENSOR.WL9_ACLYID}.sample=-P.sensor{G.SENSOR.WL9_ACLYID}.sample;
for i=1:2
    hand{i}.feature=[];
    vind=find(P.wrist{i}.gyr.segment.valid_all==0);
    hand{i}.ind=vind;
    hand{i}.starttimestamp=P.wrist{i}.gyr.segment.starttimestamp(vind);
    hand{i}.endtimestamp=P.wrist{i}.gyr.segment.endtimestamp(vind);
    hand{i}.peak_ind=P.wrist{i}.gyr.segment.peak_ind(vind);
    if ~isfield(P.wrist{i}.gyr.segment,'puff'), hand{i}.puff=zeros(1,length(vind));
    else hand{i}.puff=P.wrist{i}.gyr.segment.puff(vind);
    end
    hand{i}.missing=P.wrist{i}.gyr.segment.missing(vind);
    if ~isfield(P.wrist{i}.gyr.segment,'episode'), hand{i}.episode=zeros(1,length(vind));
    else hand{i}.episode=P.wrist{i}.gyr.segment.episode(vind);end
    fprintf('len: %d\n', length(hand{i}.starttimestamp));
    for s=1:length(hand{i}.starttimestamp)
        stime=hand{i}.starttimestamp(s);
        etime=hand{i}.endtimestamp(s);
        [a,b]=binarysearch(P.wrist{i}.timestamp,stime,etime);
        sample=P.wrist{i}.magnitude(a:b);   hand=feature_stat(hand,sample,i,s,1:4,'Magnitude');
        hand{i}.feature(5,s)=etime-stime;        hand{i}.featurename{5}='Wrist Duration';
        sample=P.wrist{i}.pitch(a:b);       hand=feature_stat(hand,sample,i,s,6:9,'Pitch');
        sample=P.wrist{i}.roll(a:b);        hand=feature_stat(hand,sample,i,s,10:13,'Roll');
        
        [a,b]=binarysearch(P.sensor{IDS{i}(1)}.timestamp,stime,etime);
        sample=P.sensor{IDS{i}(1)}.sample(a:b);        hand=feature_stat(hand,sample,i,s,14:17,'x_axis');

        [a,b]=binarysearch(P.sensor{IDS{i}(2)}.timestamp,stime,etime);
        sample=P.sensor{IDS{i}(2)}.sample(a:b);        hand=feature_stat(hand,sample,i,s,18:21,'y_axis');
        [a,b]=binarysearch(P.sensor{IDS{i}(3)}.timestamp,stime,etime);

        sample=P.sensor{IDS{i}(3)}.sample(a:b);        hand=feature_stat(hand,sample,i,s,22:25,'z_axis');

        %       now=14;
%        for id=IDS{i}
%            [a,b]=binarysearch(P.sensor{id}.timestamp,stime-2500,stime-500);
%            sample=P.sensor{id}.sample(a:b);
%            hand=feature_stat_max(hand,sample,i,s,now:now+4,[G.SENSOR.ID(id).NAME '_left']);
%            [a,b]=binarysearch(P.sensor{id}.timestamp,etime+500,etime+2500);
%            sample=P.sensor{id}.sample(a:b);
%            hand=feature_stat_max(hand,sample,i,s,now+5:now+9,[G.SENSOR.ID(id).NAME '_right']);
%            now=now+5;
%        end
        
    end
end
end

function hand=feature_stat(hand,sample,i,s,id,name)
if isempty(sample),
    for idd=id,    hand{i}.feature(idd,s)=NaN;end
else

hand{i}.feature(id(1),s)=mean(sample);hand{i}.featurename{id(1)}=[name '(Mean)'];
hand{i}.feature(id(2),s)=median(sample);hand{i}.featurename{id(2)}=[name '(Median)'];
hand{i}.feature(id(3),s)=std(sample);hand{i}.featurename{id(3)}=[name '(STD)'];
hand{i}.feature(id(4),s)=prctile(sample,75)-prctile(sample,25);hand{i}.featurename{id(4)}=[name '(Quartile)'];
end
end
function hand=feature_stat_max(hand,sample,i,s,id,name)
if isempty(sample),
    for idd=id,    hand{i}.feature(idd,s)=NaN;end
else
hand{i}.feature(id(1),s)=mean(sample);hand{i}.featurename{id(1)}=[name '(Mean)'];
hand{i}.feature(id(2),s)=median(sample);hand{i}.featurename{id(2)}=[name '(Median)'];
hand{i}.feature(id(3),s)=std(sample);hand{i}.featurename{id(3)}=[name '(STD)'];
hand{i}.feature(id(4),s)=prctile(sample,75)-prctile(sample,25);hand{i}.featurename{id(4)}=[name '(Quartile)'];
hand{i}.feature(id(5),s)=max(sample);hand{i}.featurename{id(5)}=[name '(Maximum)'];
end
end

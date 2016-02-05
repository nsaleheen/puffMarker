function P=calculate_roll_pitch_segment(G,P)
for i=1:2
    if i==1,ids=G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_ACLZID;else, ids=G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_ACLZID;end
    for s=1:length(P.wrist{i}.gyr.segment.starttimestamp)
        if P.wrist{i}.gyr.segment.valid_height(s)==1,
        P.wrist{i}.gyr.segment.pitch_mean(s)=-1;
        P.wrist{i}.gyr.segment.pitch_median(s)=-1;
        P.wrist{i}.gyr.segment.roll_mean(s)=-1;
        P.wrist{i}.gyr.segment.roll_median(s)=-1;
        continue;
        end
        stime=P.wrist{i}.gyr.segment.starttimestamp(s);
        etime=P.wrist{i}.gyr.segment.endtimestamp(s);
        ind=find(P.sensor{ids(1)}.timestamp>=stime & P.sensor{ids(1)}.timestamp<=etime);XM=mean(P.sensor{ids(1)}.sample(ind));XD=median(P.sensor{ids(1)}.sample(ind));
        ind=find(P.sensor{ids(2)}.timestamp>=stime & P.sensor{ids(2)}.timestamp<=etime);YM=mean(P.sensor{ids(2)}.sample(ind));YD=median(P.sensor{ids(2)}.sample(ind));
        ind=find(P.sensor{ids(3)}.timestamp>=stime & P.sensor{ids(3)}.timestamp<=etime);ZM=mean(P.sensor{ids(3)}.sample(ind));ZD=median(P.sensor{ids(3)}.sample(ind));
        [P.wrist{i}.gyr.segment.roll_median_v2(s),P.wrist{i}.gyr.segment.pitch_median_v2(s)]=calculate_roll_pitch_new(XD,YD,ZD);
        [P.wrist{i}.gyr.segment.roll_mean_v2(s),P.wrist{i}.gyr.segment.pitch_mean_v2(s)]=calculate_roll_pitch_new(XM,YM,ZM);
        
        [ss,ee]=binarysearch(P.wrist{i}.timestamp,stime,etime);
        ind=ss:ee;
        
        P.wrist{i}.gyr.segment.pitch_mean(s)=mean(P.wrist{i}.pitch(ind));
        P.wrist{i}.gyr.segment.pitch_median(s)=median(P.wrist{i}.pitch(ind));
        P.wrist{i}.gyr.segment.roll_mean(s)=mean(P.wrist{i}.roll(ind));
        P.wrist{i}.gyr.segment.roll_median(s)=median(P.wrist{i}.roll(ind));
    end
end
end

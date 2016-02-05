function P=calculate_missing_handmark_gyr(G, P)
for i=1:2
    if i==2, IDS=G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_GYRZID;else IDS=G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_GYRZID;end
    P.wrist{i}.gyr.segment.missing=zeros(1,length(P.wrist{i}.gyr.segment.starttimestamp));
    
    for j=1:length(P.wrist{i}.gyr.segment.starttimestamp)
        stime=P.wrist{i}.gyr.segment.starttimestamp(j)-1000;
        etime=P.wrist{i}.gyr.segment.endtimestamp(j)+1000;
        for id=IDS
            [ss,ee]=binarysearch(P.sensor{id}.timestamp,stime,etime);
            ind=ss:ee;
            
            P.wrist{i}.gyr.segment.missing(j)=max(P.wrist{i}.gyr.segment.missing(j),1-length(ind)/(G.SENSOR.ID(id).FREQ*(etime-stime)/1000));
        end   
    end
end
end

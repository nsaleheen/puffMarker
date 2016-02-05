function P=filter_segment_height(G,P,TH)
for i=1:2
    sample_800=P.wrist{i}.magnitude_800;
    sample_8000=P.wrist{i}.magnitude_8000;
    timestamp=P.wrist{i}.timestamp;
    P.wrist{i}.gyr.segment.valid_height=zeros(1,length(P.wrist{i}.gyr.segment.starttimestamp));
    for j=1:length(P.wrist{i}.gyr.segment.starttimestamp)
        stime=P.wrist{i}.gyr.segment.starttimestamp(j);
        etime=P.wrist{i}.gyr.segment.endtimestamp(j);
        [ss,ee]=binarysearch(timestamp,stime,etime);
        ind=ss:ee;
%        ind=find(timestamp>=stime & timestamp<=etime);
        
        if mean(sample_8000(ind)-sample_800(ind))<TH
            P.wrist{i}.gyr.segment.valid_height(j)=1;
        end
    end
end
end


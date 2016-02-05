function P=filter_segment_roll_pitch_gyr(G,P,RP)

for i=1:2
    P.wrist{i}.gyr.segment.valid_rp=zeros(1,length(P.wrist{i}.gyr.segment.starttimestamp));
    x=(P.wrist{i}.gyr.segment.pitch_median-RP.PITCH_MEAN)/RP.PITCH_STD;
%    y=(P.wrist{i}.gyr.segment.roll_median-RP.ROLL_MEAN(i))/RP.ROLL_STD(i);
    error=x.*x;%+y.*y;

    ind=find(error>RP.TH(1));
    P.wrist{i}.gyr.segment.error_rp=error;
    P.wrist{i}.gyr.segment.valid_rp(ind)=1;
end
end

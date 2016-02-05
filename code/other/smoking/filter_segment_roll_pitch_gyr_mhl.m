function P=filter_segment_roll_pitch_gyr_mhl(G, P,RP)

SIGMA=RP.SIGMA;
MN=RP.MEAN;
ERR=RP.TH(4);
for i=1:2
    P.wrist{i}.gyr.segment.valid_rp=zeros(1,length(P.wrist{i}.gyr.segment.starttimestamp));
    for s=1:length(P.wrist{i}.gyr.segment.starttimestamp)
        x(1)=P.wrist{i}.gyr.segment.roll_median(s);
        x(2)=P.wrist{i}.gyr.segment.pitch_median(s);
        err=(x-MN)*inv(SIGMA)*(x-MN)';
        if err>ERR,
            P.wrist{i}.gyr.segment.valid_rp(s)=1;
        end
    end
end

end

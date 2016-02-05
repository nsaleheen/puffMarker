function P=moving_avg_gyro(G, P,WS,MOVE)
fprintf('...moving_avg');
for i=1:2
    for j=1:length(P.wrist{i}.gyr.magnitude.starttimestamp)
    end
    [P.wrist{1}.roll.sample,P.wrist{1}.pitch.sample,timestamp]=calculate_roll(P,[G.SENSOR.WL9_ACLXID,G.SENSOR.WL9_ACLYID,G.SENSOR.WL9_ACLZID]);
    P.wrist{1}.roll.timestamp=timestamp;P.wrist{1}.pitch.timestamp=timestamp;
    [P.wrist{2}.roll.sample,P.wrist{2}.pitch.sample,timestamp]=calculate_roll(P,[G.SENSOR.WR9_ACLXID,G.SENSOR.WR9_ACLYID,G.SENSOR.WR9_ACLZID]);
    P.wrist{2}.roll.timestamp=timestamp;P.wrist{2}.pitch.timestamp=timestamp;
    
    P.wrist{1}.roll.matlabtime=convert_timestamp_matlabtimestamp(G,P.wrist{1}.roll.timestamp);
    P.wrist{2}.roll.matlabtime=convert_timestamp_matlabtimestamp(G,P.wrist{2}.roll.timestamp);
    P.wrist{1}.pitch.matlabtime=convert_timestamp_matlabtimestamp(G,P.wrist{1}.pitch.timestamp);
    P.wrist{2}.pitch.matlabtime=convert_timestamp_matlabtimestamp(G,P.wrist{2}.pitch.timestamp);
end
end

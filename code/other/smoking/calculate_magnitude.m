function P=calculate_magnitude(G, P)
fprintf('...magnitude');
[P.wrist{1}.magnitude,P.wrist{1}.timestamp]=find_magnitude(P,G.SENSOR.WL9_GYRXID:G.SENSOR.WL9_GYRZID);
[P.wrist{2}.magnitude,P.wrist{2}.timestamp]=find_magnitude(P,G.SENSOR.WR9_GYRXID:G.SENSOR.WR9_GYRZID);
P.wrist{1}.matlabtime=convert_timestamp_matlabtimestamp(G,P.wrist{1}.timestamp);
P.wrist{2}.matlabtime=convert_timestamp_matlabtimestamp(G,P.wrist{2}.timestamp);
P.wrist{1}.magnitude_800=smooth(P.wrist{1}.magnitude,13,'moving');
P.wrist{2}.magnitude_800=smooth(P.wrist{2}.magnitude,13,'moving');
P.wrist{1}.magnitude_8000=smooth(P.wrist{1}.magnitude,131,'moving');
P.wrist{2}.magnitude_8000=smooth(P.wrist{2}.magnitude,131,'moving');
end
function [mag,timestamp]=find_magnitude(P,IDS)
mag=zeros(1,length(P.sensor{IDS(1)}.sample_interpolate));
for id=IDS
    mag=mag+P.sensor{id}.sample_interpolate.*P.sensor{id}.sample_interpolate;
end
mag=sqrt(mag);
timestamp=P.sensor{IDS(1)}.timestamp_interpolate;
end

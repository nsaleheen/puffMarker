function P=calculate_magnitude_nazir(G, P)
fprintf('...magnitude');
[P.wrist{1}.magnitude,P.wrist{1}.timestamp]=find_magnitude(P,G.SENSOR.WL9_GYRXID:G.SENSOR.WL9_GYRZID);
[P.wrist{2}.magnitude,P.wrist{2}.timestamp]=find_magnitude(P,G.SENSOR.WR9_GYRXID:G.SENSOR.WR9_GYRZID);
[P.wrist{1}.magnitudeXZ,P.wrist{1}.timestamp]=find_magnitudeXZ(P,G.SENSOR.WL9_GYRXID, G.SENSOR.WL9_GYRZID);
[P.wrist{2}.magnitudeXZ,P.wrist{2}.timestamp]=find_magnitudeXZ(P,G.SENSOR.WR9_GYRXID, G.SENSOR.WR9_GYRZID);
P.wrist{1}.matlabtime=convert_timestamp_matlabtimestamp(G,P.wrist{1}.timestamp);
P.wrist{2}.matlabtime=convert_timestamp_matlabtimestamp(G,P.wrist{2}.timestamp);
P.wrist{1}.magnitude_800=smooth(P.wrist{1}.magnitude,13,'moving');
P.wrist{2}.magnitude_800=smooth(P.wrist{2}.magnitude,13,'moving');
P.wrist{1}.magnitude_8000=smooth(P.wrist{1}.magnitude_800,131,'moving');
P.wrist{2}.magnitude_8000=smooth(P.wrist{2}.magnitude_800,131,'moving');
P.sensor{G.SENSOR.WL9_ACLYID}.sample_interpolate_smooth800=smooth(P.sensor{G.SENSOR.WL9_ACLYID}.sample_interpolate,13,'moving');
P.sensor{G.SENSOR.WR9_ACLYID}.sample_interpolate_smooth800=smooth(P.sensor{G.SENSOR.WR9_ACLYID}.sample_interpolate,13,'moving');

end
function [mag,timestamp]=find_magnitude(P,IDS)
mag=zeros(1,length(P.sensor{IDS(1)}.sample_interpolate));
for id=IDS
    mag=mag+P.sensor{id}.sample_interpolate.*P.sensor{id}.sample_interpolate;
end
mag=sqrt(mag);
timestamp=P.sensor{IDS(1)}.timestamp_interpolate;
end

function [mag,timestamp]=find_magnitudeXZ(P,idX, idZ)
mag=P.sensor{idX}.sample_interpolate - P.sensor{idZ}.sample_interpolate;
mag = mag.*mag;
mag=sqrt(mag);
timestamp=P.sensor{idX}.timestamp_interpolate;
end

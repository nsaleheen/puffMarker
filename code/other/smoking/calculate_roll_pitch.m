function P=calculate_roll_pitch(G, P)
fprintf('...roll_pitch');
[P.wrist{1}.roll,P.wrist{1}.pitch]=calculate_roll_pitch_new(P.sensor{G.SENSOR.WL9_ACLXID}.sample_interpolate,-P.sensor{G.SENSOR.WL9_ACLYID}.sample_interpolate,P.sensor{G.SENSOR.WL9_ACLZID}.sample_interpolate);
[P.wrist{2}.roll,P.wrist{2}.pitch]=calculate_roll_pitch_new(P.sensor{G.SENSOR.WR9_ACLXID}.sample_interpolate,P.sensor{G.SENSOR.WR9_ACLYID}.sample_interpolate,P.sensor{G.SENSOR.WR9_ACLZID}.sample_interpolate);
end
%{
function [roll,pitch,timestamp]=calculate_roll(P,IDS)
roll=atan2d(P.sensor{IDS(1)}.sample_interpolate,-P.sensor{IDS(3)}.sample_interpolate);
pitch=atan2d(P.sensor{IDS(2)}.sample_interpolate,sqrt(P.sensor{IDS(1)}.sample_interpolate.*P.sensor{IDS(1)}.sample_interpolate+P.sensor{IDS(3)}.sample_interpolate.*P.sensor{IDS(3)}.sample_interpolate));
timestamp=P.sensor{IDS(1)}.timestamp_interpolate;
end
%}
%{
function [roll,pitch,timestamp]=calculate_roll(P,IDS)
roll=[];
pitch=[];
ind(1:length(IDS))=1;
for i=1:length(P.sensor{IDS(1)}.sample)
    sample(1)=P.sensor{IDS(1)}.sample(i);
    curtime=P.sensor{IDS(1)}.timestamp(i);
    for j=2:length(IDS)
        while ind(j)+1<=length(P.sensor{IDS(j)}.sample) && abs(P.sensor{IDS(j)}.timestamp(ind(j))-curtime)>abs(P.sensor{IDS(j)}.timestamp(ind(j)+1)-curtime),
            ind(j)=ind(j)+1;
        end
        sample(j)=P.sensor{IDS(j)}.sample(ind(j));
    end
    roll(end+1)=atan2d(sample(1),-sample(3));
    pitch(end+1)=atan2d(sample(2),sqrt(sample(1)*sample(1)+sample(3)*sample(3)));
end
timestamp=P.sensor{IDS(1)}.timestamp;
end

%}
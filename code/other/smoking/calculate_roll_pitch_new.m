function [roll,pitch]=calculate_roll_pitch_new(X,Y,Z)
%roll=atan2d(X,-Z);
%pitch=atan2d(Y,sqrt(X.*X+Z.*Z));
pitch=atan2d(-Y,-Z);
roll=atan2d(X,sqrt(Y.*Y+Z.*Z));

end

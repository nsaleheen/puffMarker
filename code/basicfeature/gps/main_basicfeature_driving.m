function driving = main_basicfeature_driving( G, sensor )
maxGaitSpeed = 2.533;
try
	driving = [];
	lats = sensor{G.SENSOR.P_GPS_LATID}.sample;
	longs = sensor{G.SENSOR.P_GPS_LONGID}.sample;
	alts = sensor{G.SENSOR.P_GPS_ALTID}.sample;
	speeds = sensor{G.SENSOR.P_GPS_SPDID}.sample;
	bears = sensor{G.SENSOR.P_GPS_BEAR}.sample;
	accuracys = sensor{G.SENSOR.P_GPS_ACCURACYID}.sample;
	timestamps = sensor{G.SENSOR.P_GPS_LATID}.timestamp;
	
	driving.sessions = driving_sessions(speeds, timestamps, maxGaitSpeed);
	driving.turns = driving_turns(driving.sessions, lats, longs, speeds, accuracys, timestamps, maxGaitSpeed);
	
catch e
	disp(e.message);
end

end


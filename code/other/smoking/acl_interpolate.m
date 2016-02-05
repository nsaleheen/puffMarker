function acl_interpolate()

increment = 1/(24*60*60*62.5);
timestampsM = ttFrom:increment:ttTo;
x = interp1(D.sensor{G.SENSOR.WR9_ACLXID}.matlabtime, xG, timestampsM); %rawX xG
end

function distance = calculateHaversineDistance( lat1, long1, lat2, long2 )
    radian = 57.2958;
    distance = 6371*acos(cos(long1/radian-long2/radian)*cos(lat1/radian)*cos(lat2/radian)+sin(lat1/radian)*sin(lat2/radian));
    distance = distance * 1000; % meter
end


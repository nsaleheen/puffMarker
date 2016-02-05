function [ iId, iLat, iLong, minDistance ] = findNearestIntersection( intersectionLatLong, lat, long )
    iId=intersectionLatLong(1,1);
    iLat=intersectionLatLong(1,2);
    iLong=intersectionLatLong(1,3);
    minDistance=calculateHaversineDistance(lat, long, intersectionLatLong(1,2),intersectionLatLong(1,2));
    withinThresholdsIndexes=find(intersectionLatLong(:,2)>(lat-0.04) & intersectionLatLong(:,2)<(lat+0.04) & ...
        intersectionLatLong(:,3)>(long-0.04) & intersectionLatLong(:,3)<(long+0.04));
    if isempty(withinThresholdsIndexes)
        minDistance = -1;
        iId = -1;
        iLat = -1000;
        iLong = -1000;
        return;
    end
    for j=1:length(withinThresholdsIndexes)
        i=withinThresholdsIndexes(j);
        distance = calculateHaversineDistance(lat, long, intersectionLatLong(i,2),intersectionLatLong(i,3));
        if distance<minDistance
            iId=intersectionLatLong(i,1);
            iLat=intersectionLatLong(i,2);
            iLong=intersectionLatLong(i,3);
            minDistance=distance;
        end
    end
end


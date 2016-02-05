function [ distance ] = calculatePathDistance( lats, longs )

    [row, col] = size(lats);
    if col<2
        distance = -1;
    else
        fromLat = lats(1);
        fromLong = longs(1);
        distance = 0;
        for i=2:col
            length = calculateHaversineDistance(fromLat, fromLong, lats(i), longs(i));
            distance = distance + length;
        end
    end
end


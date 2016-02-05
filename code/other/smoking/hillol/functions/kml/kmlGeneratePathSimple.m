function success = kmlGeneratePathSimple(fpOut, lats, longs, labels)

    %[row, col] = size(lats);
	col = numel(lats);
    if col<2
        success=0;
    else
        fromLat = lats(1);
        fromLong = longs(1);
        fromAlt = 0;%alts(1);
        for i = 2:col
            toLat = lats(i);
            toLong = longs(i);
            toAlt = 0;%alts(i);
			label = int2str(labels(i));
            description = label;
            if i == 1
                fromLat = toLat;
                fromLong = toLong;
                fromAlt = toAlt;
			end
			style = '#m_ylw-pushpinPathRed';
            fprintf(fpOut,'<Placemark>\n<name>%s</name>\n<description>%s</description>\n', label, description);
            fprintf(fpOut, '<styleUrl>%s</styleUrl>\n<LineString>\n<tessellate>1</tessellate>\n<coordinates>\n', style);
            fprintf(fpOut, '%f,%f,%f %f,%f,%f\n', fromLong, fromLat, fromAlt, toLong, toLat, toAlt);
            fprintf(fpOut, '</coordinates>\n</LineString>\n</Placemark>\n');
            fromLat = toLat;
            fromLong = toLong;
            fromAlt = toAlt;
        end
        success = 1;
    end
end
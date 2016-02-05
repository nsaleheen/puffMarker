function success = kmlGeneratePath(fpOut, G, lats, longs, alts, speeds, bears, accuracys, timestamps)

    %[row, col] = size(lats);
    col = numel(lats);
    if col<2
        success=0;
    else
        fromLat = lats(1);
        fromLong = longs(1);
        fromAlt = alts(1);
        for i = 2:col
            toLat = lats(i);
            toLong = longs(i);
            toAlt = alts(i);
			if timestamps(1) == 0
				label = '';
			else
				label = convert_timestamp_time(G, timestamps(i));
			end
            speedMpH = speeds(i)*2.24;
            description = ['Speed : ' num2str(speedMpH) ' mile/hour' char(10) ...
				'Accuracy : ' num2str(accuracys(i)) char(10) ...
				'Bears : ' num2str(bears(i), '%.2f') char(10) ...
				'Timestamp : ' num2str(timestamps(i))];
            if i == 1
                fromLat = toLat;
                fromLong = toLong;
                fromAlt = toAlt;
            end
            if speeds(i)>2.533
                style = '#m_ylw-pushpinPathRed';
            else
                style = '#m_ylw-pushpinPathGreen';
            end
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


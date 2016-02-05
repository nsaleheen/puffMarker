function [ lats, longs, alts, bears, speeds, accuracys, timestamps ] = getLocationData( participant, session )
%GETLOCATIONDATA Summary of this function goes here
%   Detailed explanation goes here

    gpsDir = 'C:\Users\Hillol Sarker\Desktop\Junk\gps';
    if (participant>=14 && participant<=32) || participant==35
        matGps = load([gpsDir '/data/matrix/rep' int2str(participant) '/f_p' int2str(participant) '_s' num2str(session,'%02d') '_frmtraw.mat']);
        lats = matGps.R.sensor(14).sample;
        longs = matGps.R.sensor(15).sample;
        alts = matGps.R.sensor(16).sample;
        bears = matGps.R.sensor(17).sample;
        speeds = matGps.R.sensor(18).sample;
        accuracys = matGps.R.sensor(19).sample;
        timestamps = matGps.R.sensor(14).timestamp;
    elseif (participant>=33 && participant<=34) || (participant>=36 && participant<=44)
        matGps = zeros(0,7);
        participantContentPath = [gpsDir '/data/raw/p' int2str(participant) '/'];
        dirSessions = dir(participantContentPath);
        [dirSessionsCount, a] = size(dirSessions);
        for s=1:dirSessionsCount
            if dirSessions(s).isdir ~= 1
                continue;
            end
            rawDir = [participantContentPath dirSessions(s).name '/'];
            files = dir(rawDir);
            [fileCount, a] = size(files);
            disp(['File count : ' int2str(fileCount)]);
            for i = 1:fileCount
                if files(i).isdir == 1
                    continue;
                end
                filePath = [rawDir files(i).name];
                %disp(['--- ' filePath]);
                fp = fopen(filePath, 'r');
                rows = textscan(fp, '%f %f %f %f %f %f %s %f', 'delimiter', ',');
                fclose(fp);
                rows = [rows{1:6} rows{8}];
                matGps = vertcat(matGps, rows);
            end
        end
        fp = fopen([participantContentPath 'session_def.csv'], 'r');
        sessDefs = textscan(fp, '%s %s %s %s %s %s %s %s %s %s', 'delimiter', ',');
        fclose(fp);
        sessions = sessDefs{6};
        sessionStart = sessDefs{8};
        sessionEnd = sessDefs{10};
        
        sess = sessions{session};
        startTime = sessionStart{session};
        endTime = sessionEnd{session};
        startTimestamp = convert_time_timestamp(startTime);
        endTimestamp = convert_time_timestamp(endTime);
        indexes = find(matGps(:,7)>=startTimestamp & matGps(:,7)<endTimestamp);
        currentMatGps = matGps(indexes, :);
        
        lats = currentMatGps(:,1)';
        longs = currentMatGps(:,2)';
        alts = currentMatGps(:,3)';
        bears = currentMatGps(:,4)';
        speeds = currentMatGps(:,5)';
        accuracys = currentMatGps(:,6)';
        timestamps = currentMatGps(:,7)';
    end

end


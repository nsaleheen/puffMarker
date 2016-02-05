function [ output_args ] = report_home_not_driving_csv( G, indir, outdir, participants, sessions )

fpHome = fopen([G.DIR.DATA G.DIR.SEP outdir G.DIR.SEP 'HomeNotDriving.csv'], 'w');
fprintf(fpHome, 'Participant,Session,Timestamp From,Timestamp To,Index From,Index 2,Duration(s),Max Diff Between Consecutive(s)\n');
%participant, session, ts1, ts2, x, y, durationSec, durationSec/60, sampleCount
participantLocations = csvread([G.DIR.DATA G.DIR.SEP outdir G.DIR.SEP 'ParticipantLocations.csv'], 1);

for participant = participants
	participantLocation = participantLocations(find(participantLocations(:,1) == participant),:);
	if numel(participantLocation)<=0
		disp(['Unable to load home location for participant :' int2str(participant) '\r\n']);
		continue;
	end
	homeLat = participantLocation(2);
	homeLong = participantLocation(3);
	if homeLat==-1 || homeLong==-1
		disp(['Unable to load home location for participant :' int2str(participant) '\r\n']);
		continue;
	end
	for session = sessions
		try
			disp(['Participant ' int2str(participant) ' Session ' int2str(session)]);
			basicPath = [G.DIR.DATA G.DIR.SEP indir G.DIR.SEP 'p' int2str(participant) '_s' num2str(session,'%.2d') '_frmtdata.mat'];
			if ~exist(basicPath, 'file')
				disp('File not exist');
				continue;
			end
			m = load(basicPath);
			
			lats=m.D.sensor{G.SENSOR.P_GPS_LATID}.sample;
			longs=m.D.sensor{G.SENSOR.P_GPS_LONGID}.sample;
			speeds=m.D.sensor{G.SENSOR.P_GPS_SPDID}.sample;
			timestamps=m.D.sensor{G.SENSOR.P_GPS_LATID}.timestamp;
			dtt=diff(timestamps);
			distanceFromHomeArr = zeros(numel(lats), 1);
			
			for i=1:numel(lats)
				distanceFromHomeArr(i) = calculateHaversineDistance(homeLat, homeLong, lats(i), longs(i));
			end
			homeStop = (speeds==0 & distanceFromHomeArr<100);
			episodes = get_episodes(homeStop);
			[episodeCount, columns] = size(episodes);
			for j=1:episodeCount
				x=episodes(j,1);
				y=episodes(j,2);
				ts1=timestamps(x);
				ts2=timestamps(y);
				durationSec = (ts2-ts1)/1000;
				%sampleIndexes = find(timestamps>=ts1 & timestamps<=ts2);
				%sampleCount = numel(sampleIndexes);
				maxDiffBetweenConsecutive=max(dtt(x:y-1))/1000;
				if durationSec>=60 && maxDiffBetweenConsecutive<60
					fprintf(fpHome, '%d,%d,%ld,%ld,%d,%d,%.2f,%.2f\n', participant, session, ts1, ts2, x, y, durationSec, maxDiffBetweenConsecutive);
				end
			end
		catch e
			disp(e.message);
		end
	end
end

fclose(fpHome);


end


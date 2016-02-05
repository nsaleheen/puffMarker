function [ output_args ] = report_driving_csv(G, indir, outdir, participants, sessions)

fpSessions = fopen([G.DIR.DATA G.DIR.SEP outdir G.DIR.SEP 'DrivingSessions.csv'], 'w');
fprintf(fpSessions, 'Participant,Session,Timestamp From,Timestamp To, Avg Speed(mile/hour)\r\n');

fpTurns = fopen([G.DIR.DATA G.DIR.SEP outdir G.DIR.SEP 'DrivingTurns.csv'], 'w');
fprintf(fpTurns, 'Participant,Session,Index,Timestamp,Latitude,Longitude,Angle(+ve right, -ve left)\r\n');

for participant = participants
	for session = sessions
		try
			disp(['Participant ' int2str(participant) ' Session ' int2str(session)]);
			basicPath = [G.DIR.DATA G.DIR.SEP indir G.DIR.SEP 'p' int2str(participant) '_s' num2str(session,'%.2d') '_basicfeature.mat'];
			if ~exist(basicPath, 'file')
				disp('File not exist');
				continue;
			end
			m = load(basicPath);
			[rowCount, colCount] = size(m.B.driving.sessions);
			for i=1:rowCount
				fprintf(fpSessions, '%d,%d,%ld,%ld,%.2f\r\n', participant, session, ...
					m.B.driving.sessions(i,1), m.B.driving.sessions(i,2), m.B.driving.sessions(i,3) );
			end
			[rowCount, colCount] = size(m.B.driving.turns);
			for i=1:rowCount
				fprintf(fpTurns, '%d,%d,%ld,%ld,%f,%f,%.2f\r\n', participant, session, ...
					m.B.driving.turns(i,1), m.B.driving.turns(i,2), m.B.driving.turns(i,3), ...
					m.B.driving.turns(i,4), m.B.driving.turns(i,5));
			end
		catch e
			disp(e.message);
		end
	end
end

fclose(fpSessions);
fclose(fpTurns);

end


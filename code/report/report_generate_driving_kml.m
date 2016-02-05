function report_generate_driving_kml(G, indirFormatteddata, indirBasicfeature, outdir, participant, sessions)

for session=sessions
%	try
		disp(['Generating driving kml for participant ' int2str(participant) ' session ' int2str(session)]);
		mD = load([G.DIR.DATA G.DIR.SEP indirFormatteddata G.DIR.SEP 'p' int2str(participant) '_s' num2str(session,'%.2d') '_frmtdata']);
		mF = load([G.DIR.DATA G.DIR.SEP indirBasicfeature G.DIR.SEP 'p' int2str(participant) '_s' num2str(session,'%.2d') '_basicfeature']);
		fpKml = fopen([G.DIR.DATA G.DIR.SEP outdir G.DIR.SEP 'Driving-Participant ' int2str(participant) ' Session ' int2str(session) '.kml'], 'w');
		
		skeletonPath = 'functions/kml/skleton_kml.txt';
		skeletonKml = getFileContent(skeletonPath);
		skeletonKmlParts = regexp(skeletonKml,'#PUT_CONTENT_HERE#', 'split');
		skeletonKmlHeader = char(skeletonKmlParts(1));
		skeletonKmlFooter = char(skeletonKmlParts(2));
		fprintf(fpKml, '%s', skeletonKmlHeader);
		
		lats = mD.D.sensor{G.SENSOR.P_GPS_LATID}.sample;
		longs = mD.D.sensor{G.SENSOR.P_GPS_LONGID}.sample;
		alts = mD.D.sensor{G.SENSOR.P_GPS_ALTID}.sample;
		speeds = mD.D.sensor{G.SENSOR.P_GPS_SPDID}.sample;
		bears = mD.D.sensor{G.SENSOR.P_GPS_BEAR}.sample;
		accuracys = mD.D.sensor{G.SENSOR.P_GPS_ACCURACYID}.sample;
		timestamps = mD.D.sensor{G.SENSOR.P_GPS_LATID}.timestamp;
		
		[rowCount, colCount] = size(mF.B.driving.sessions);
		for r = 1:rowCount
			ttFrom = mF.B.driving.sessions(r, 1);
			ttTo = mF.B.driving.sessions(r, 2);
			avgSpeed = mF.B.driving.sessions(r, 3);
			duration = (ttTo - ttFrom)/(60*1000);
			indexes = find(timestamps>=ttFrom & timestamps<=ttTo);
			kmlCreateFolder(fpKml, [int2str(r) ': ' num2str(avgSpeed, '%.2f') 'mph ' num2str(duration, '%.2f') 'min'], 0);
			
			kmlCreateFolder(fpKml, 'Path', 0);
			kmlGeneratePath(fpKml, G, ...
					lats(indexes), ...
					longs(indexes), ...
					alts(indexes), ...
					speeds(indexes), ...
					bears(indexes), ...
					accuracys(indexes), ...
					timestamps(indexes) );
			kmlCloseFolder(fpKml);
			kmlCloseFolder(fpKml);
			%{
			hold all;
			plot(timestamps(indexes), speeds(indexes));
			hold all;
			plot([timestamps(indexes(1)) timestamps(indexes(1))], [0 30], 'color', [1 0 0]);
			hold all;
			plot([timestamps(indexes(end)) timestamps(indexes(end))], [0 30], 'color', [0 1 0]);
			%}
		end
		
		kmlCreateFolder(fpKml, 'Turn', 0);
		[rowCount, colCount] = size(mF.B.driving.turns);
		for r = 1:rowCount
			indexTurn = mF.B.driving.turns(r, 1);
			timestamp = mF.B.driving.turns(r, 2);
			lat = mF.B.driving.turns(r, 3);
			long = mF.B.driving.turns(r, 4);
			dAngle = mF.B.driving.turns(r, 5);
			
			kmlGeneratePoint(fpKml, G, [int2str(indexTurn) ': ' num2str(dAngle, '%.2f')], ...
				lat, ...
				long, ...
				0, ...
				0, ...
				0, ...
				timestamp, ...
				timestamp ...
				);
		end
		kmlCloseFolder(fpKml);
		
		fprintf(fpKml, '%s', skeletonKmlFooter);
		fclose(fpKml);

%	catch err
%		disp(['Error : ' err.message]);
%	end
	end
end


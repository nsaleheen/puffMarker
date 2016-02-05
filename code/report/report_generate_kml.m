function [ output_args ] = report_generate_kml(G, indir, outdir, participant, sessions)

	for session=sessions
%		try
			disp(['Generating kml for participant ' int2str(participant) ' session ' int2str(session)]);
            if strcmp(indir, 'formattedraw') == 1
                m = load([G.DIR.DATA G.DIR.SEP indir G.DIR.SEP 'p' int2str(participant) '_s' num2str(session,'%.2d') '_frmtraw']);
                mD = m.R;
            else
                m = load([G.DIR.DATA G.DIR.SEP indir G.DIR.SEP 'p' int2str(participant) '_s' num2str(session,'%.2d') '_frmtdata']);
                mD = m.D;
            end
			
			fpKml = fopen([G.DIR.DATA G.DIR.SEP outdir G.DIR.SEP 'Participant ' int2str(participant) ' Session ' int2str(session) '.kml'], 'w');

			skeletonPath = 'functions/kml/skleton_kml.txt';
			skeletonKml = getFileContent(skeletonPath);
			skeletonKmlParts = regexp(skeletonKml,'#PUT_CONTENT_HERE#', 'split');
			skeletonKmlHeader = char(skeletonKmlParts(1));
			skeletonKmlFooter = char(skeletonKmlParts(2));

			fprintf(fpKml, '%s', skeletonKmlHeader);

			kmlCreateFolder(fpKml, ['Participant ' int2str(participant) ' Session ' int2str(session)], 1);
				kmlCreateFolder(fpKml, 'gps', 0);

				kmlGeneratePath(fpKml, G, ...
					mD.sensor{G.SENSOR.P_GPS_LATID}.sample, ...
					mD.sensor{G.SENSOR.P_GPS_LONGID}.sample, ...
					mD.sensor{G.SENSOR.P_GPS_ALTID}.sample, ...
					mD.sensor{G.SENSOR.P_GPS_SPDID}.sample, ...
					mD.sensor{G.SENSOR.P_GPS_BEAR}.sample, ...
					mD.sensor{G.SENSOR.P_GPS_ACCURACYID}.sample, ...
					mD.sensor{G.SENSOR.P_GPS_LATID}.timestamp);

				kmlCloseFolder(fpKml);

				kmlCreateFolder(fpKml, 'ema', 1);
				[rowCount, colCount] = size(mD.ema.data);
				for emaIndex=1:colCount
					try
						ema = mD.ema.data(emaIndex).question(12).response;
						[timeDiff, index] = min(abs(mD.sensor{G.SENSOR.P_GPS_LATID}.timestamp - mD.ema.data(emaIndex).question(12).timestamp));
						label = '';
						switch ema
							case 0
								%There is no ema for this.
								continue;
							case 1
								label = 'Home';
							case 2
								label = 'Work';
							case 3
								label = 'Store';
							case 4
								label = 'Restaurant';
							case 5
								label = 'Vehicle';
							case 6
								label = 'Outside';
							case 7
								label = 'Other';
						end
						kmlGeneratePoint(fpKml, G, label, ...
							mD.sensor{G.SENSOR.P_GPS_LATID}.sample(index), ...
							mD.sensor{G.SENSOR.P_GPS_LONGID}.sample(index), ...
							mD.sensor{G.SENSOR.P_GPS_ALTID}.sample(index), ...
							mD.sensor{G.SENSOR.P_GPS_SPDID}.sample(index), ...
							mD.sensor{G.SENSOR.P_GPS_ACCURACYID}.sample(index), ...
							mD.sensor{G.SENSOR.P_GPS_LATID}.timestamp(index), ...
							mD.ema.data(emaIndex).question(12).timestamp ...
							);
					catch e
					end
				end
				%m.R.ema.data(1).question(12).response
				kmlCloseFolder(fpKml);
			kmlCloseFolder(fpKml);

			fprintf(fpKml, '%s', skeletonKmlFooter);
			fclose(fpKml);
%		catch err
%			disp(['Error : ' err.message]);
%		end
	end

end


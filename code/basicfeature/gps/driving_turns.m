function turns = driving_turns(drivingSessions, lats, longs, speeds, accuracys, timestamps, maxGaitSpeed)

regressionLength = 10;
dataPointCount = numel(lats);
turns = [];
[sessionCount a] = size(drivingSessions);
for i=1:sessionCount
	try
		ttFrom = drivingSessions(i, 1);
		ttTo = drivingSessions(i, 2);
		indexes = find(timestamps>=ttFrom & timestamps<=ttTo);
		for j=regressionLength:(numel(indexes)-regressionLength)
			t = indexes(j);
			if accuracys(t) > 50
				continue;
			end
			%{
			leftTailIndex = t-1;
			while leftTailIndex>=t-60 && leftTailIndex>=regressionLength
				distance = calculateHaversineDistance(lats(t), longs(t), lats(leftTailIndex), longs(leftTailIndex));
				if distance>50
					break;
				end
				leftTailIndex = leftTailIndex - 1;
			end
			rightTailIndex = t+1;
			while rightTailIndex<=t+60 && rightTailIndex<=(dataPointCount-regressionLength)
				distance = calculateHaversineDistance(lats(t), longs(t), lats(rightTailIndex), longs(rightTailIndex));
				if distance>50
					break;
				end
				rightTailIndex = rightTailIndex + 1;
			end
			leftLatFit = polyfit(1:regressionLength, lats((leftTailIndex-regressionLength+1):leftTailIndex)', 1);
			leftLongFit = polyfit(1:regressionLength, longs((leftTailIndex-regressionLength+1):leftTailIndex)', 1);
			rightLatFit = polyfit(1:regressionLength, lats(rightTailIndex:(rightTailIndex+regressionLength-1))', 1);
			rightLongFit = polyfit(1:regressionLength, longs(rightTailIndex:(rightTailIndex+regressionLength-1))', 1);
			%}
			leftLats = [];
			leftLongs = [];
			leftTailIndex = t;
			while leftTailIndex>=t-60 && leftTailIndex>=1
				distance = calculateHaversineDistance(lats(t), longs(t), lats(leftTailIndex), longs(leftTailIndex));
				if distance<500 && accuracys(leftTailIndex)<50 && speeds(leftTailIndex)>maxGaitSpeed
					leftLats(end+1) = lats(leftTailIndex);
					leftLongs(end+1) = longs(leftTailIndex);
					if numel(leftLats)==regressionLength
						break;
					end
				end
				leftTailIndex = leftTailIndex - 1;
			end
			rightLats = [];
			rightLongs = [];
			rightTailIndex = t;
			while rightTailIndex<=t+60 && rightTailIndex<=dataPointCount
				distance = calculateHaversineDistance(lats(t), longs(t), lats(rightTailIndex), longs(rightTailIndex));
				if distance<500 && accuracys(rightTailIndex)<50 && speeds(rightTailIndex)>maxGaitSpeed
					rightLats(end+1) = lats(rightTailIndex);
					rightLongs(end+1) = longs(rightTailIndex);
					if numel(rightLats)==regressionLength
						break;
					end
				end
				rightTailIndex = rightTailIndex + 1;
			end
			if numel(leftLats) ~= regressionLength || numel(rightLats) ~= regressionLength
				continue;
			end
			leftLats = fliplr(leftLats);
			leftLongs = fliplr(leftLongs);
			leftLatFit = polyfit(1:regressionLength, leftLats, 1);
			leftLongFit = polyfit(1:regressionLength, leftLongs, 1);
			rightLatFit = polyfit(1:regressionLength, rightLats, 1);
			rightLongFit = polyfit(1:regressionLength, rightLongs, 1);

			dp1 = [polyval(leftLatFit, 1) polyval(leftLongFit, 1)];
			dp2 = [polyval(leftLatFit, regressionLength) polyval(leftLongFit, regressionLength)];
			dp3 = [polyval(rightLatFit, 1) polyval(rightLongFit, 1)];
			dp4 = [polyval(rightLatFit, regressionLength) polyval(rightLongFit, regressionLength)];

			dRotationDeg = calculateAngle(dp1, dp2, dp3, dp4);


			if abs(dRotationDeg)>45
				if numel(turns) == 0
					turns(end+1, :) = [t timestamps(t) lats(t) longs(t) dRotationDeg];
				else
					distanceFromLast = calculateHaversineDistance(turns(end, 3), turns(end, 4), lats(t), longs(t));
					if distanceFromLast>100
						turns(end+1, :) = [t timestamps(t) lats(t) longs(t) dRotationDeg];
					else
						if abs(dRotationDeg)> abs(turns(end, 5))
							turns(end, :) = [t timestamps(t) lats(t) longs(t) dRotationDeg];
						end
					end
				end
			end
		end
	catch e
		disp(['Error: ' e.message]);
	end
end

end


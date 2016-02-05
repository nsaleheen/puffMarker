function [ linearAccl, gravityCmp ] = getLinearGravity( rawData )

len = length(rawData);
gravityCmp = zeros(1, len);
gravity=rawData(1);
%alpha=0.8;
alpha=0.75;

for i=1:len
	gravity = alpha*gravity + (1-alpha)*rawData(i);
	gravityCmp(i) = gravity;
end

linearAccl = rawData-gravityCmp;

end


function [ acclMps2, linearAccl, gravityCmp ] = accl_sep_linear_gravity( rawData, bias )

len = length(rawData);
acclMps2 = zeros(1, len);
%linearAccl = zeros(1, len);
gravityCmp = zeros(1, len);
gravity=0;
alpha=0.8;

for i=1:len
	acclMps2(i)=(rawData(i)-bias)/4096*3.0*9.8/0.27;
	gravity = alpha*gravity + (1-alpha)*acclMps2(i);
	gravityCmp(i) = gravity;
end

linearAccl = acclMps2-gravityCmp;

end


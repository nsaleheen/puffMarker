function strchV = CalculateStretch(sample,timestamp,pv_sample,pv_timestamp)
valleyT=pv_timestamp(1:2:end);
peakV=pv_sample(2:2:end);
N=size(valleyT,2);

strchV = zeros(1,N-1);
for i=1:N-1
    valleyST=valleyT(i);
    valleyET=valleyT(i+1);
    maxV=peakV(i);
    minV=min(sample(find(timestamp >= valleyST & timestamp <= valleyET)));
    strchV(i) = maxV-minV;
end
end

function timestamp = correct_timestamps_basic(timestamp,freq)
sampletime=1.0/freq;
sampleLen=5;
addfreq=(1000.0*sampletime)*((sampleLen-1):-1:1);
mult=sampleLen-1:-1:1;
col=size(timestamp,2);
for r=sampleLen:sampleLen:col
    if r==sampleLen
        timestamp(r-sampleLen+1:r-1)=timestamp(r)-addfreq;
    else
        timediff=timestamp(r)-timestamp(r-sampleLen);
        if timediff>5*addfreq(sampleLen-1)
            timestamp(r-sampleLen+1:r-1)=timestamp(r)-addfreq;
        else
            timestamp(r-sampleLen+1:r-1)=timestamp(r)-(timediff/5)*mult;
        end
    end
end

function strchV = BreathStretchCalculate(ripV,ripT,peakvalley_sample,peakvalley_timestamp)

nmins = length(peakvalley_timestamp);

%peakind = 1;
strchV = [];%zeros([(nmins-1)/2,1]);
for i=1:2:nmins-2
    peak1_time = peakvalley_timestamp(i);
    peak2_time = peakvalley_timestamp(i+2);
    
    if peak1_time == -1 || peak2_time == -1 || peak2_time <  peakvalley_timestamp(i+1)  || peakvalley_timestamp(i+1) < peak1_time
        continue
    end
    maxpeak = double(peakvalley_sample(i+1));
%    minval = min(ripV(ripT >= peak1_time & ripT <= peak2_time));
    minval = min(ripV(ripT >= peak1_time & ripT <= peak2_time));
    strchV(end+1) = maxpeak-minval;
%    peakind = peakind + 1;
end
end
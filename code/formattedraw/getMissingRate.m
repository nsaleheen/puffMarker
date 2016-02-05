function m=getMissingRate(lendata,startTimestamp,endTimestamp,samplingRate)
    %missing rate is ratio between # of samples received and # of expected
    %samples
    %lendata: length of a segment
    %startTimestamp: starting timestamp of the current segment
    %endTimestamp: end timestamp of the current segment
    %samplingRate: sampling rate for current data
    if endTimestamp<startTimestamp
        m=-1;
        s=sprintf('endTimestamp is less than startTimestamp\n');
        disp(s);
        return;
    end;
    if endTimestamp<0 || startTimestamp<0
        m=-1;
        s=sprintf('negetive timestamp\n');
        disp(s);
        return;
    end;
       
    if lendata==0
        m=-1;
        s=sprintf('length of data segment is zero\n');
%        disp(s);
        return;
    end;
    
   durationInSeconds=(endTimestamp-startTimestamp)/1000;
   numberOfExpectedSamples=durationInSeconds*samplingRate;
   m=((numberOfExpectedSamples-lendata)/numberOfExpectedSamples)*100;
end
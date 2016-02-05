function outlier=detect_outlier(G,sample,timestamp,winlen)
outlier=[];
if isempty(timestamp), return;end;
startT=timestamp(1);
total=size(timestamp,2);
while startT<=timestamp(end)
    endT=startT+winlen;
    indT=find(timestamp>=startT & timestamp<=endT);
    samples=sample(indT);
    
    MED=3.32*iqr(samples);
    MAD=(median(samples)-2.9*iqr(samples))/3;
    CBD=(MED+MAD)/2;
    
    u=median(samples)+ CBD;
    l=median(samples)- CBD;
    
    ind=(find(samples>l & samples<u));
    out=ones(1,size(samples,2))*G.QUALITY.BAD;
    out(ind)=G.QUALITY.GOOD;
    outlier=[outlier out];
    if indT(end)+1>total
        break;
    end
    startT=timestamp(indT(end)+1);
end
end

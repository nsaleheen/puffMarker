function missing=calculate_missing_rip(G,P)
starttimestamp=P.sensor{1}.peakvalley_new_3.timestamp(1:2:end-2);
endtimestamp=P.sensor{1}.peakvalley_new_3.timestamp(3:2:end);
missing=zeros(1,length(starttimestamp));
freq=64/3;
for i=1:length(starttimestamp)
    stime=starttimestamp(i);
    etime=endtimestamp(i);
    [a,b]=binarysearch(P.sensor{1}.timestamp,stime,etime);
    len=b-a+1;
    missing(i)=1-len/(freq*((etime-stime)/1000));
    if missing(i)<0, missing(i)=0;
end
end

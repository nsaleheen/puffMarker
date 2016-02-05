function peakvalley=detect_peakvalley(G,sample,timestamp)

PEAKVALLEY_WINDOW=10*60*1000; % 10 minute

%This function takes in samples and timestamps and segments it into cycles
%each segment: has its samples and timestamps
%              start time = valley time, endtime = next_valley_time -1
%              peak = index of the peak in this cycle, valley is at 1
peakvalley.METADATA='VPV';
peakvalley.sample=[];
peakvalley.timestamp=[];
peakvalley.matlabtime=[];
if isempty(sample)
    return;
end
for t=timestamp(1):PEAKVALLEY_WINDOW:timestamp(end)
    selected=find(timestamp>=t & timestamp<=t+PEAKVALLEY_WINDOW);
    ripV=sample(selected);
    ripT=timestamp(selected);
    
    if size(ripV,2)==0
        continue;
    end
    rpvIndVal=RipPVDetect(ripV);
    
    %% Error Checking
    tind=find(rpvIndVal<0);
    while ~isempty(tind)
        rpvIndVal(floor(tind(1)/4)*4+1:floor(tind(1)/4)*4+4)=[];
        tind=find(rpvIndVal<0);
    end;
    if isempty(rpvIndVal)
        continue;
    end;
    %% Save Peak and Valley
    index=rpvIndVal(1:2:end);
    pvT=ripT(index);
    pvV=ripV(index);
    peakvalley.timestamp=[peakvalley.timestamp,pvT];
    peakvalley.sample=[peakvalley.sample,pvV];
    
end
ind=find(peakvalley.timestamp(2:end)-peakvalley.timestamp(1:end-1)<0);
while ~isempty(ind)
    peakvalley.sample(ind(1)-1:ind(1))=[];
    peakvalley.timestamp(ind(1)-1:ind(1))=[];
    ind=find(peakvalley.timestamp(2:end)-peakvalley.timestamp(1:end-1)<0);
end
peakvalley.matlabtime=convert_timestamp_matlabtimestamp(G,peakvalley.timestamp);
end

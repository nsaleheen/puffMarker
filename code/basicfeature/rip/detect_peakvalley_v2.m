function peakvalley=detect_peakvalley_v2(G,sample,timestamp)

peakvalley.METADATA='VP';
peakvalley.sample=[];
peakvalley.timestamp=[];
peakvalley.matlabtime=[];
%peakvalley.sequence=[]; %% indicates valley-peak-valley-peak.. by 0-1-0-1-....
if isempty(sample)
    return;
end

[valley_ind,peak_ind]=peakvalley_v2(sample,timestamp);

if isempty(valley_ind)
    return;
end

valleyPeak=[];
for i=1:length(peak_ind)
    valleyPeak=[valleyPeak valley_ind(i) peak_ind(i)];
end
if i<length(valley_ind), valleyPeak=[valleyPeak valley_ind(i+1)];
peakvalley.timestamp=timestamp(valleyPeak);
peakvalley.sample=sample(valleyPeak);
peakvalley.matlabtime=convert_timestamp_matlabtimestamp(G,peakvalley.timestamp);
%ValleyPeak_Sequence=zeros(1,length(valleyPeak));   %% zero~ valley;  one~peak
%ValleyPeak_Sequence(2:2:end)=1;
%peakvalley.sequence=ValleyPeak_Sequence;
end

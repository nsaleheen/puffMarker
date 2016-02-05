function segment = split_by_gaps(timestamp)
%% Constants
GAP.MIN_AVAILABLE_GAPS = 60*60;
GAP.MIN_SPLIT_GAP = 30; % second
GAP.NUM_SAMPLES_PER_PACKET=5;
GAP.MAX_PACKETS_PER_SEGMENT=2000;
%%
timestamp_packets = timestamp(timestamp ~= 0);
if isempty(timestamp_packets)
    sample=[];timestamp=[];segment=[];
    return;
end
spaces = diff(timestamp_packets);
gapinds = find(spaces>(GAP.MIN_SPLIT_GAP*1000));

segment = [1,0];
for gapind=gapinds
    segment(end,2) = gapind*GAP.NUM_SAMPLES_PER_PACKET;
    segment(end+1,1) = (gapind*GAP.NUM_SAMPLES_PER_PACKET+1);
end
segment(end,2) = length(timestamp);

segind = 1;
subsegments = [];
while segind <= size(segment,1)
    numsubsegments = ceil((segment(segind,2)-segment(segind,1)+1)/(GAP.NUM_SAMPLES_PER_PACKET*GAP.MAX_PACKETS_PER_SEGMENT));
	
    if numsubsegments > 1
		subsegments = [];
        for j=1:numsubsegments-1
            subsegments(end+1,1:2) = [segment(segind,1)+(j-1)*GAP.MAX_PACKETS_PER_SEGMENT*GAP.NUM_SAMPLES_PER_PACKET,segment(segind,1)+j*GAP.MAX_PACKETS_PER_SEGMENT*GAP.NUM_SAMPLES_PER_PACKET - 1];
        end
        subsegments(end+1,1:2) = [subsegments(end,2)+1,segment(segind,2)];
        segment = [segment(1:segind-1,:);subsegments;segment(segind+1:end,:)];
        segind = segind + size(subsegments,1);
    else
		segind = segind + 1;
    end
end

end

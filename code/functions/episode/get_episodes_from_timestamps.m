function [ subsetStart, subsetEnd, meanValues, startingIndexNew ] = get_episodes_from_timestamps(timestamps, startingIndex, fromTimestamp, toTimestamp , values)

    meanValues = -1;
    len = numel(timestamps);
    
    i = startingIndex;
    while i<len && timestamps(i)<fromTimestamp
        i=i+1;
    end
    subsetStart = i;
    while i<len && timestamps(i)<toTimestamp
        i=i+1;
    end
    subsetEnd = i-1;

    if subsetEnd<len && subsetStart <= subsetEnd
        meanValues = mean(values(subsetStart:subsetEnd));
    end
    
    startingIndexNew = i;

end


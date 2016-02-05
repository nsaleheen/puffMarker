function episodes=getEpisodesFromTimestamps(timestamps,durationThreshold)
episodes=[];
if isempty(timestamps)
    return;
end
goodDiffInd=find(diff(timestamps)/1000/60>durationThreshold);
if isempty(goodDiffInd)
    episodes=[timestamps(1),timestamps(end)];
else  
    for i=1:length(goodDiffInd)
        if i==1
            episodes=[episodes;[timestamps(1),timestamps(goodDiffInd(i))]];
        end
        if i==length(goodDiffInd)
            if length(goodDiffInd)~=1
                episodes=[episodes;[timestamps(goodDiffInd(i-1)+1),timestamps(goodDiffInd(i))]];
            end
            episodes=[episodes;[timestamps(goodDiffInd(i)+1),timestamps(end)]];
        end
        if i~=1 && i~=length(goodDiffInd)
            episodes=[episodes;[timestamps(goodDiffInd(i-1)+1),timestamps(goodDiffInd(i))]];
        end
    end
end

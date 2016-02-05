function goodEpisodes=getGoodEpisodes_v2(pid,sid,timestamps,durationThreshold,samplingRate)
goodEpisodes=[];
if isempty(timestamps)
    return;
end
goodDiffInd=find(diff(timestamps)/1000>durationThreshold);
if isempty(goodDiffInd)
    %check whether sufficient samples in the episode
    expectedSamples=((timestamps(end)-timestamps(1))/1000)*samplingRate;
    nSamples=length(timestamps);
    if abs(expectedSamples-nSamples)/expectedSamples>0.9     %more than 90% samples are available
        goodEpisodes=[str2num(pid(2:end)),str2num(sid(2:end)),timestamps(1),timestamps(end)];
    end
else  
    for i=1:length(goodDiffInd)
        if i==1
            expectedSamples=((timestamps(goodDiffInd(i))-timestamps(1))/1000)*samplingRate;
            ind=find(timestamps<=timestamps(goodDiffInd(i)) & timestamps>=timestamps(1));
            nSamples=length(ind);
            if abs(expectedSamples-nSamples)/expectedSamples>0.9 
                goodEpisodes=[goodEpisodes;str2num(pid(2:end)),str2num(sid(2:end)),timestamps(1),timestamps(goodDiffInd(i))];
            end
        end
        if i==length(goodDiffInd)
            if length(goodDiffInd)~=1
                expectedSamples=((timestamps(goodDiffInd(i))-timestamps(goodDiffInd(i-1)+1))/1000)*samplingRate;
                ind=find(timestamps<=timestamps(goodDiffInd(i)) & timestamps>=timestamps(goodDiffInd(i-1)+1));
                nSamples=length(ind);
                if abs(expectedSamples-nSamples)/expectedSamples>0.9
                    goodEpisodes=[goodEpisodes;str2num(pid(2:end)),str2num(sid(2:end)),timestamps(goodDiffInd(i-1)+1),timestamps(goodDiffInd(i))];
                end
            end
            expectedSamples=((timestamps(end)-timestamps(goodDiffInd(i)+1))/1000)*samplingRate;
            ind=find(timestamps<=timestamps(end) & timestamps>=timestamps(goodDiffInd(i)+1));
            nSamples=length(ind);
            if abs(expectedSamples-nSamples)/expectedSamples>0.9
                goodEpisodes=[goodEpisodes;str2num(pid(2:end)),str2num(sid(2:end)),timestamps(goodDiffInd(i)+1),timestamps(end)];
            end
        end
        if i~=1 && i~=length(goodDiffInd)
            expectedSamples=((timestamps(goodDiffInd(i))-timestamps(goodDiffInd(i-1)+1))/1000)*samplingRate;
            ind=find(timestamps<=timestamps(goodDiffInd(i)) & timestamps>=timestamps(goodDiffInd(i-1)+1));
            nSamples=length(ind);
            if abs(expectedSamples-nSamples)/expectedSamples>0.9
                goodEpisodes=[goodEpisodes;str2num(pid(2:end)),str2num(sid(2:end)),timestamps(goodDiffInd(i-1)+1),timestamps(goodDiffInd(i))];
            end
        end
    end
end

%fid1=fopen(['c:\DataProcessingFrameworkV2\data\MEMphis\report\goodEpisodes\goodEpisodes_' num2str(pid) '_' strcat('s',num2str(sid','%02d')) '.csv'],'a');
% fid1=fopen('c:\DataProcessingFrameworkV2\data\MEMphis\report\goodEpisodes\goodEpisodes.csv','a');
% line=[];
% for i=1:size(goodEpisodes,1)
%     line=[num2str(goodEpisodes(i,1)) ',' num2str(goodEpisodes(i,2),'%02d') ',' num2str(goodEpisodes(i,3)) ',' num2str(goodEpisodes(i,4))];
%     fprintf(fid1,'%s',line);
%     fprintf(fid1,'\n');
% end;
% fclose(fid1);
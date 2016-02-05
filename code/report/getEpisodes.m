function episodes=getEpisodes(pid,sid,timestamps,durationThreshold)
episodes=[];
if isempty(timestamps)
    return;
end
goodDiffInd=find(diff(timestamps)/1000/60>durationThreshold);
if isempty(goodDiffInd)
    episodes=[pid,sid,timestamps(1),timestamps(end)];
else  
    for i=1:length(goodDiffInd)
        if i==1
            episodes=[episodes;[pid, sid, timestamps(1),timestamps(goodDiffInd(i))]];
        end
        if i==length(goodDiffInd)
            if length(goodDiffInd)~=1
                episodes=[episodes;[pid, sid, timestamps(goodDiffInd(i-1)+1),timestamps(goodDiffInd(i))]];
            end
            episodes=[episodes;[pid, sid, timestamps(goodDiffInd(i)+1),timestamps(end)]];
        end
        if i~=1 && i~=length(goodDiffInd)
            episodes=[episodes;[pid, sid, timestamps(goodDiffInd(i-1)+1),timestamps(goodDiffInd(i))]];
        end
    end
end

%fid1=fopen(['c:\DataProcessingFrameworkV2\data\MEMphis\report\episodes\episodes_' num2str(pid) '_' strcat('s',num2str(sid','%02d')) '.csv'],'a');
% fid1=fopen('c:\DataProcessingFrameworkV2\data\MEMphis\report\episodes\episodes.csv','a');
% line=[];
% for i=1:size(episodes,1)
%     line=[num2str(episodes(i,1)) ',' num2str(episodes(i,2),'%02d') ',' num2str(episodes(i,3)) ',' num2str(episodes(i,4))];
%     fprintf(fid1,'%s',line);
%     fprintf(fid1,'\n');
% end;
% fclose(fid1);
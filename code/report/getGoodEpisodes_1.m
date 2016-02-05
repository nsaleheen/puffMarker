function goodEpisodes=getGoodEpisodes_1(pid,sid,timestamps,durationThreshold)
goodEpisodes=[];
if isempty(timestamps)
    return;
end
goodDiffInd=find(diff(timestamps)/1000/60>durationThreshold);
if isempty(goodDiffInd)
    goodEpisodes=[str2num(pid(2:end)),str2num(sid(2:end)),int64(timestamps(1)),int64(timestamps(end))];
else  
    for i=1:length(goodDiffInd)
        if i==1
            goodEpisodes=[goodEpisodes;str2num(pid(2:end)),str2num(sid(2:end)),int64(timestamps(1)),int64(timestamps(goodDiffInd(i)))];
        end
        if i==length(goodDiffInd)
            if length(goodDiffInd)~=1
                goodEpisodes=[goodEpisodes;str2num(pid(2:end)),str2num(sid(2:end)),int64(timestamps(goodDiffInd(i-1)+1)),int64(timestamps(goodDiffInd(i)))];
            end
            goodEpisodes=[goodEpisodes;str2num(pid(2:end)),str2num(sid(2:end)),int64(timestamps(goodDiffInd(i)+1)),int64(timestamps(end))];
        end
        if i~=1 && i~=length(goodDiffInd)
            goodEpisodes=[goodEpisodes;str2num(pid(2:end)),str2num(sid(2:end)),int64(timestamps(goodDiffInd(i-1)+1)),int64(timestamps(goodDiffInd(i)))];
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
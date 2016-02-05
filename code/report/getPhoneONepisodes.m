if isempty(phoneDiffInd)
    phoneOnEpisodes=[pid,sid,int64(D.sensor{11}.timestamp(1)),int64(D.sensor{11}.timestamp(end))];
else  
    for i=1:length(phoneDiffInd)
        if i==1
            phoneOnEpisodes=[phoneOnEpisodes;pid,sid,int64(D.sensor{11}.timestamp(10)),int64(D.sensor{11}.timestamp(phoneDiffInd(i)))];
        end
        if i==length(phoneDiffInd)
            phoneOnEpisodes=[phoneOnEpisodes;pid,sid,int64(D.sensor{11}.timestamp(phoneDiffInd(i)+1)),int64(D.sensor{11}.timestamp(end))];
        end
        if i~=1 && i~=length(phoneDiffInd)
            phoneOnEpisodes=[phoneOnEpisodes;pid,sid,int64(D.sensor{11}.timestamp(phoneDiffInd(i-1)+1)),int64(D.sensor{11}.timestamp(phoneDiffInd(i)))];
        end
    end
end

fid1=fopen(['c:\DataProcessingFrameworkV2\data\MEMphis\report\phoneONepisodes_' num2str(pid) '_' strcat('s',num2str(sid','%02d')) '.csv'],'a');
line=[];
for i=1:size(phoneOnEpisodes,1)
line=[num2str(phoneOnEpisodes(i,1)) ',' num2str(phoneOnEpisodes(i,2),'%02d') ',' num2str(phoneOnEpisodes(i,3)) ',' num2str(phoneOnEpisodes(i,4))];
fprintf(fid1,'%s',line);
fprintf(fid1,'\n');
end;
fclose(fid1);
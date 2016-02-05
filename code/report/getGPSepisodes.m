if isempty(gpsDiffInd)
    gpsOnEpisodes=[pid,sid,int64(D.sensor{14}.timestamp(1)),int64(D.sensor{14}.timestamp(end))];
else  
    for i=1:length(gpsDiffInd)
        if i==1
            gpsOnEpisodes=[gpsOnEpisodes;pid,sid,int64(D.sensor{14}.timestamp(10)),int64(D.sensor{14}.timestamp(gpsDiffInd(i)))];
        end
        if i==length(gpsDiffInd)
            gpsOnEpisodes=[gpsOnEpisodes;pid,sid,int64(D.sensor{14}.timestamp(gpsDiffInd(i)+1)),int64(D.sensor{14}.timestamp(end))];
        end
        if i~=1 && i~=length(gpsDiffInd)
            gpsOnEpisodes=[gpsOnEpisodes;pid,sid,int64(D.sensor{14}.timestamp(gpsDiffInd(i-1)+1)),int64(D.sensor{14}.timestamp(gpsDiffInd(i)))];
        end
    end
end

fid1=fopen(['c:\DataProcessingFrameworkV2\data\MEMphis\report\gpsOnEpisodes_' num2str(pid) '_' strcat('s',num2str(sid','%02d')) '.csv'],'a');
line=[];
for i=1:size(gpsOnEpisodes,1)
line=[num2str(gpsOnEpisodes(i,1)) ',' num2str(gpsOnEpisodes(i,2),'%02d') ',' num2str(gpsOnEpisodes(i,3)) ',' num2str(gpsOnEpisodes(i,4))];
fprintf(fid1,'%s',line);
fprintf(fid1,'\n');
end;
fclose(fid1);
function writeEpisodes(episodes,sensor)
fid1=fopen(['c:\DataProcessingFrameworkV2\data\MEMphis\report\goodEpisodes\episodes_' sensor '.csv'],'a');
line=[];
for i=1:size(episodes,1)
    line=[num2str(episodes(i,1)) ',' num2str(episodes(i,2),'%02d') ',' num2str(episodes(i,3)) ',' num2str(episodes(i,4))];
    fprintf(fid1,'%s',line);
    fprintf(fid1,'\n');
end;
fclose(fid1);
function saveTosTimestamps(pid,sid,timestamps)
fid=fopen('c:\dataProcessingFramework\data\nida\report\tosTimestamps.csv','a');
line='';
for i=1:length(timestamps)
    line=[pid(2:end) ',' sid(2:end) ',' num2str(timestamps(i))];
    fprintf(fid,'%s',line);
    fprintf(fid,'\n');
end
fclose(fid);
end
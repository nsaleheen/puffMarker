function tosFileTime=read_tosFileTime(G,indir,starttimestamp,endtimestamp)
tosFileTime=[];
filelist=findfiles(indir,G.FILE.TOS_NAME);
filelist=finduniquefiles(filelist); % Same file can be multiple times. Only take unique ones
noFile=size(filelist,2);
fileTime=[];
for i=1:noFile
    fileTime=[fileTime;str2num(filelist{i}(end-12:end))];
end
ind=find(fileTime>=starttimestamp & fileTime<=endtimestamp);
if length(ind)>0
    tosFileTime=fileTime(ind);
end
end
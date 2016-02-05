function temp_jhu_update_p02()
files=dir('C:\DataProcessingFramework\data\JHU\formatteddata\p02*');
for i=1:length(files)
    load(['C:\DataProcessingFramework\data\JHU\formatteddata\' files(i).name]);
    newsid=sprintf('s%02d',i)
    oldsid=D.METADATA.SID
    
    D.METADATA.SID=newsid;
    D.NAME=strrep(D.NAME,oldsid,newsid);
    newfilename=strrep(files(i).name,oldsid,newsid);
    save(['C:\DataProcessingFramework\data\JHU\formatteddata\' newfilename],'D');
    delete(['C:\DataProcessingFramework\data\JHU\formatteddata\' files(i).name]);
end
end

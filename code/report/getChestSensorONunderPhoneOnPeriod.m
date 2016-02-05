function [chestOnEpisodes]=getChestSensorONunderPhoneOnPeriod(pid,sid,R)
participant=str2num(pid(2:end));day=str2num(sid(2:end));
chestOnEpisodes=[];
if length(R.sensor{1}.timestamp)==0
    return;
end
phoneEpisodes=load('c:\dataProcessingFrameworkV2\data\memphis\report\goodEpisodes\episodes_phoneFromActivePeriod.csv');
ind=find(phoneEpisodes(:,1)==participant);
phoneEpisodesOfTheSubject=phoneEpisodes(ind,:);
chestTimestamps=[];
for i=1:size(phoneEpisodesOfTheSubject,1)
    ind2=find(R.sensor{1}.timestamp>=phoneEpisodesOfTheSubject(i,3) & R.sensor{1}.timestamp<=phoneEpisodesOfTheSubject(i,4));
    chestTimestamps=[chestTimestamps R.sensor{1}.timestamp(ind2)];
end
chestOnEpisodes=getEpisodes(participant,day,chestTimestamps,10);
end
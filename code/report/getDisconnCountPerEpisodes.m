function [disconnCount duration]=getDisconnCountPerEpisodes(pid,sid)
load(['E:\dataProcessingFramework\data\memphis\formattedraw\' pid '_' sid '_frmtraw.mat']);
n=length(R.METADATA.tosFileTime);
participant=str2num(pid(2:end));
day=str2num(sid(2:end));
% wearingTimes=load('c:\dataProcessingFramework\data\nida\report\goodEpisodes\episodes_wearing.csv');

disconnCount=0;
duration=0;

ind=find(wearingTimes(:,1)==participant & wearingTimes(:,2)==day);
wearingOnThatDay=wearingTimes(ind,:); 
[r c]=size(wearingOnThatDay);

for i=1:r
    
end
end
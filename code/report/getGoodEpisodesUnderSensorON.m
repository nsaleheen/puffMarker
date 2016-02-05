function goodEpisodes=getGoodEpisodesUnderSensorON(pid,sid,timestamps,chestONepisodes,durationThreshold)
goodEpisodes=[];
if isempty(timestamps)
    return;
end
timestampsUnderChestON=[];
ind=find(chestONepisodes(:,1)==pid);
chestONofTheParticipant=chestONepisodes(ind,:);
for i=1:size(chestONofTheParticipant,1)
    ind2=find(timestamps>=chestONofTheParticipant(i,3) & timestamps<=chestONofTheParticipant(i,4));
    timestampsUnderChestON=[timestampsUnderChestON timestamps(ind2)];
end
goodEpisodes=getEpisodes(pid,sid,timestampsUnderChestON,durationThreshold);
end

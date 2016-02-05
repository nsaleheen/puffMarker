function episodes=getGoodEpisodesUnderActivePeriod(pid,sid,timestamps,activeSensorONepisodes,durationThreshold)
episodes=[];
if length(timestamps)==0
    return;
end
participant=str2num(pid(2:end));day=str2num(sid(2:end));
ind=find(activeSensorONepisodes(:,1)==participant);
sensorONepisodesOfTheParticipant=activeSensorONepisodes(ind,:);
timestamps_active=[];
for i=1:size(sensorONepisodesOfTheParticipant,1)
    ind2=find(timestamps>=sensorONepisodesOfTheParticipant(i,3) & timestamps<=sensorONepisodesOfTheParticipant(i,4));
    timestamps_active=[timestamps_active timestamps(ind2)];
end
episodes=getEpisodes(participant,day,timestamps_active,durationThreshold);
end
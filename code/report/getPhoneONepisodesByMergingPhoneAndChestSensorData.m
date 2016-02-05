function [phoneONepisodes]=getPhoneONepisodesByMergingPhoneAndChestSensorData(pid,sid,R,activePeriodEpisodes)
    phoneONepisodes=[];   
    allTimestamps=[];
    phoneData=[];
    participant=str2num(pid(2:end));day=str2num(sid(2:end));
    ind=find(activePeriodEpisodes(:,1)==participant);% & activePeriodEpisodes(:,2)==day);
    activePeriodOfTheDay=activePeriodEpisodes(ind,:);
    
    chestData=R.sensor{1}.timestamp;
    if isfield(R.sensor{11},'timestamp')
        [r c]=size(R.sensor{11}.timestamp);
        if r>1 && c==1
            phoneData=R.sensor{11}.timestamp';
        else
            phoneData=R.sensor{11}.timestamp;
        end
        allTimestamps=[chestData phoneData];
    else
        allTimestamps=chestData;
    end
    allTimestamps=unique(allTimestamps);
    allTimestamps=sort(allTimestamps);
    [r c]=size(activePeriodOfTheDay);
    if r<1
        return;
    end
    activeTimestamps=[];
    for i=1:r
        ind2=find(allTimestamps>=activePeriodOfTheDay(i,3) & allTimestamps<=activePeriodOfTheDay(i,4));
        activeTimestamps=[activeTimestamps allTimestamps(ind2)];
    end
    
    phoneONepisodes=getGoodEpisodes(pid,sid,activeTimestamps,10);  %each wearing epsidoes are assumed to be apart by 10 minutes
end

function [wearingEpisodes]=getWearingByMergingGoodEpisodes(pid,sid,D)
    ecgGoodEpisodes=load('c:\dataProcessingFrameworkV2\data\memphis\report\goodEpisodes\episodes_ecg.csv');
    ripGoodEpisodes=load('c:\dataProcessingFrameworkV2\data\memphis\report\goodEpisodes\episodes_rip.csv');
    ripInd=find(ripGoodEpisodes(:,1)==str2num(pid(2:end)) & ripGoodEpisodes(:,2)==str2num(sid(2:end)));
    ecgInd=find(ecgGoodEpisodes(:,1)==str2num(pid(2:end)) & ecgGoodEpisodes(:,2)==str2num(sid(2:end)));
    wearingEpisodes=[];    
    allTimestamps=[];
    for i=1:length(ripInd)
        indrT=find(D.sensor{1}.timestamp>=ripGoodEpisodes(ripInd(i),3) & D.sensor{1}.timestamp<=ripGoodEpisodes(ripInd(i),4));
        allTimestamps=[allTimestamps D.sensor{1}.timestamp(indrT)];
    end
    for i=1:length(ecgInd)
        indeT=find(D.sensor{2}.timestamp>=ecgGoodEpisodes(ecgInd(i),3) & D.sensor{2}.timestamp<=ecgGoodEpisodes(ecgInd(i),4));
        allTimestamps=[allTimestamps D.sensor{2}.timestamp(indeT)];
    end
    allTimestamps=unique(allTimestamps);
    allTimestamps=sort(allTimestamps);
    wearingEpisodes=getGoodEpisodes(pid,sid,allTimestamps,10);  %each wearing epsidoes are assumed to be apart by 10 minutes
end

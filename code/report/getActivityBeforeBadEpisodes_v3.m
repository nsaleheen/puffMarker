function [nonContiguousActivityRip contiguousActivityRip nonContiguousActivityEcg contiguousActivityEcg]=getActivityBeforeBadEpisodes_v3(pid,sid)
    participant=str2num(pid(2:end));
    day=str2num(sid(2:end));
    load(['c:\dataProcessingFrameworkV2\data\memphis\feature\chest_accelerometer_feature\field_' strcat('p',num2str(participant,'%02d')) '_' strcat('s',num2str(day,'%02d')) '_act10_feature.mat']);
    featMag=-1*ones(length(F.window),1);
    featTime=-1*ones(length(F.window),1);
    nonContiguousActivityEcg.duration=[];
    nonContiguousActivityEcg.timestamp=[];
    contiguousActivityEcg.duration=[];
    contiguousActivityEcg.timestamp=[];
%     badEpisodeDurationEcg.duration=[];
%     badEpisodeDurationEcg.timestamp=[];
    
    nonContiguousActivityRip.duration=[];
    nonContiguousActivityRip.timestamp=[];
    contiguousActivityRip.duration=[];
    contiguousActivityRip.timestamp=[];
    
    
    activityBeforeBadEpisode_ecg=-1*ones(1,length(F.window));    %how many times there is an activity before the episode is going bad
    activityBeforeBadEpisode_rip=-1*ones(1,length(F.window));

    for i=1:length(F.window)
        featTime(i)=F.window(i).starttimestamp;
    end

    for i=1:length(F.window)
        if isfield(F.window(i).feature{4},'value') && F.window(i).feature{4}.value{30}>=0.21384
%             featMag(i)=F.window(i).feature{4}.value{30};
            featMag(i)=1;            
        else
            featMag(i)=0;
        end
    end;

%     wearabilityEcg=-1*ones(length(F.window),1);
    ecg_episodes=load('c:\dataProcessingFrameworkV2\data\memphis\report\goodEpisodes\episodes_ecg.csv');
    wearingTimes=load('c:\dataProcessingFrameworkV2\data\memphis\report\goodEpisodes\episodes_wearing.csv');

    wearing=find(wearingTimes(:,1)== participant & wearingTimes(:,2)==day);
%     for i=1:length(wearing)
%         ind=find(featTime>=wearingTimes(wearing(i),3) & featTime<=wearingTimes(wearing(i),4));
%         wearabilityEcg(ind)=0;
%     end
    
    ind2=find(ecg_episodes(:,1)==participant & ecg_episodes(:,2)==day);
    for i=1:length(ind2)
        ind3=find(featTime>=ecg_episodes(ind2(i),3) & featTime<=ecg_episodes(ind2(i),4));
        if length(ind3)==0
            continue;
        end
%         wearabilityEcg(ind3)=1;
        nonContiguousActivityEcg.duration=[nonContiguousActivityEcg.duration sum(featMag(ind3))*10];  %each window is 10 seconds.
        nonContiguousActivityEcg.timestamp=[nonContiguousActivityEcg.timestamp featTime(ind3(end))+10000];  %activity up to end time
        
        count=0;
        if featMag(ind3(end))==1   %the immediate before the bad episode has the activity
            count=1;               %how many contiguous window has activity
            for j=length(ind3)-1:-1:1
                if featMag(ind3(j))~=1
                    break;
                end
                count=count+1;
            end
        end
        contiguousActivityEcg.duration=[contiguousActivityEcg.duration count*10];
        contiguousActivityEcg.timestamp=[contiguousActivityEcg.timestamp featTime(ind3(end))+10000];
    end
    %bad episode duration  %%we probably need wearing time to calculate all
    %the bad episode duration, specially at bad duration episode at the end
%      if length(ind2)>1
%             for g=1:length(ind2)-1
%                 timeDiff=(ecg_episodes(ind2(g+1),3)- ecg_episodes(ind2(g),4))/1000;  %time is in seconds
%                 badEpisodeDurationEcg.duration=[badEpisodeDurationEcg.duration timeDiff];
%                 badEpisodeDurationEcg.timestamp=[badEpisodeDurationEcg.timestamp ecg_episodes(ind2(g),4)];
%             end
%      end
%      badEpisodeDuration.sensor(2).duration=[badEpisodeDuration.sensor(2).duration timeDiff];

%     ecgInd=find(wearabilityEcg~=-1);
%     dataEcg=[featMag(notOne2) wearabilityEcg(notOne2)];

%     wearabilityRip=-1*ones(length(F.window),1);
    rip_episodes=load('c:\dataProcessingFrameworkV2\data\memphis\report\goodEpisodes\episodes_rip.csv');
    ind4=find(rip_episodes(:,1)==participant & rip_episodes(:,2)==day);
%     for i=1:length(wearing)
%         ind=find(featTime>=wearingTimes(wearing(i),3) & featTime<=wearingTimes(wearing(i),4));
%         wearabilityRip(ind)=0;
%     end
    for i=1:length(ind4)
        ind3=find(featTime>=rip_episodes(ind4(i),3) & featTime<=rip_episodes(ind4(i),4));
        if length(ind3)==0
            continue;
        end
        nonContiguousActivityRip.duration=[nonContiguousActivityRip.duration sum(featMag(ind3))*10];  %each window is 10 seconds.
        nonContiguousActivityRip.timestamp=[nonContiguousActivityRip.timestamp featTime(ind3(end))+10000];  %activity up to end time
        
        count=0;
        if featMag(ind3(end))==1   %the immediate before the bad episode has the activity
            count=1;               %how many contiguous window has activity
            for j=length(ind3)-1:-1:1
                if featMag(ind3(j))~=1
                    break;
                end
                count=count+1;
            end
        end
        contiguousActivityRip.duration=[contiguousActivityRip.duration count*10];
        contiguousActivityRip.timestamp=[contiguousActivityRip.timestamp featTime(ind3(end))+10000];
    end
    
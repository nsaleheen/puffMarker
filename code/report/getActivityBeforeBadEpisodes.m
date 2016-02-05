function [activityBeforeBadEpisode_rip activityBeforeBadEpisode_ecg]=getActivityBeforeBadEpisodes(pid,sid)
    participant=str2num(pid(2:end));
    day=str2num(sid(2:end));
    load(['c:\dataProcessingFrameworkV2\data\memphis\feature\chest_accelerometer_feature\field_' strcat('p',num2str(participant,'%02d')) '_' strcat('s',num2str(day,'%02d')) '_act10_feature.mat']);
    featMag=-1*ones(length(F.window),1);
    featTime=-1*ones(length(F.window),1);
    
    activityBeforeBadEpisode_ecg=-1*ones(1,length(F.window));    %how many times there is an activity before the episode is going bad
    activityBeforeBadEpisode_rip=-1*ones(1,length(F.window));
    
    nWindow=3;   %one minute = 6 windows

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
%     wearingTimes=load('c:\dataProcessingFrameworkV2\data\memphis\report\goodEpisodes\episodes_wearing.csv');

%     wearing=find(wearingTimes(:,1)== participant & wearingTimes(:,2)==day);
%     for i=1:length(wearing)
%         ind=find(featTime>=wearingTimes(wearing(i),3) & featTime<=wearingTimes(wearing(i),4));
%         wearabilityEcg(ind)=0;
%     end
    ind2=find(ecg_episodes(:,1)==participant & ecg_episodes(:,2)==day);
    for i=1:length(ind2)
        ind3=find(featTime>=ecg_episodes(ind2(i),3) & featTime<=ecg_episodes(ind2(i),4));
%         wearabilityEcg(ind3)=1;
        if length(ind3)>=nWindow    %one minute majority, 1 minute = 6 window of 10 secs
            [val vote]=majority(featMag(ind3(end)-nWindow:ind3(end)));
             activityBeforeBadEpisode_ecg(ind3(end)-nWindow:ind3(end))=val;
        end
    end

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
%         wearabilityRip(ind3)=1;
        if length(ind3)>=nWindow    %one minute majority, 1 minute = 6 window of 10 secs
            [val vote]=majority(featMag(ind3(end)-nWindow:ind3(end)));
             activityBeforeBadEpisode_rip(ind3(end)-nWindow:ind3(end))=val;
        end
    end
    
%     ripInd=find(wearabilityRip~=-1);
%     CombineFeatValEcg=[CombineFeatValEcg;featMag(ecgInd)];
%     CombineFeatValRip=[CombineFeatValRip;featMag(ripInd)];
%     CombineFeatTimeEcg=[CombineFeatTimeEcg;featTime(ecgInd)];
%     CombineFeatTimeRip=[CombineFeatTimeRip;featTime(ripInd)];
%     CombineWearabilityEcg=[CombineWearabilityEcg;wearabilityEcg(ecgInd)];
%     CombineWearabilityRip=[CombineWearabilityRip;wearabilityEcg(ripInd)];
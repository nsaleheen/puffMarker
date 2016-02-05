function [nonContiguousActivityRip contiguousActivityRip badEpisodeDurationRip nonContiguousActivityEcg contiguousActivityEcg badEpisodeDurationEcg]=getActivityBeforeBadEpisodes_v2(pid,sid)
    participant=str2num(pid(2:end));
    day=str2num(sid(2:end));
    load(['c:\dataProcessingFrameworkV2\data\memphis\feature\chest_accelerometer_feature\field_' strcat('p',num2str(participant,'%02d')) '_' strcat('s',num2str(day,'%02d')) '_act10_feature.mat']);
    featMag=-1*ones(length(F.window),1);
    featTime=-1*ones(length(F.window),1);
    nonContiguousActivityEcg.duration=[];
    nonContiguousActivityEcg.timestamp=[];
    contiguousActivityEcg.duration=[];
    contiguousActivityEcg.timestamp=[];
    badEpisodeDurationEcg.duration=[];
    badEpisodeDurationEcg.timestamp=[];
    badEpisodeDurationRip.duration=[];
    badEpisodeDurationRip.timestamp=[];
    
    nonContiguousActivityRip.duration=[];
    nonContiguousActivityRip.timestamp=[];
    contiguousActivityRip.duration=[];
    contiguousActivityRip.timestamp=[];
    
    
    activityBeforeBadEpisode_ecg=-1*ones(1,length(F.window));    %how many times there is an activity before the episode is going bad
    activityBeforeBadEpisode_rip=-1*ones(1,length(F.window));
    
%     nWindow=3;   %one minute = 6 windows

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

    ind2=find(ecg_episodes(:,1)==participant & ecg_episodes(:,2)==day);
    if length(ind2)>0
    for i=1:length(ind2)
        duration=0;
        ind3=find(featTime>=ecg_episodes(ind2(i),3) & featTime<=ecg_episodes(ind2(i),4));
        if length(ind3)==0
            duration=-1;
        else
            duration=sum(featMag(ind3))*10;
        end
%         wearabilityEcg(ind3)=1;
        nonContiguousActivityEcg.duration=[nonContiguousActivityEcg.duration duration];  %each window is 10 seconds.
        nonContiguousActivityEcg.timestamp=[nonContiguousActivityEcg.timestamp ecg_episodes(ind2(i),4)];  %activity up to end time
        
        count=0;   
        if length(ind3)>0
            if featMag(ind3(end))==1   %the immediate before the bad episode has the activity
                count=1;                                 %how many contiguous window has activity
                for j=length(ind3)-1:-1:1
                    if featMag(ind3(j))~=1
                        break;
                    end
                    count=count+1;
                end
            end
        end
        contiguousActivityEcg.duration=[contiguousActivityEcg.duration count*10];
        contiguousActivityEcg.timestamp=[contiguousActivityEcg.timestamp ecg_episodes(ind2(i),4)];
    end
    %bad episode duration  %%we probably need wearing time to calculate all
    %the bad episode duration, specially at bad duration episode at the end
     if length(ind2)>1
        for g=1:length(ind2)-1
            timeDiff=(ecg_episodes(ind2(g+1),3)- ecg_episodes(ind2(g),4))/1000;  %time is in seconds
            badEpisodeDurationEcg.duration=[badEpisodeDurationEcg.duration timeDiff];
            badEpisodeDurationEcg.timestamp=[badEpisodeDurationEcg.timestamp ecg_episodes(ind2(g),4)];
        end
     end
     for i=1:length(wearing)
        indd=find(ecg_episodes(ind2(end),3)>=wearingTimes(wearing(i),3)-30000 & ecg_episodes(ind2(end),4)<=wearingTimes(wearing(i),4)+30000);
        if length(indd)>0
            timediff=(wearingTimes(wearing(i),4)-ecg_episodes(ind2(end),4))/1000;
            if timediff<0
                timediff=0;
            end
           badEpisodeDurationEcg.duration=[badEpisodeDurationEcg.duration timediff];
           badEpisodeDurationEcg.timestamp=[badEpisodeDurationEcg.timestamp ecg_episodes(ind2(end),4)]; 
        end
    end
    end
    rip_episodes=load('c:\dataProcessingFrameworkV2\data\memphis\report\goodEpisodes\episodes_rip.csv');
    ind4=find(rip_episodes(:,1)==participant & rip_episodes(:,2)==day);
    
    if length(ind4)>0
    for i=1:length(ind4)
        ind3=find(featTime>=rip_episodes(ind4(i),3) & featTime<=rip_episodes(ind4(i),4));
        duration=0;
        if length(ind3)==0
            duration=-1;
        else
            duration=sum(featMag(ind3))*10;  %each window is 10 seconds.
        end
        nonContiguousActivityRip.duration=[nonContiguousActivityRip.duration duration];  
        nonContiguousActivityRip.timestamp=[nonContiguousActivityRip.timestamp rip_episodes(ind4(i),4)];  
        
        count=0;
        if length(ind3)>0
            if featMag(ind3(end))==1   %the immediate before the bad episode has the activity
                count=1;               %how many contiguous window has activity
                for j=length(ind3)-1:-1:1
                    if featMag(ind3(j))~=1
                        break;
                    end
                    count=count+1;
                end
            end
        end
        contiguousActivityRip.duration=[contiguousActivityRip.duration count*10];
        contiguousActivityRip.timestamp=[contiguousActivityRip.timestamp rip_episodes(ind4(i),4)];
    end
    
    %bad episode duration  %%we probably need wearing time to calculate all
    %the bad episode duration, specially at bad duration episode at the end
     if length(ind4)>1
        for g=1:length(ind4)-1
            timeDiff=(rip_episodes(ind4(g+1),3)- rip_episodes(ind4(g),4))/1000;  %time is in seconds
            badEpisodeDurationRip.duration=[badEpisodeDurationRip.duration timeDiff];
            badEpisodeDurationRip.timestamp=[badEpisodeDurationRip.timestamp rip_episodes(ind4(g),4)];
        end
     end
     for i=1:length(wearing)
        indd=find(rip_episodes(ind4(end),3)>=wearingTimes(wearing(i),3)-30000 & rip_episodes(ind4(end),4)<=wearingTimes(wearing(i),4)+30000);
        if length(indd)>0
            timediff=(wearingTimes(wearing(i),4)-rip_episodes(ind4(end),4))/1000;
            if timediff<0
                timediff=0;
            end
           badEpisodeDurationRip.duration=[badEpisodeDurationRip.duration timediff];
           badEpisodeDurationRip.timestamp=[badEpisodeDurationRip.timestamp rip_episodes(ind4(end),4)]; 
        end
     end
    end
     
end
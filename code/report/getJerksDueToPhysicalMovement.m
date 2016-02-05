function [jerks_rip jerks_ecg]=getJerksDueToPhysicalMovement(pid,sid)
    jerks_rip=[]; jerks_ecg=[];
    participant=str2num(pid(2:end));day=str2num(sid(2:end));
    %load bad episodes and find bad episodes of the day
    badEpisodesEcg=load('c:\dataProcessingFrameworkV2\data\memphis\report\goodEpisodes\intermittentBadEpisodes_ecg.csv');
    badEpisodesRip=load('c:\dataProcessingFrameworkV2\data\memphis\report\goodEpisodes\intermittentBadEpisodes_rip.csv');
    
    ind1=find(badEpisodesEcg(:,1)==participant & badEpisodesEcg(:,2)==day);
    badEcgEpisodeOfTheDay=badEpisodesEcg(ind1,:);
    
    ind2=find(badEpisodesRip(:,1)==participant & badEpisodesRip(:,2)==day);
    badRipEpisodeOfTheDay=badEpisodesRip(ind2,:);
        
    %find activity of the day
    activityEpisodes=load('c:\dataProcessingFrameworkV2\data\memphis\report\activityEpisodes\activityEpisodes_matrix.csv');
    ind=find(activityEpisodes(:,1)==participant & activityEpisodes(:,2)==day & activityEpisodes(:,5)==1);
    activityOfTheDay=activityEpisodes(ind,:);
    
    [r c]=size(activityOfTheDay);
    for i=1:r
        startTime=activityOfTheDay(i,3);
        endTime=activityOfTheDay(i,4);
        
        badInd=find(badRipEpisodeOfTheDay(:,3)>=startTime & badRipEpisodeOfTheDay(:,3)<=endTime);  %what are the bad episodes starts within this time band
        if length(badInd)>=1
            startDiff=(badRipEpisodeOfTheDay(badInd(1),3)-startTime)/1000;
            endDiff=abs(badRipEpisodeOfTheDay(badInd(end),4)-endTime)/1000;
            cumulativeBadDurationRip=0;
            for d=1:length(badInd)
                cumulativeBadDurationRip=cumulativeBadDurationRip+(badRipEpisodeOfTheDay(badInd(d),4)-badRipEpisodeOfTheDay(badInd(d),3))/1000;
            end
            activityDuration=(endTime-startTime)/1000;
            durationDiff=abs(cumulativeBadDurationRip-activityDuration);
            if startDiff<=10 && endDiff<=10 && durationDiff<=20
                jerks_rip=[jerks_rip;participant day badRipEpisodeOfTheDay(badInd(1),3) cumulativeBadDurationRip];    %duration of jerks is now the cumulative duration of bad episodes
            end
        end
        
        badInd2=find(badEcgEpisodeOfTheDay(:,3)>=startTime & badEcgEpisodeOfTheDay(:,3)<=endTime);  %what are the bad episodes starts within this time band
        if length(badInd2)>=1
            startDiff=(badEcgEpisodeOfTheDay(badInd2(1),3)-startTime)/1000;
            endDiff=abs(badEcgEpisodeOfTheDay(badInd2(end),4)-endTime)/1000;
            cumulativeBadDurationEcg=0;
            for d=1:length(badInd2)
                cumulativeBadDurationEcg=cumulativeBadDurationEcg+(badEcgEpisodeOfTheDay(badInd2(d),4)-badEcgEpisodeOfTheDay(badInd2(d),3))/1000;
            end
            activityDuration=(endTime-startTime)/1000;
            durationDiff=abs(cumulativeBadDurationEcg-activityDuration);
            if startDiff<=10 && endDiff<=10 && durationDiff<=20
                jerks_ecg=[jerks_ecg;participant day badEcgEpisodeOfTheDay(badInd2(1),3) cumulativeBadDurationEcg];
            end
        end
    end
    
    %if bad episode is large, we should check whether the episodes of
    %activity are responsible for this or not
    [r1 c1]=size(badRipEpisodeOfTheDay);
    for i=1:r1
        startTime=badRipEpisodeOfTheDay(i,3)-10*1000;
        endTime=badRipEpisodeOfTheDay(i,4);
        actInd=find(activityOfTheDay(:,3)>=startTime & activityOfTheDay(:,4)<=endTime);
        cumulativeActivity=0;
        if length(actInd)>1
            for m=1:length(actInd)
                cumulativeActivity=cumulativeActivity+(activityOfTheDay(actInd(m),4)-activityOfTheDay(actInd(m),3))/1000;
            end
            badRipDuration=(badRipEpisodeOfTheDay(i,4)-badRipEpisodeOfTheDay(i,3))/1000;
            durationDiff=abs(cumulativeActivity-badRipDuration);
            if durationDiff<=20
                jerks_rip=[jerks_rip;participant day badRipEpisodeOfTheDay(i,3) badRipDuration];
            end
        end
    end
    [r2 c2]=size(badEcgEpisodeOfTheDay);
    for i=1:r2
        startTime=badEcgEpisodeOfTheDay(i,3)-10*1000;
        endTime=badEcgEpisodeOfTheDay(i,4);
        actInd=find(activityOfTheDay(:,3)>=startTime & activityOfTheDay(:,4)<=endTime);
        cumulativeActivity=0;
        if length(actInd)>1
            for m=1:length(actInd)
                cumulativeActivity=cumulativeActivity+(activityOfTheDay(actInd(m),4)-activityOfTheDay(actInd(m),3))/1000;
            end
            badEcgDuration=(badEcgEpisodeOfTheDay(i,4)-badEcgEpisodeOfTheDay(i,3))/1000;
            durationDiff=abs(cumulativeActivity-badEcgDuration);
            if durationDiff<=20
                jerks_ecg=[jerks_ecg;participant day badEcgEpisodeOfTheDay(i,3) badEcgDuration];
            end
        end
    end
    %compute duration of the bad rip due to jerks
%     [r c]=size(badRipEpisodeOfTheDay);
%     for i=1:r
%         startTime=badRipEpisodeOfTheDay(i,3)-10*1000;
%         endTime=badRipEpisodeOfTheDay(i,4);
%         actInd=find(activityOfTheDay(:,3)>=startTime & activityOfTheDay(:,4)<=endTime);
%         if length(actInd)==1  %it means
%             startDiff=abs(activityOfTheDay(actInd(1),3)-badRipEpisodeOfTheDay(i,3))/1000;
%             endDiff=abs(activityOfTheDay(actInd(1),4)-badRipEpisodeOfTheDay(i,4))/1000;
%             if startDiff<=10 && endDiff<=10
%                 jerks_rip=[jerks_rip;participant day badRipEpisodeOfTheDay(i,3) (badRipEpisodeOfTheDay(i,4)-badRipEpisodeOfTheDay(i,3))/1000]; %duration in seconds with timestamps.
%             end
%         end 
%     end
%     
%     %compute duration of the bad rip due to jerks
%     [r1 c1]=size(badEcgEpisodeOfTheDay);
%     for i=1:r1
%         startTime=badEcgEpisodeOfTheDay(i,3)-10*1000;
%         endTime=badEcgEpisodeOfTheDay(i,4);
%         actInd=find(activityOfTheDay(:,3)>=startTime & activityOfTheDay(:,4)<=endTime);
%         if length(actInd)==1  %it means
%             startDiff=abs(activityOfTheDay(actInd(1),3)-badEcgEpisodeOfTheDay(i,3))/1000;
%             endDiff=abs(activityOfTheDay(actInd(1),4)-badEcgEpisodeOfTheDay(i,4))/1000;
%             if startDiff<=10 && endDiff<=10
%                 jerks_ecg=[jerks_ecg;participant day badEcgEpisodeOfTheDay(i,3) (badEcgEpisodeOfTheDay(i,4)-badEcgEpisodeOfTheDay(i,3))/1000]; %duration in seconds with timestamps.
%             end
%         end 
%     end
    
end
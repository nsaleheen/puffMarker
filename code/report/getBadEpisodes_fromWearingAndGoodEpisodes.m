function [badEpisodesRip badEpisodesEcg]=getBadEpisodes_fromWearingAndGoodEpisodes()
    ecg_episodes=load('c:\dataProcessingFrameworkV2\data\memphis\report\goodEpisodes\episodes_ecg_all_small.csv');
    rip_episodes=load('c:\dataProcessingFrameworkV2\data\memphis\report\goodEpisodes\episodes_rip_all_small.csv');
    wearingTimes=load('c:\dataProcessingFrameworkV2\data\memphis\report\goodEpisodes\episodes_wearing_all.csv');
    
    [r c]=size(wearingTimes);
    badEpisodesRip=[];
    badEpisodesEcg=[];
    
    for i=1:r
        i
        participant=wearingTimes(i,1);
        day=wearingTimes(i,2);
        % find good episodes under this wearingTimes 
        ind=find(ecg_episodes(:,1)==participant & ecg_episodes(:,2)==day);
        goodEpisodesOnThatDay=ecg_episodes(ind,:);
        startTime=wearingTimes(i,3)-30*1000;
        endTime=wearingTimes(i,4)+30*1000;
        ind2=find(goodEpisodesOnThatDay(:,3)>=startTime & goodEpisodesOnThatDay(:,4)<=endTime);
        if length(ind2)<=1
            continue;
        end
%         if length(ind2)==0
%             if (wearingTimes(i,4)-wearingTimes(i,3))/1000>=1
%                 badEpisodesEcg=[badEpisodesEcg;participant day wearingTimes(i,3) wearingTimes(i,4)];
%             end
%             continue;
%         end
%         startDiff=(goodEpisodesOnThatDay(ind2(1),3)-wearingTimes(i,3))/1000;
%         endDiff=(wearingTimes(i,4)-goodEpisodesOnThatDay(ind2(end),4))/1000;
%         if length(ind2)==1
%             if startDiff>=1  %difference at least 1 seconds
%                 badEpisodesEcg=[badEpisodesEcg;participant day wearingTimes(i,3) goodEpisodesOnThatDay(ind2(1),3)];
%             end
%             if endDiff>=1  %difference at least 1 seconds
%                 badEpisodesEcg=[badEpisodesEcg;participant day goodEpisodesOnThatDay(ind2(1),4) wearingTimes(i,4)];
%             end
%             continue;
%         end
        %otherwise save all the end and start of the good episodes as the
        %start and end of the bad episodes
%          if startDiff>=1  %difference at least 1 seconds
%             badEpisodesEcg=[badEpisodesEcg;participant day wearingTimes(i,3) goodEpisodesOnThatDay(ind2(1),3)];
%          end
        for m=1:length(ind2)-1
            badEpisodesEcg=[badEpisodesEcg;participant day goodEpisodesOnThatDay(ind2(m),4) goodEpisodesOnThatDay(ind2(m+1),3)];
        end
%         if endDiff>=1  %difference at least 1 seconds
%             badEpisodesEcg=[badEpisodesEcg;participant day goodEpisodesOnThatDay(ind2(end),4) wearingTimes(i,4)];
%         end
    end
    
    for i=1:r
        participant=wearingTimes(i,1);
        day=wearingTimes(i,2);
        % find good episodes under this wearingTimes 
        ind=find(rip_episodes(:,1)==participant & rip_episodes(:,2)==day);
        goodEpisodesOnThatDay=rip_episodes(ind,:);
        startTime=wearingTimes(i,3)-30*1000;
        endTime=wearingTimes(i,4)+30*1000;
        ind2=find(goodEpisodesOnThatDay(:,3)>=startTime & goodEpisodesOnThatDay(:,4)<=endTime);
        if length(ind2)<=1
            continue;
        end
%         if length(ind2)==0
%             if (wearingTimes(i,4)-wearingTimes(i,3))/1000>=1
%                 badEpisodesRip=[badEpisodesRip;participant day wearingTimes(i,3) wearingTimes(i,4)];
%             end
%             continue;
%         end
%         startDiff=(goodEpisodesOnThatDay(ind2(1),3)-wearingTimes(i,3))/1000;
%         endDiff=(wearingTimes(i,4)-goodEpisodesOnThatDay(ind2(end),4))/1000;
%         if length(ind2)==1
%             if startDiff>1
%                 badEpisodesRip=[badEpisodesRip;participant day wearingTimes(i,3) goodEpisodesOnThatDay(ind2(1),3)];
%             end
%             if endDiff>1
%                 badEpisodesRip=[badEpisodesRip;participant day goodEpisodesOnThatDay(ind2(1),4) wearingTimes(i,4)];
%             end
%             continue;
%         end
        %otherwise save all the end and start of the good episodes as the
        %start and end of the bad episodes
%         if startDiff>=1  %difference at least 1 seconds
%             badEpisodesRip=[badEpisodesRip;participant day wearingTimes(i,3) goodEpisodesOnThatDay(ind2(1),3)];
%         end
        for m=1:length(ind2)-1
            badEpisodesRip=[badEpisodesRip;participant day goodEpisodesOnThatDay(ind2(m),4) goodEpisodesOnThatDay(ind2(m+1),3)];
        end
%         if endDiff>=1  %difference at least 1 seconds
%             badEpisodesRip=[badEpisodesRip;participant day goodEpisodesOnThatDay(ind2(end),4) wearingTimes(i,4)];
%         end
    end
    
    %write all bad episodes
    fid1=fopen('c:\dataProcessingFrameworkV2\data\memphis\report\goodEpisodes\intermittentBadEpisodes_ecg.csv','a');
    [n1 n2]=size(badEpisodesEcg);
    for p=1:n1
        line=[num2str(badEpisodesEcg(p,1)) ',' num2str(badEpisodesEcg(p,2)) ',' num2str(badEpisodesEcg(p,3)) ',' num2str(badEpisodesEcg(p,4))];
        fprintf(fid1,'%s',line);
        fprintf(fid1,'\n');
    end
    
    fid2=fopen('c:\dataProcessingFrameworkV2\data\memphis\report\goodEpisodes\intermittentBadEpisodes_rip.csv','a');
    [n11 n22]=size(badEpisodesRip);
    for p=1:n11
        line=[num2str(badEpisodesRip(p,1)) ',' num2str(badEpisodesRip(p,2)) ',' num2str(badEpisodesRip(p,3)) ',' num2str(badEpisodesRip(p,4))];
        fprintf(fid2,'%s',line);
        fprintf(fid2,'\n');
    end
end
%calculates loss at the start and end, intermittant loss, and entire episode lost
%find how much is for the wireless loss, how much is for the degradation
function [badAtStart fullEpisodeBad intermittantBad badAtEnd totalGoodDur]=wearingVsGoodEpisodes_wirelessLossAndDegradation(wearingTimes,goodEpisodes,sensor)
    if sensor==1
        disp('RIP');
    end
    if sensor==2
        disp('ECG');
    end
    
    [r c]=size(wearingTimes);
    badAtStart=[];
    fullEpisodeBad=[];
    intermittantBad=[];
    negativeDays=[];
    badAtEnd=[];
    totalGoodDur=0;
   
    for i=1:r
        i
        participant=wearingTimes(i,1);
        day=wearingTimes(i,2);
        
        load(['c:\dataProcessingFrameworkV2\data\memphis\formattedraw\' strcat('p',num2str(participant,'%02d')) '_' strcat('s',num2str(day,'%02d')) '_frmtraw.mat'])
        
        % find good episodes under this wearingTimes
        ind=find(goodEpisodes(:,1)==participant & goodEpisodes(:,2)==day);
        goodEpisodesOnThatDay=goodEpisodes(ind,:);
        startTime=wearingTimes(i,3)-30*1000;
        endTime=wearingTimes(i,4)+30*1000;
        ind2=find(goodEpisodesOnThatDay(:,3)>=startTime & goodEpisodesOnThatDay(:,4)<=endTime);
        if length(ind2)==0
            fullEpisodeBad=[fullEpisodeBad;[i (wearingTimes(i,4)-wearingTimes(i,3))/1000/60 getWirelessLoss(R,wearingTimes(i,3),wearingTimes(i,4),sensor)]];
            continue;
        end
        for m=1:length(ind2)
            totalGoodDur=totalGoodDur+(goodEpisodesOnThatDay(ind2(m),4)-goodEpisodesOnThatDay(ind2(m),3))/1000/60;
        end
        stDiff=(goodEpisodesOnThatDay(ind2(1),3)-wearingTimes(i,3))/1000/60;
        if stDiff>=0
            badAtStart=[badAtStart;[i participant day stDiff getWirelessLoss(R,wearingTimes(i,3),goodEpisodesOnThatDay(ind2(1),3),sensor)]];
         else
             negativeDays=[negativeDays;[i participant day stDiff]];
        end
        if length(ind2)>1
            for g=1:length(ind2)-1
                timeDiff=(goodEpisodesOnThatDay(ind2(g+1),3)- goodEpisodesOnThatDay(ind2(g),4))/1000/60;
                intermittantBad=[intermittantBad;[participant day timeDiff getWirelessLoss(R,goodEpisodesOnThatDay(ind2(g),4),goodEpisodesOnThatDay(ind2(g+1),3),sensor)]];
            end
        end
        %bad at the end
        badAtEnd=[badAtEnd;[i participant day (wearingTimes(i,4)-goodEpisodesOnThatDay(ind2(end),4))/1000/60 getWirelessLoss(R,goodEpisodesOnThatDay(ind2(end),4),wearingTimes(i,4),sensor)]];
    end
end


%calculates expected wireless loss between start and end
function wirelessLoss=getWirelessLoss(R,start,endd,sensor)
    wirelessLoss=0;
    samplingRate=0;
    if sensor==1
        samplingRate=21.33;
    end
    if sensor==2
        samplingRate=64;
    end
    
    ind=find(R.sensor{sensor}.timestamp>=start & R.sensor{sensor}.timestamp<=endd);
    if length(ind)>0
        wirelessLoss=((((endd-start)/1000)*samplingRate-length(ind))/samplingRate)/60;  %loss is in minute
    end
end

% Input: epsodes_wearing = wearingTimes
% 		episodes_ecg=ecgGoodEpisodes
% 		
% 		columns of each matrix are described below
% 		badAtStart : index of the wearing episode, participant#, day#, total loss at the beginning, loss at the beginning due to wireless loss
% 		fullEpisodeBad : index of the wearing episode, total full episode bad duration, out of bad data how much is for wireless loss
% 		intermittantBad : participant#, day#, total intermittant bad, out of total how much is for the wireless loss
% 		badAtEnd : index of the wearing episode, participant#, day#, total loss at the end, loss at the end due to wireless loss
% 		totalGoodDur: total duration from the ecg good episodes
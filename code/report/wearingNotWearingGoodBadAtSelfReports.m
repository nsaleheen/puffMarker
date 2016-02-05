%how many times subjects were wearing sensor while smoking & drinking
%how many times data was good while smoking, and drinking
function wearingNotWearingAtSelfReport=wearingNotWearingGoodBadAtSelfReports(pid,sid)
participant=str2num(pid(2:end));
day=str2num(sid(2:end));
load(['c:\dataProcessingFrameworkV2\data\memphis\formatteddata\' strcat('p',num2str(participant,'%02d')) '_' strcat('s',num2str(day,'%02d')) '_frmtdata.mat'])
% load(['c:\dataProcessingFrameworkV2\data\memphis\formatteddata\' pid '_' sid '_frmtdata.mat'])

ecg_episodes=load('c:\dataProcessingFrameworkV2\data\memphis\report\goodEpisodes\episodes_ecg.csv');
rip_episodes=load('c:\dataProcessingFrameworkV2\data\memphis\report\goodEpisodes\episodes_rip.csv');
wearingTimes=load('c:\dataProcessingFrameworkV2\data\memphis\report\goodEpisodes\episodes_wearing.csv');

nSmokingReports=0;
nWearingAtSmoking=0;
nNotWearingAtSmoking=0;
nRipGoodAtSmoking=0;
nRipNotGoodAtSmoking=0;

if isfield(D,'selfreport')
    nSmokingReports=length(D.selfreport{2}.timestamp);
end
for i=1:nSmokingReports
    %wearing not wearing
    indw=find(wearingTimes(:,1)==participant & wearingTimes(:,2)==day);
    wearing=wearingTimes(indw,:);
    indw2=find(wearing(:,3)<=D.selfreport{2}.timestamp(i));
    if length(indw2)==0
        nNotWearingAtSmoking=nNotWearingAtSmoking+1;
        continue;
    end
    if wearing(indw2(end),4)>=D.selfreport{2}.timestamp(i)
        nWearingAtSmoking=nWearingAtSmoking+1;
    else
        nNotWearingAtSmoking=nNotWearingAtSmoking+1;
    end
end

    
 for i=1:nSmokingReports
    %good or not good
    ind1=find(rip_episodes(:,1)==participant & rip_episodes(:,2)==day);
    ripEpisodesOnThatDay=rip_episodes(ind1,:);
    ind=find(ripEpisodesOnThatDay(:,3)<=D.selfreport{2}.timestamp(i));
    if length(ind)==0
        nRipNotGoodAtSmoking=nRipNotGoodAtSmoking+1;
        continue;
    end
    if ripEpisodesOnThatDay(ind(end),4)>=D.selfreport{2}.timestamp(i)
        nRipGoodAtSmoking=nRipGoodAtSmoking+1;
    else
        nRipNotGoodAtSmoking=nRipNotGoodAtSmoking+1;
    end
 end

 if nRipNotGoodAtSmoking+nRipGoodAtSmoking ~= nSmokingReports
        disp([pid sid]);
 end
nEcgGoodAtSmoking=0;
nEcgNotGoodAtSmoking=0;

for i=1:nSmokingReports
    %good or not good
    ind1=find(ecg_episodes(:,1)==participant & ecg_episodes(:,2)==day);
    ecgEpisodesOnThatDay=ecg_episodes(ind1,:);
    ind=find(ecgEpisodesOnThatDay(:,3)<=D.selfreport{2}.timestamp(i));
    if length(ind)==0
        nEcgNotGoodAtSmoking=nEcgNotGoodAtSmoking+1;
        continue;
    end
    if ecgEpisodesOnThatDay(ind(end),4)>=D.selfreport{2}.timestamp(i)
        nEcgGoodAtSmoking=nEcgGoodAtSmoking+1;
    else
        nEcgNotGoodAtSmoking=nEcgNotGoodAtSmoking+1;
    end
end

nDrinkingReport=0;
nWearingAtDrinking=0;
nNotWearingAtDrinking=0;
nRipGoodAtDrinking=0;
nRipNotGoodAtDrinking=0;

if isfield(D,'selfreport')
    nDrinkingReport=length(D.selfreport{1}.timestamp);
end

for i=1:nDrinkingReport
    %wearing not wearing
    indw=find(wearingTimes(:,1)==participant & wearingTimes(:,2)==day);
    wearing=wearingTimes(indw,:);
    indw2=find(wearing(:,3)<=D.selfreport{1}.timestamp(i));
    if length(indw2)==0
       nNotWearingAtDrinking=nNotWearingAtDrinking+1; 
       continue;
    end
    if wearing(indw2(end),4)>=D.selfreport{1}.timestamp(i)
        nWearingAtDrinking=nWearingAtDrinking+1;
    else
        nNotWearingAtDrinking=nNotWearingAtDrinking+1;
    end
end

for i=1:nDrinkingReport
    %good or not good
    ind1=find(rip_episodes(:,1)==participant & rip_episodes(:,2)==day);
    ripEpisodesOnThatDay=rip_episodes(ind1,:);
    ind=find(ripEpisodesOnThatDay(:,3)<=D.selfreport{1}.timestamp(i));
    if length(ind)==0
        nRipNotGoodAtDrinking=nRipNotGoodAtDrinking+1;
        continue;
    end
    if ripEpisodesOnThatDay(ind(end),4)>=D.selfreport{1}.timestamp(i)
        nRipGoodAtDrinking=nRipGoodAtDrinking+1;
    else
        nRipNotGoodAtDrinking=nRipNotGoodAtDrinking+1;
    end
end
 
if nRipNotGoodAtDrinking+nRipGoodAtDrinking ~= nDrinkingReport
        disp([pid sid]);
    end

nEcgGoodAtDrinking=0;
nEcgNotGoodAtDrinking=0;

for i=1:nDrinkingReport
    %good or not good
    ind1=find(ecg_episodes(:,1)==participant & ecg_episodes(:,2)==day);
    ecgEpisodesOnThatDay=ecg_episodes(ind1,:);
    ind=find(ecgEpisodesOnThatDay(:,3)<=D.selfreport{1}.timestamp(i));
    if length(ind)==0
        nEcgNotGoodAtDrinking=nEcgNotGoodAtDrinking+1;
        continue;
    end
    if ecgEpisodesOnThatDay(ind(end),4)>=D.selfreport{1}.timestamp(i)
        nEcgGoodAtDrinking=nEcgGoodAtDrinking+1;
    else
        nEcgNotGoodAtDrinking=nEcgNotGoodAtDrinking+1;
    end
end
wearingNotWearingAtSelfReport=[nSmokingReports nWearingAtSmoking nNotWearingAtSmoking nRipGoodAtSmoking nRipNotGoodAtSmoking nEcgGoodAtSmoking ...
    nEcgNotGoodAtSmoking nDrinkingReport nWearingAtDrinking nNotWearingAtDrinking nRipGoodAtDrinking nRipNotGoodAtDrinking nEcgGoodAtDrinking nEcgNotGoodAtDrinking];
end

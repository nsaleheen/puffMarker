%calculates which portion of wearing episodes of the day are at locationFile,
%and what are the good ecg, rip episodes under those wearing times

function [wearingEpisodes ecgEpisodes ripEpisodes]=wearingAtLocation(pid1,sid1,location)
% pid=30;
% sid=2;
pid=str2num(pid1(2:end));
sid=str2num(sid1(2:end));
if strcmpi(location,'home')
    locationFile=csvread('C:\DataProcessingFrameworkV2\data\memphis\report\LocationEpisodes\homeEpisode.csv',1,0);
elseif strcmpi(location, 'univ') || strcmpi(location,'work')
    locationFile=csvread('C:\DataProcessingFrameworkV2\data\memphis\report\LocationEpisodes\univAndWorkEpisode.csv',1,0);
elseif strcmpi(location, 'store')
    locationFile=csvread('C:\DataProcessingFrameworkV2\data\memphis\report\LocationEpisodes\storeEpisode.csv',1,0);
elseif strcmpi(location,'restaurant')
    locationFile=csvread('C:\DataProcessingFrameworkV2\data\memphis\report\LocationEpisodes\restaurantEpisode.csv',1,0);
elseif strcmpi(location,'other')
    locationFile=csvread('C:\DataProcessingFrameworkV2\data\memphis\report\LocationEpisodes\otherEpisode.csv',1,0);
end
% ripEpisodes=load('C:\DataProcessingFrameworkV2\data\memphis\report\goodEpisodes\episodes_rip.csv');
% ecgEpisodes=load('c:\dataProcessingFrameworkV2\data\memphis\report\goodEpisodes\episodes_ecg.csv');
load(['c:\dataProcessingFrameworkV2\data\memphis\formatteddata\' strcat('p',num2str(pid,'%02d')) '_' strcat('s',num2str(sid,'%02d')) '_frmtdata.mat']);

wearingEpisodes=[];

ind=find(locationFile(:,1)==pid & locationFile(:,2)==sid);
atlocationFileEcg=[];atlocationFileRip=[];
if length(ind)>0
    for i=1:length(ind)
        locationFileEcgInd=find(D.sensor{2}.timestamp>=locationFile(ind(i),3) & D.sensor{2}.timestamp<=locationFile(ind(i),4));
        locationFileRipInd=find(D.sensor{1}.timestamp>=locationFile(ind(i),3) & D.sensor{1}.timestamp<=locationFile(ind(i),4));
        atlocationFileEcg=[atlocationFileEcg D.sensor{2}.timestamp(locationFileEcgInd)];
        atlocationFileRip=[atlocationFileRip D.sensor{1}.timestamp(locationFileRipInd)];
    end
end

ripEpisodes=[];
ecgEpisodes=[];

if length(atlocationFileRip)>0
    ripEpisodes=getEpisodes(pid,sid,atlocationFileRip,1);
end
if length(atlocationFileEcg)>0
    ecgEpisodes=getEpisodes(pid,sid,atlocationFileEcg,1);
end

allTimestamps=[];
for i=1:size(ripEpisodes,1)
    indrT=find(D.sensor{1}.timestamp>=ripEpisodes(i,3) & D.sensor{1}.timestamp<=ripEpisodes(i,4));
    allTimestamps=[allTimestamps D.sensor{1}.timestamp(indrT)];
end
for i=1:size(ecgEpisodes,1)
    indeT=find(D.sensor{2}.timestamp>=ecgEpisodes(i,3) & D.sensor{2}.timestamp<=ecgEpisodes(i,4));
    allTimestamps=[allTimestamps D.sensor{2}.timestamp(indeT)];
end
allTimestamps=unique(allTimestamps);
allTimestamps=sort(allTimestamps);
wearingEpisodes=getEpisodes(pid,sid,allTimestamps,10);  %each wearing epsidoes are assumed to be apart by 10 minutes

%ignore small wearing episodes. probably they are false positive
wearingDur=[];
for i=1:size(wearingEpisodes,1)
    wearingDur=[wearingDur;(wearingEpisodes(i,4)-wearingEpisodes(i,3))/1000/60];
end
indB=find(wearingDur>=1);  %consider the wearing which are at least one minute duration
wearingEpisodes=wearingEpisodes(indB,:);

end
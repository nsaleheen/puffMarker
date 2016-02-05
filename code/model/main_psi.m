% demonstrates the use of phase slope index (PSI) as formulated in the paper:
%    Nolte G, Ziehe A, Nikulin VV, Schl\"ogl A, Kr\"amer N, Brismar T,
%    M\"uller KR. 
%    Robustly estimating the flow direction of information in complex
%    physical systems. 
%    Physical Review Letters. To appear. 
%    (for further information see    http://doc.ml.tu-berlin.de/causality/
%    )
%

% License
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see http://www.gnu.org/licenses/.

participant=14;
% day=2;
CombineFeatValEcg=[];
CombineFeatValRip=[];
CombineFeatTimeEcg=[];
CombineFeatTimeRip=[];
CombineWearabilityEcg=[];
CombineWearabilityRip=[];
dataEcg=[];
dataRip=[];
for participant=[12]% 13 15 19 20 21]
for day=1:7
    load(['c:\dataProcessingFrameworkV2\data\memphis\feature\field_' strcat('p',num2str(participant,'%02d')) '_' strcat('s',num2str(day,'%02d')) '_act10_feature.mat']);
    featMag=-1*ones(length(F.window),1);
    featTime=-1*ones(length(F.window),1);

    for i=1:length(F.window)
        featTime(i)=F.window(i).starttimestamp;
    end

    for i=1:length(F.window)
        if isfield(F.window(i).feature{4},'value') %&& F.window(i).feature{4}.value{30}>=0.21384
            featMag(i)=F.window(i).feature{4}.value{30};
%             featMag(i)=1;            
%         else
%             featMag(i)=0;
        end
    end;

    wearabilityEcg=-1*ones(length(F.window),1);
    ecg_episodes=load('c:\dataProcessingFrameworkV2\data\memphis\report\goodEpisodes\episodes_ecg.csv');
    wearingTimes=load('c:\dataProcessingFrameworkV2\data\memphis\report\goodEpisodes\episodes_wearing.csv');

    wearing=find(wearingTimes(:,1)== participant & wearingTimes(:,2)==day);
    for i=1:length(wearing)
        ind=find(featTime>=wearingTimes(wearing(i),3) & featTime<=wearingTimes(wearing(i),4));
        wearabilityEcg(ind)=0;
    end
    ind2=find(ecg_episodes(:,1)==participant & ecg_episodes(:,2)==day);
    for i=1:length(ind2)
        ind3=find(featTime>=ecg_episodes(ind2(i),3) & featTime<=ecg_episodes(ind2(i),4));
        wearabilityEcg(ind3)=1;
    end

    ecgInd=find(wearabilityEcg~=-1);
%     dataEcg=[featMag(notOne2) wearabilityEcg(notOne2)];

    wearabilityRip=-1*ones(length(F.window),1);
    rip_episodes=load('c:\dataProcessingFrameworkV2\data\memphis\report\goodEpisodes\episodes_rip.csv');
    ind4=find(rip_episodes(:,1)==participant & rip_episodes(:,2)==day);
    for i=1:length(wearing)
        ind=find(featTime>=wearingTimes(wearing(i),3) & featTime<=wearingTimes(wearing(i),4));
        wearabilityRip(ind)=0;
    end
    for i=1:length(ind4)
        ind3=find(featTime>=rip_episodes(ind4(i),3) & featTime<=rip_episodes(ind4(i),4));
        wearabilityRip(ind3)=1;
    end
    
    ripInd=find(wearabilityRip~=-1);
    CombineFeatValEcg=[CombineFeatValEcg;featMag(ecgInd)];
    CombineFeatValRip=[CombineFeatValRip;featMag(ripInd)];
    CombineFeatTimeEcg=[CombineFeatTimeEcg;featTime(ecgInd)];
    CombineFeatTimeRip=[CombineFeatTimeRip;featTime(ripInd)];
    CombineWearabilityEcg=[CombineWearabilityEcg;wearabilityEcg(ecgInd)];
    CombineWearabilityRip=[CombineWearabilityRip;wearabilityEcg(ripInd)];
%     dataEcg=[featMag(notOne2) wearabilityRip(notOne2)];
end
dataEcg=[dataEcg;[CombineFeatValEcg CombineWearabilityEcg]];
dataRip=[dataRip;[CombineFeatValRip CombineWearabilityRip]];
end

% notOne2=find(wearability~=-1);
% dataEcg=[featMag(notOne2) wearability(notOne2)];
% trivial example for flow from channel 1 to channel 2. 
% n=10000;x=randn(n+1,1);data=[x(2:n+1),x(1:n)]; 

% parameters for PSI-calculation 
% segleng=100;epleng=200;
segleng=90;epleng=200;

% calculation of PSI. The last argument is empty - meaning that 
% PSI is calculated over all frequencies
% [psi, stdpsi, psisum, stdpsisum]=data2psi(data,segleng,epleng,[]);
[psi, stdpsi, psisum, stdpsisum]=data2psi(data,segleng,[],[]);

% note, psi, as calculated by data2psi corresponds to \hat{\PSI} 
% in the paper, i.e., it is not normalized. The final is 
% the normalized version given by: 
psi./(stdpsi+eps)


% For psisum and stdpsisum refer to the paper


% To calculate psi in a band set, e.g., 
% freqs=[5:10];
% [psi, stdpsi, psisum, stdpsisum]=data2psi(data,segleng,epleng,freqs);
% %with result:
% psi./(stdpsi+eps)
% % In this example, the flow is estimated to go from channel 
% % 1 to channel 2 because the matrix element psi(1,2) is positive. 
% 
% % You can also calculate many bands at once, e.g. 
% freqs=[[5:10];[6:11];[7:12]];
% [psi, stdpsi, psisum, stdpsisum]=data2psi(data,segleng,epleng,freqs);
% %and psi has then 3 indices with the last one refering to the row in freqs: 
% psi./(stdpsi+eps)
%it returns the count of disconn events due to physical separation between
%phone and the body accelerometer
function [phys_sepa_count totalDisconnCount phys_sepa_dur]=disconnDueToPhysicalSeparationOfPhone_body(pid,sid,connDisconnMatrix)
searchDuration=60; %search activity upto xx seconds before the disconnection
day=str2num(sid(2:end));participant=str2num(pid(2:end));
phys_sepa_count=0;totalDisconnCount=0;phys_sepa_dur=0;
%find activity before disconnection from both phone and body accel
phoneAcc=load(['c:\dataProcessingFrameworkV2\data\memphis\feature\field_' pid '_' sid '_act10_feature.mat']);
featValPhone=[];
featTsPhone=[];
for i=1:length(phoneAcc.F.window)
    if isfield(phoneAcc.F.window(i).feature{5},'value')
        featValPhone=[featValPhone phoneAcc.F.window(i).feature{5}.value{30}];
        featTsPhone=[featTsPhone phoneAcc.F.window(i).starttimestamp];
    end;
end

chestAcc=load(['c:\dataProcessingFrameworkV2\data\memphis\feature\chest_accelerometer_feature\field_' pid '_' sid '_act10_feature.mat']);
featValChest=[];
featTsChest=[];
for i=1:length(chestAcc.F.window)
    if isfield(chestAcc.F.window(i).feature{4},'value')
        featValChest=[featValChest chestAcc.F.window(i).feature{4}.value{30}];
        featTsChest=[featTsChest chestAcc.F.window(i).starttimestamp];
    end;
end
%get disconn of the day
ind=find(connDisconnMatrix(:,1)==participant & connDisconnMatrix(:,2)==day);
disconnTs=connDisconnMatrix(ind,3);
connTs=connDisconnMatrix(ind,4);
for i=1:length(disconnTs)
    if disconnTs(i)~=-1
        totalDisconnCount=totalDisconnCount+1;
        %get activity from both accel right before the disconnection time
        start=disconnTs(i)-searchDuration*1000;
        endd=disconnTs(i);
        ind2=find(featTsChest>=start & featTsChest<=endd);
        ind3=find(featTsPhone>=start & featTsPhone<=endd);
        
        if length(ind2)>0 && length(ind3)>0 && featValChest(ind2(end))>=0.21348 && featValPhone(ind3(end))<=0.5
            phys_sepa_count=phys_sepa_count+1;
            phys_sepa_dur=phys_sepa_dur+(connTs(i)-disconnTs(i))/1000;
        end
    end
end
end
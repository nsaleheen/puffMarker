%returns disconnection count, disconnection duration in minute
%wearing duration in hours. Goal is to find # of disconn / hour, and disconn duration / hour
function [disconnCount disconnDur wearingDur]=getWearingwiseDisconn(pid,sid,wearingTimes)
disconnDur=0;
disconnCount=0;
wearingDur=0;

load(['E:\dataProcessingFramework\data\memphis\formattedraw\' pid '_' sid '_frmtraw.mat']);

participant=str2num(pid(2:end));
day=str2num(sid(2:end));
ind=find(wearingTimes(:,1)==participant & wearingTimes(:,2)==day);
wearingOfTheDay=wearingTimes(ind,:);
tosFileTimes=R.METADATA.tosFileTime;
% disconnCount=length(tosFileTimes);
% n=length(tosFileTimes);

[r c]=size(wearingOfTheDay);

for j=1:r
    start=wearingOfTheDay(j,3);endd=wearingOfTheDay(j,4);
    wearingDur=wearingDur+(endd-start)/1000/60/60;
    if ~isfield(R,'sensor')
        return;
    end
    ind1=find(tosFileTimes>=start & tosFileTimes<=endd);
    disconnCount=disconnCount+length(ind1);
    indT=find(R.sensor{1}.timestamp>=start & R.sensor{1}.timestamp<=endd);
    times=R.sensor{1}.timestamp(indT);
    indTos=find(tosFileTimes>=start & tosFileTimes<=endd);
    if length(indTos)>0
        for i=indTos(1):indTos(end)
            ind=find(times<tosFileTimes(i));
            if length(ind)>0
                disconnDur=disconnDur+(tosFileTimes(i)-times(ind(end)))/1000/60;
            end
        end
    end
end
end
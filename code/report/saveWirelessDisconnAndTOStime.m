%this function saves all disconnection timestamp, and next tos file
%timestamp after new connection under wearing times
function [connDisconn disconnCount wearingDur disconnDur]=saveWirelessDisconnAndTOStime(pid,sid,wearingTimes)

fid=fopen('C:\dataProcessingFramework\data\memphis\report\wirelessDisconnConnTimestamps_all.csv','a');

load(['E:\dataProcessingFramework\data\memphis\formattedraw\' pid '_' sid '_frmtraw.mat']);

participant=str2num(pid(2:end));
day=str2num(sid(2:end));
ind=find(wearingTimes(:,1)==participant & wearingTimes(:,2)==day);
wearingOfTheDay=wearingTimes(ind,:);
tosFileTimes=R.METADATA.tosFileTime;
disconnCount=length(tosFileTimes);
n=length(tosFileTimes);
disconnTs=-1;connTs=-1; connDisconn=[]; wearingDur=-1;disconnDur=0;disconnCount=0;

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
        for i=1:length(indTos)
            ind=find(times<tosFileTimes(indTos(i)));
            if length(ind)>0
                disconnDur=disconnDur+(tosFileTimes(indTos(i))-times(ind(end)))/1000/60;
                disconnTs=times(ind(end));
                connTs=tosFileTimes(indTos(i));
            end
            connDisconn=[connDisconn; participant day disconnTs connTs];
        end
    end
end

%write to the file
[r c]=size(connDisconn);
for i=1:r
    line=[pid ',' sid ',' num2str(connDisconn(i,3)) ',' num2str(connDisconn(i,4))];
    fprintf(fid,'%s',line);
    fprintf(fid,'\n');
end
end
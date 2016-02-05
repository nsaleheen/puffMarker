function [activeEpisodes]=getActiveInactiveEpisodesFromWearing(G,pid,sid,wearingTimes)

activeEpisodes=[];

participant=str2num(pid(2:end));day=str2num(sid(2:end));
ind=find(wearingTimes(:,1)==participant & wearingTimes(:,2)==day);
wearingOfTheDay=wearingTimes(ind,:);

if size(wearingOfTheDay,1)<1
    return;
end

startTimestamps=wearingOfTheDay(:,3);
startTimestampsSort=sort(startTimestamps,'ascend');
wearingOfTheDay2=[];
for i=1:length(startTimestampsSort)
    ind2=find(startTimestampsSort(i)==startTimestamps);
    wearingOfTheDay2=[wearingOfTheDay2;wearingOfTheDay(ind2,:)];
end

startTime=convert_timestamp_time(G,wearingOfTheDay2(1,3));
startTimeOfDay=convert_time_timestamp(G,[startTime(1:10) ' 00:00:00']);
endTimeOfDay=convert_time_timestamp(G,[startTime(1:10) ' 23:59:59']);
% [startTimeOfDay endTimeOfDay]=getStartEndTimeOfTheDay(G,pid,sid,'raw');  %get starttimestamp and endtimestamp of the day from the session definition file
timeGap=[];
if size(wearingOfTheDay2,1)==1
%     timeGap=[timeGap;(wearingOfTheDay(1,3)-startTimeOfDay)/1000/60/60];   %gap between two successive wearing in hours
%     timeGap=[timeGap;(endTimeOfDay-wearingOfTheDay(end,4))/1000/60/60];
%     
%     ind2=find(timeGap==max(timeGap));                %find the largest gap
%     if max(timeGap)>=5
%         if ind2==1                                                              %first gap
% %             activeEpisodes=[participant day wearingOfTheDay(1,3) endTimeOfDay (endTimeOfDay-wearingOfTheDay(1,3))/1000/60/60];
%             activeEpisodes=[participant day wearingOfTheDay(1,3) wearingOfTheDay(1,4) (wearingOfTheDay(1,4)-wearingOfTheDay(1,3))/1000/60/60];
%             inactiveEpisodes=[participant day startTimeOfDay wearingOfTheDay(1,3)];
%         elseif ind2==2                                                          %last gap
%             inactiveEpisodes=[participant day wearingOfTheDay(1,4) endTimeOfDay];
%             activeEpisodes=[participant day startTimeOfDay wearingOfTheDay(1,4) (wearingOfTheDay(1,4)-startTimeOfDay)/1000/60/60];
%         end  
%     else
%         activeEpisodes=[participant day wearingOfTheDay(1,3) wearingOfTheDay(end,4) (wearingOfTheDay(end,4)-wearingOfTheDay(1,3))/1000/60/60];  %otherwise the whole day is considered as active
%     end
    activeEpisodes=[participant day wearingOfTheDay2(1,3) wearingOfTheDay2(1,4) (wearingOfTheDay2(1,4)-wearingOfTheDay2(1,3))/1000/60/60];
elseif size(wearingOfTheDay2,1)>1
    timeGap=[timeGap;(wearingOfTheDay2(1,3)-startTimeOfDay)/1000/60/60];
    for i=1:size(wearingOfTheDay2,1)-1
        timeGap=[timeGap; (wearingOfTheDay2(i+1,3)-wearingOfTheDay2(i,4))/1000/60/60];
    end
    timeGap=[timeGap;(endTimeOfDay-wearingOfTheDay2(end,4))/1000/60/60];
    
    ind3=find(timeGap==max(timeGap));            %inactive hours are at least 5 hours
    if max(timeGap)>=5
        if ind3==1                                                                     %first gap
            activeEpisodes=[participant day wearingOfTheDay2(1,3) wearingOfTheDay2(end,4) (wearingOfTheDay2(end,4)-wearingOfTheDay2(1,3))/1000/60/60];
%             inactiveEpisodes=[participant day startTimeOfDay wearingOfTheDay(1,3)];
%         elseif ind3==2
%             inactiveEpisodes=[participant day wearingOfTheDay(1,4) endTimeOfDay];
%             activeEpisodes=[participant day startTimeOfDay wearingOfTheDay(1,4)];
        elseif ind3==size(wearingOfTheDay2,1)+1                                          %last gap
%             inactiveEpisodes=[participant day wearingOfTheDay(end,4) endTimeOfDay];
            activeEpisodes=[participant day wearingOfTheDay2(1,3) wearingOfTheDay2(end,4) (wearingOfTheDay2(end,4)-wearingOfTheDay2(1,3))/1000/60/60];
        
        else
%             inactiveEpisodes=[participant day wearingOfTheDay(ind3-1,4) wearingOfTheDay(ind3,3)];
            activeEpisodes=[participant day wearingOfTheDay2(1,3) wearingOfTheDay2(ind3-1,4) (wearingOfTheDay2(ind3-1,4)-wearingOfTheDay2(1,3))/1000/60/60];
            activeEpisodes=[activeEpisodes;participant day wearingOfTheDay2(ind3,3) wearingOfTheDay2(end,4) (wearingOfTheDay2(end,4)-wearingOfTheDay2(ind3,3))/1000/60/60];
        end
    else
        activeEpisodes=[participant day wearingOfTheDay2(1,3) wearingOfTheDay2(end,4) (wearingOfTheDay2(end,4)-wearingOfTheDay2(1,3))/1000/60/60];  %otherwise the whole day is considered as active
    end
end
end

function [startTimeOfDay endTimeOfDay]=getStartEndTimeOfTheDay(G,pid,sid,INDIR)
indir=[G.DIR.DATA G.DIR.SEP INDIR G.DIR.SEP pid];

session_def_filename=[indir G.DIR.SEP G.FILE.SESSION_DEF];
fid=fopen(session_def_filename,'r');
tline = fgetl(fid);

while ischar(tline)
    parts = textscan(tline,'%s','delimiter',',');
    parts = parts{1};
	if strendswith(session_def_filename, '.txt')==1
		ix = find(strcmp(parts, 'participant'));pid=parts{ix+1};
		ix = find(strcmp(parts, 'sessionname'));sid_now=parts{ix+1};
		ix = find(strcmp(parts, 'start'));starttimestr=parts{ix+1};
		ix = find(strcmp(parts, 'end'));endtimestr=parts{ix+1};
		
		ix = find(strcmp(parts, 'sessiontype'));sessiontype=parts{ix+1};
		if strcmp(sessiontype, 'lab') == 1
			tline = fgetl(fid);
			continue;
		end
	else
		ix = find(strcmp(parts, 'pid'));pid=parts{ix+1};
		ix = find(strcmp(parts, 'sid'));sid_now=parts{ix+1};
		ix = find(strcmp(parts, 'start'));starttimestr=parts{ix+1};
		ix = find(strcmp(parts, 'end'));endtimestr=parts{ix+1};
	end
    tline = fgetl(fid);
    if strcmp(sid_now,sid)~=1, continue;end;
%     fprintf('%-6s %-6s %-20s Task (',pid,sid,'main_formattedraw');
    
    startTimeOfDay=convert_time_timestamp(G,starttimestr);
    endTimeOfDay=convert_time_timestamp(G,endtimestr);
    break;
end
fclose(fid);
end
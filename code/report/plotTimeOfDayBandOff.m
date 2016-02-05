%cummulative band off time

%check the band off episode calculation - it seems that it may have some
%problem. I saw one day of file contains other day of data.


%define one bin for 24 hours
function bin=plotTimeOfDayBandOff(starttime,endtime)
%this function plot a horizontal bar from starttime to endtime
%starttime: array of start time
%endtime: array of end time
%length of the two array must be same
%figure
%{
hold on
for i=1:24 
    line([i*60 i*60],[0 8],'LineWidth',2,'Color','r');
    str=[num2str(i) ':00'];
    text(i*60+7,4.3,str,'rotation',90,'fontsize',12);
    %plot([i*60 i*60],[0 8],'r');           %one bar for each one hour time chunk
end;
 %}
%duration=(endtime(end)-starttime(1))/1000/60; %duration in minutes
bin=zeros(1,24);  %for 24 hours of day
%convert the timestamp into time of day
for i=1:length(starttime)
    starttimeStr=convert_timestamp_time(starttime(i));
    timeStart=strfind(starttimeStr,' ');
    timePart=starttimeStr(timeStart+1:end);
    hs=str2num(timePart(1:2));
    ms=str2num(timePart(4:5));
    ss=str2num(timePart(7:end));
    totalMinutesS=hs*60+ms;
    
    endtimeStr=convert_timestamp_time(endtime(i));
    timeEnd=strfind(endtimeStr,' ');
    timePart1=endtimeStr(timeEnd+1:end);
    he=str2num(timePart1(1:2));
    me=str2num(timePart1(4:5));
    se=str2num(timePart1(7:end));
    totalMinutesE=he*60+me;
    
    dif=he-hs;
    if dif>=1
        %i=0;
         bin(hs+1)=bin(hs+1)+(60-ms);
         bin(he+1)=bin(he+1)+me;
        if dif>1
            for i=2:dif
                bin(hs+i)=bin(hs+i)+60;         %increased by 60 minutes
            end
        end
    else
        bin(hs+1)=bin(hs+1)+(me-ms);
    end
    
    %plot([totalMinutesS totalMinutesE],[day day],'lineWidth',10);
end

%hist(bin);
%bar(bin);
%figure;
%plot(cumsum(bin));
end
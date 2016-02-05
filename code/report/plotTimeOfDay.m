function plotTimeOfDay(starttime,endtime,day)
%this function plot a horizontal bar from starttime to endtime
%starttime: array of start time
%endtime: array of end time
%length of the two array must be same
%figure
hold on
for i=1:24 
    line([i*60 i*60],[0 8],'LineWidth',2,'Color','r');
    str=[num2str(i) ':00'];
    text(i*60+7,4.3,str,'rotation',90,'fontsize',12);
    %plot([i*60 i*60],[0 8],'r');           %one bar for each one hour time chunk
end; 
%duration=(endtime(end)-starttime(1))/1000/60; %duration in minutes

%convert the timestamp into time of day
for i=1:length(starttime)
    starttimeStr=convert_timestamp_time(starttime(i));
    timeStart=strfind(starttimeStr,' ');
    timePart=starttimeStr(timeStart+1:end);
    h=str2num(timePart(1:2));
    m=str2num(timePart(4:5));
    s=str2num(timePart(7:end));
    totalMinutesS=h*60+m;
    
    endtimeStr=convert_timestamp_time(endtime(i));
    timeEnd=strfind(endtimeStr,' ');
    timePart1=endtimeStr(timeEnd+1:end);
    h1=str2num(timePart1(1:2));
    m1=str2num(timePart1(4:5));
    s1=str2num(timePart1(7:end));
    totalMinutesE=h1*60+m1;
    
    plot([totalMinutesS totalMinutesE],[day day],'lineWidth',10);
end

end
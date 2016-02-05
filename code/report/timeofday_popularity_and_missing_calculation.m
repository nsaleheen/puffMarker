clear all
run config
SETSTUDY(STUDYNAME.NIDAID,SESSIONTYPE.FIELDID);
PS_LIST=STUDYINFO{STUDYNAME.NIDAID}.TYPE{SESSIONTYPE.FIELDID};
hourlyDataAllParticipants=[];
missing=[];
PS_LIST={
%{'p19'},(cellstr(strcat('s',num2str((16:20)','%02d'))))';
%{'p99'},{'s02'};
%%{
{'p01'},(cellstr(strcat('s',num2str((1:34)','%02d'))))';
{'p02'},(cellstr(strcat('s',num2str((1:41)','%02d'))))';
{'p03'},(cellstr(strcat('s',num2str((1:28)','%02d'))))';
{'p04'},(cellstr(strcat('s',num2str((1:35)','%02d'))))';
{'p05'},(cellstr(strcat('s',num2str((1:33)','%02d'))))';
{'p06'},(cellstr(strcat('s',num2str((1:34)','%02d'))))';
{'p07'},(cellstr(strcat('s',num2str((1:20)','%02d'))))';
{'p08'},(cellstr(strcat('s',num2str((1:16)','%02d'))))';
{'p09'},(cellstr(strcat('s',num2str((1:24)','%02d'))))';
{'p10'},(cellstr(strcat('s',num2str((1:23)','%02d'))))';
{'p11'},(cellstr(strcat('s',num2str((1:25)','%02d'))))';
{'p12'},(cellstr(strcat('s',num2str((1:27)','%02d'))))';
{'p13'},(cellstr(strcat('s',num2str((1:3)','%02d'))))';
{'p14'},(cellstr(strcat('s',num2str((1:8)','%02d'))))';
{'p15'},(cellstr(strcat('s',num2str((1:10)','%02d'))))';
{'p16'},(cellstr(strcat('s',num2str((1:14)','%02d'))))';
{'p17'},(cellstr(strcat('s',num2str((1:6)','%02d'))))';
{'p18'},(cellstr(strcat('s',num2str((1:8)','%02d'))))';
%}
	%	{'p04'},{'s01','s03','s04','s06','s07','s11','s13','s14','s15','s19','s20','s21','s22','s23'};
%	{'p06'},{'s01','s03','s13','s16','s19','s20','s22','s31','s32'};
%	{'p04'},{'s07','s19','s20','s21','s22','s23'};
%	{'p06'},{'s19','s20','s22','s31','s32'};
};
pno=size(PS_LIST);
for p=1:pno
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    %raw2formattedraw_main(pid);
%	continue;
    for s=slist
        sid=char(s);
        str=['(Main) - STUDYNAME=' ,DIR.STUDYNAME, ' SESSIONNAME=' DIR.SESSIONTYPE_NAME, ' PID=', pid, ' SESSION=', sid];
        disp(str);
        %formattedraw2formatteddata_main(pid,sid);
       %formatteddata2basicfeature_main(pid,sid);
       % basicfeature2window_main(pid,sid,MODEL.DRUG);
%        window2feature_main(pid,sid,MODEL.DRUG);
%        window2feature_main(pid,sid,MODEL.STRESSWINDOW);
%        window2feature_main(pid,sid,MODEL.ACTIVITY);
%        feature2test_main(pid,sid,MODEL.STRESSWINDOW);
%        feature2test_main(pid,sid,WINDOW.ACTIVITY);
%        run_session(pid,sid,WINDOW.ACTIVITY);
        %nida_druguse_report(pid,sid);
        %getGoodDataDuraion(pid,sid);
        %missingRate=getMissingRateFromFormattedRaw(pid,sid);
        %missingRate=getMissingRateFromFormattedData(pid,sid);
        missing=[missing missingRate];
        %saveEMA2file_NIDA_format_v2(pid,sid)
        %getSelfReportCount(pid,sid)
        %save_feature2text_v2(pid,sid);
        %plot_main(pid,sid,MODEL.DRUG);
%        return ;
		bin=getTimeOfDayWiseDurationForEachParticipant(pid,sid);
        hourlyDataAllParticipants=[hourlyDataAllParticipants;[str2num(pid(2:end)) str2num(sid(2:end)) bin]];
    end;
end
disp('hi')

size(hourlyDataAllParticipants)
hourlyDataAllParticipants(1,:)
hourlyDataAllParticipants(2,:)
hourlyDataAllParticipants)
hourlyDataAllParticipants
size(hourlyDataAllParticipants)
hourlyDataAllParticipants(1,:)
hourlyAll=hourlyDataAllParticipants(:,2:end);
size(hourlyAll)
clear hourlyAll
size(hourlyAll)
hourlyAll=hourlyDataAllParticipants(:,3:end);
size(hourlyAll)
hourlyPersonDays=zeros(1,24);medianHourly=zeros(1,24);for i=1:24 hourlyPersonDays(i)=length(find(hourlyAll(:,i)));medianHourly(i)=median(hourlyAll(:,i));end;
bar(hourlyPersonDays)
hold on
text(1,hourlyPersonDays(1)+2,medianHourly(1),'rotation',90,'fontsize',20);
text(1,hourlyPersonDays(1)+2,num2str(medianHourly(1)),'rotation',90,'fontsize',20);
for i=1:24 text(i,hourlyPersonDays(i)+2,num2str(medianHourly(i)),'rotation',90,'fontsize',20); end;
hourlyPersonDays=zeros(1,24);meanHourly=zeros(1,24);for i=1:24 hourlyPersonDays(i)=length(find(hourlyAll(:,i)));meanHourly(i)=mean(hourlyAll(:,i));end;
for i=1:24 text(i,hourlyPersonDays(i)+2,num2str(meanHourly(i)),'rotation',90,'fontsize',20); end;
bar(hourlyPersonDays)
hold on
for i=1:24 text(i,hourlyPersonDays(i)+2,num2str(ceil(meanHourly(i))),'rotation',90,'fontsize',20); end;
save('C:\Users\mmrahman\Desktop\NIDA_Results\TimeOfDay-popularity.mat','hourlyDataAllParticipants')

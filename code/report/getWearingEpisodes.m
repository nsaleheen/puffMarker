% for i=15:22
% load(['c:\DataProcessingFrameworkV2\data\memphis\formatteddata\p' num2str(i) '_s02_frmtdata']);
% plot(D.sensor{1}.timestamp_all,D.sensor{1}.sample_all);
% figure;
% end;
function getWearingEpisodes(pid,sid)

fid=fopen('C:\DataProcessingFrameworkV2\data\memphis\report\wearingEpisodes.csv','a');
load(['c:\DataProcessingFrameworkV2\data\memphis\formatteddata\' pid '_' sid '_frmtdata']);
mergedQuality=[];
k=1;
for i=1:length(D.sensor{1}.quality.value)
    %     if D.sensor{1}.quality.value(1)==1
    %         continue;
    %     end
    duration=(D.sensor{1}.quality.endtimestamp(i)-D.sensor{1}.quality.starttimestamp(i))/1000/60;
    if D.sensor{1}.quality.value(i)==1 && duration<5 && i~=1
        mergedQuality.starttimestamp(k)=D.sensor{1}.quality.starttimestamp(i-1);
        mergedQuality.endtimestamp(k)=D.sensor{1}.quality.endtimestamp(i);
        mergedQuality.value(k)=D.sensor{1}.quality.value(i-1);
    elseif D.sensor{1}.quality.value(i)==0
        
    else
        mergedQuality.starttimestamp(k)=D.sensor{1}.quality.starttimestamp(i);
        mergedQuality.endtimestamp(k)=D.sensor{1}.quality.endtimestamp(i);
        mergedQuality.value(k)=D.sensor{1}.quality.value(i);
        k=k+1;
    end
end

indBandOn=find(D.sensor{1}.quality.value==0 | D.sensor{1}.quality.value==2 | D.sensor{1}.quality.value==4);
starttimestamp=D.sensor{1}.quality.starttimestamp(indBandOn);
endtimestamp=D.sensor{1}.quality.endtimestamp(indBandOn);
value=D.sensor{1}.quality.value(indBandOn);
status=ones(length(value),1);

gap=[];
for i=1:length(value)-1
    gap=[gap (starttimestamp(i+1)-endtimestamp(i))/1000/60];
end


figure
hold on
plot(D.sensor{1}.timestamp_all,D.sensor{1}.sample_all)
for i=1:length(starttimestamp)
    plot([starttimestamp(i) endtimestamp(i)],4000+[value(i) value(i)],'r')
end;

if isempty(gap)
    for i=1:length(starttimestamp)
        fprintf(fid,'%s',[pid ',' sid ',' num2str(starttimestamp(i)) ',' num2str(endtimestamp(i)) ',' num2str(value(i))]);
        fprintf(fid,'\n');
    end
    fclose(fid);
    return;
end;

mergeSet=[];
for i=1:length(gap)
    if gap(i)<5
        mergeSet=[mergeSet; i i+1];
    end;
end

if isempty(mergeSet)
    for i=1:length(starttimestamp)
        fprintf(fid,'%s',[pid ',' sid ',' num2str(starttimestamp(i)) ',' num2str(endtimestamp(i)) ',' num2str(value(i))]);
        fprintf(fid,'\n');
    end
    fclose(fid);
    return;
end;

%merge short missing values
flag=0;
count=1;
start=0;
mergeSet2=[];
for i=1:length(mergeSet(:,1))-1
    if (mergeSet(i+1,2)-mergeSet(i,2))==1
        if flag==0
            flag = 1;
            start=i;
        end
        count=count+1;
    else
        if flag==1
            mergeSet2=[mergeSet2; mergeSet(start,1) mergeSet(i,2)];
        else
            mergeSet2=[mergeSet2; mergeSet(i,1) mergeSet(i,2)];
        end
        count=1;
        flag=0;
    end
    if flag==1 && i==length(mergeSet)-1
        mergeSet2=[mergeSet2; mergeSet(start,1) mergeSet(i+1,2)];
    end
end
if (mergeSet(end,2)-mergeSet(end-1,2))>1 && length(mergeSet(:,1))>0
    mergeSet2=[mergeSet2; mergeSet(end,1) mergeSet(end,2)];
end

%now merge the timestamp using the final mergeset2
[r c]=size(mergeSet2);
for i=1:r
    endtimestamp(mergeSet2(i,1))=endtimestamp(mergeSet2(i,2));
    for j=mergeSet2(i,1)+1:mergeSet2(i,2)
        status(j)=0;
    end
end

%now take only the merged wearing episodes
%wearingEpisodes=[];
indEpisodes=find(status==1);
wearingEpisodes.starttimestamp=starttimestamp(indEpisodes);
wearingEpisodes.endtimestamp=endtimestamp(indEpisodes);
wearingEpisodes.value=value(indEpisodes);

figure
plot(D.sensor{1}.timestamp_all,D.sensor{1}.sample_all)
hold on
for i=1:length(wearingEpisodes.value)
    plot([wearingEpisodes.starttimestamp(i) wearingEpisodes.endtimestamp(i)],4000+00*[value(i) value(i)],'r');
    fprintf(fid,'%s',[pid ',' sid ',' num2str(wearingEpisodes.starttimestamp(i)) ',' num2str(wearingEpisodes.endtimestamp(i)) ',' num2str(wearingEpisodes.value(i))]);
    fprintf(fid,'\n');
end;

fclose(fid);
end
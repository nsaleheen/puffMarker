load('p01_s10_basicfeature.mat');
walkingInspiration=[]; walkingExpiration=[]; walkingStretch=[]; walkingRespRate=[];
runningInspiration=[]; runningExpiration=[]; runningStretch=[]; runningRespRate=[];
sittingInspiration=[]; sittingExpiration=[]; sittingStretch=[]; sittingRespRate=[];
standingInspiration=[]; standingExpiration=[]; standingStretch=[]; standingRespRate=[];
drivingInspiration=[]; drivingExpiration=[]; drivingStretch=[]; drivingRespRate=[];
lyingInspiration=[]; lyingExpiration=[]; lyingStretch=[]; lyingRespRate=[];
for i=1:length(B.label) 
    ind=find(B.sensor{1}.peakvalley.timestamp>B.label(i).starttime & B.sensor{1}.peakvalley.timestamp<B.label(i).endtime);
    timestamp=B.sensor{1}.peakvalley.timestamp(ind);
    PVvalue=B.sensor{1}.peakvalley.sample(ind);
    dur=diff(timestamp);
    if strcmp(B.label(i).label,'sitting')
        sittingInspiration=[sittingInspiration dur(1:2:end)];
        sittingExpiration=[sittingExpiration dur(2:2:end)];
        for k=3:2:length(PVvalue)
            sittingStretch=[sittingStretch (PVvalue(k-1)-PVvalue(k))];
        end
        for j=B.label(i).starttime:60000:B.label(i).endtime
            indd=find(j>=B.label(i).starttime & B.sensor{1}.peakvalley.timestamp<=j+60000);
            sittingRespRate=[sittingRespRate length(indd)/2];
        end
    elseif strcmp(B.label(i).label,'standing')
        standingInspiration=[standingInspiration dur(1:2:end)];
        standingExpiration=[standingExpiration dur(2:2:end)];
        for k=3:2:length(PVvalue)
            standingStretch=[standingStretch (PVvalue(k-1)-PVvalue(k))];
        end
        for j=B.label(i).starttime:60000:B.label(i).endtime
            indd=find(B.sensor{1}.peakvalley.timestamp>=j & B.sensor{1}.peakvalley.timestamp<=j+60000);
            standingRespRate=[standingRespRate length(indd)/2];
        end
    elseif strcmp(B.label(i).label,'walking')
        walkingInspiration=[walkingInspiration dur(1:2:end)];
        walkingExpiration=[walkingExpiration dur(2:2:end)];
        for k=3:2:length(PVvalue)
            walkingStretch=[walkingStretch (PVvalue(k-1)-PVvalue(k))];
        end
        for j=B.label(i).starttime:60000:B.label(i).endtime
            indd=find(B.sensor{1}.peakvalley.timestamp>=j & B.sensor{1}.peakvalley.timestamp<=j+60000);
            walkingRespRate=[walkingRespRate length(indd)/2];
        end
    elseif strcmp(B.label(i).label,'running')
        runningInspiration=[runningInspiration dur(1:2:end)];
        runningExpiration=[runningExpiration dur(2:2:end)];
        for k=3:2:length(PVvalue)
            runningStretch=[runningStretch (PVvalue(k-1)-PVvalue(k))];
        end
        for j=B.label(i).starttime:60000:B.label(i).endtime
            indd=find(B.sensor{1}.peakvalley.timestamp>=j & B.sensor{1}.peakvalley.timestamp<=j+60000);
            runningRespRate=[runningRespRate length(indd)/2];
        end
    elseif strcmp(B.label(i).label,'driving')
        drivingInspiration=[drivingInspiration dur(1:2:end)];
        drivingExpiration=[drivingExpiration dur(2:2:end)];
        for k=3:2:length(PVvalue)
            drivingStretch=[drivingStretch (PVvalue(k-1)-PVvalue(k))];
        end
        for j=B.label(i).starttime:60000:B.label(i).endtime
            indd=find(B.sensor{1}.peakvalley.timestamp>=j & B.sensor{1}.peakvalley.timestamp<=j+60000);
            drivingRespRate=[drivingRespRate length(indd)/2];
        end
    elseif strcmp(B.label(i).label,'lying')
        lyingInspiration=[lyingInspiration dur(1:2:end)];
        lyingExpiration=[lyingExpiration dur(2:2:end)];
        for k=3:2:length(PVvalue)
            lyingStretch=[lyingStretch (PVvalue(k-1)-PVvalue(k))];
        end
        for j=B.label(i).starttime:60000:B.label(i).endtime
            indd=find(B.sensor{1}.peakvalley.timestamp>=j & B.sensor{1}.peakvalley.timestamp<=j+60000);
            lyingRespRate=[lyingRespRate length(indd)/2];
        end
    end
end;
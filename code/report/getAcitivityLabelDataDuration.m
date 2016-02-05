function [walkingDur sittingDur lyingDur drivingDur runningDur standingDur]=getAcitivityLabelDataDuration(pid,sid)
walkingDur=0;sittingDur=0;lyingDur=0;drivingDur=0;runningDur=0;standingDur=0;
load(['c:\dataProcessingFrameworkV2\data\activity\formatteddata\' pid '_' sid '_frmtdata.mat'])
% load('c:\dataProcessingFrameworkV2\data\activity\formatteddata\p01_s01_frmtdata.mat');
if isfield(D,'label')
for i=1:length(D.label)
    if length(findstr(D.label(i).label, 'sit'))>0
        sittingDur=sittingDur+(D.label(i).endtime-D.label(i).starttime)/1000/60;
    elseif length(findstr(D.label(i).label,'stand'))>0
        standingDur=standingDur+(D.label(i).endtime-D.label(i).starttime)/1000/60;
    elseif length(findstr(D.label(i).label,'walk'))>0
        walkingDur=walkingDur+(D.label(i).endtime-D.label(i).starttime)/1000/60;
    elseif length(findstr(D.label(i).label,'run'))>0
        runningDur=runningDur+(D.label(i).endtime-D.label(i).starttime)/1000/60;
    elseif length(findstr(D.label(i).label,'driv'))>0
        drivingDur=drivingDur+(D.label(i).endtime-D.label(i).starttime)/1000/60;
    elseif length(findstr(D.label(i).label,'ly'))>0
        lyingDur=lyingDur+(D.label(i).endtime-D.label(i).starttime)/1000/60;
    end
end
end
end
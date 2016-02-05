function [date,day,totalWearingTime_hr,rip_missingRate,ecg_missingRate,smokingSelfRep,cravingSelfRep,drinkingSelfRep,numOfEMA_trigger,numOfEMA_answer]=short_report_on_each_day(G,pid,sid,indir)
INDIR=[G.DIR.DATA G.DIR.SEP indir];
infile=[pid '_' sid '_' G.FILE.FRMTRAW_MATNAME];
load([INDIR G.DIR.SEP infile]);

timestamps_rip=R.sensor{G.SENSOR.R_RIPID}.timestamp;
rip_missingRate=getMissingRateFromFRMTRAW(timestamps_rip,G.SENSOR.ID(G.SENSOR.R_RIPID).FREQ);

timestamps_ecg=R.sensor{G.SENSOR.R_ECGID}.timestamp;
ecg_missingRate=getMissingRateFromFRMTRAW(timestamps_ecg,G.SENSOR.ID(G.SENSOR.R_ECGID).FREQ);

dateTime=convert_timestamp_time(G,timestamps_rip(1));
[n day]=weekday(dateTime);
date=dateTime(1:10);
totalWearingTime_hr=getWearingTimeFromFRMTRAW(timestamps_rip)/60/60;

drinkingSelfRep=getSelfReportFromFRMTRAW(R,1);
smokingSelfRep=getSelfReportFromFRMTRAW(R,2);
cravingSelfRep=getSelfReportFromFRMTRAW(R,3);

[numOfEMA_trigger,numOfEMA_answer]=getEMAcountFromFRMTRAW(R);

%disp(['wearingtime=' num2str(totalWearingTime_hr) ' rip missing=' num2str(rip_missingRate) ' ecg missing=' num2str(ecg_missingRate) ' smokingRep=' num2str(smokingSelfRep) ' cravingRep=' num2str(cravingSelfRep)])

end

function missingRate=getMissingRateFromFRMTRAW(timestamps,samplingRate)
totalDuration=getWearingTimeFromFRMTRAW(timestamps);
expectedSamples=totalDuration*samplingRate;
totalSamples=length(timestamps);
missingRate=100-100*(totalSamples/expectedSamples);
end

function wearingDuration=getWearingTimeFromFRMTRAW(timestamps)
    wearingDuration=0;
    if ~isempty(timestamps)
        d=diff(timestamps)/1000/60;
        pos=find(d>10);
        for i=1:length(pos)+1
            if isempty(pos)
                wearingDuration=(timestamps(end)-timestamps(1))/1000;
                break;
            end
            
            if i==1
                wearingDuration=wearingDuration+(timestamps(pos(i))-timestamps(1))/1000;
            elseif i==length(pos)+1
                wearingDuration=wearingDuration+(timestamps(end)-timestamps(pos(i-1)+1))/1000;
            else
                wearingDuration=wearingDuration+(timestamps(pos(i))-timestamps(pos(i-1)+1))/1000;
            end
        end
    end
end
function numberOfSelfReport=getSelfReportFromFRMTRAW(R,reportID)
    numberOfSelfReport=0;
    if isfield(R.selfreport{reportID},'timestamp')
        numberOfSelfReport=length(R.selfreport{reportID}.timestamp);
    end
end

function [numberOfEMAtriggered,numberOfEMAanswered]=getEMAcountFromFRMTRAW(R)
    numberOfEMAtriggered=0;
    numberOfEMAanswered=0;
    if isfield(R.ema,'data') && ~isempty(R.ema.data)
        s=size(R.ema.data);
        numberOfEMAtriggered=s(1);
        lastColumn=R.ema.data(:,length(R.ema.data));  %check whether they replied upto the final question       
        for i=1:length(lastColumn)
            if str2num(lastColumn{i})~=-1
                numberOfEMAanswered=numberOfEMAanswered+1;
            end
        end
    end
end

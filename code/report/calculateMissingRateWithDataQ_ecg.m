%function [expectedTotalSample missingSample bandOff bandLoose bandOffArray bandLooseArray]=calculateMissingRateWithDataQ(pid,sid)
%function [expectedTotalSample missingSample bandOff bandLoose]=calculateMissingRateWithDataQ(pid,sid)
function missngBandOffBandLoose_ecg=calculateMissingRateWithDataQ_ecg(pid,sid,missngBandOffBandLoose_ecg)

global FILE DIR SENSOR

global validChunkCount;
global bandLooseEpisodeCount;
global bandOffEpisodeCount;

indir=[DIR.FORMATTEDRAW];
infile=[DIR.SESSIONTYPE_NAME(1) '_' pid '_' sid '_' FILE.FRMTRAW_MATNAME];
load([indir DIR.SEP infile]);

%% calculation of missing from valid data
IntentionalBandOffDuration=10;       %in minutes
time=R.sensor(SENSOR.R_ECGID).timestamp(find(R.sensor(SENSOR.R_ECGID).timestamp));

chunkInd=find(diff(time)/60000 > IntentionalBandOffDuration)        %assuming more than 10 minutes are intentional band off

expectedTotalSample=0;
missingSample=0;
bandOff=0;
bandLoose=0;

%% if we consider wakeup time
%{
if isfield(R,'wakeUpTime')                              %if wakeup time is available, our calculation should start after the wake up time.
    %startIndex=find(R.sensor(SENSOR.R_RIPID).timestamp>=R.wakeUpTime);
    startIndex=find(time>=R.wakeUpTime);
    if length(startIndex)==0
        start=1;
    else
        start=find(time(startIndex(1))==R.sensor(SENSOR.R_RIPID).timestamp);
    end
else
    start=1;
end
%}
%% if we do not consider wake up time
start=1;

if length(chunkInd)>0
    for i=1:length(chunkInd)
        endd=find(time(chunkInd(i))==R.sensor(SENSOR.R_ECGID).timestamp)
        if endd<=start
            continue;
        end
        %[totalSamplesExpected totalSampleMissing bandOffDuration
        %bandLooseDuration bandOffArr bandLooseArr]=ripQualityCalculation(R.sensor(SENSOR.R_RIPID).sample(start:endd),R.sensor(1).timestamp(start:endd),SENSOR.ID(SENSOR.R_RIPID).FREQ);
        missngBandOffBandLoose_ecg=ecgQualityCalculation(R.sensor(SENSOR.R_ECGID).sample(start:endd),R.sensor(SENSOR.R_ECGID).timestamp(start:endd),SENSOR.ID(SENSOR.R_ECGID).FREQ,missngBandOffBandLoose_ecg);
        %[totalSamplesExpected totalSampleMissing bandOffDuration bandLooseDuration]=ripQualityCalculation(R.sensor(SENSOR.R_RIPID).sample(start:endd),R.sensor(SENSOR.R_RIPID).timestamp(start:endd),SENSOR.ID(SENSOR.R_RIPID).FREQ);
        %bandOffArray=bandOffArr;
        %bandLooseArray=bandLooseArr;
        
        %expectedTotalSample=expectedTotalSample+totalSamplesExpected;
        %missingSample=missingSample+totalSampleMissing;
        %bandOff=bandOff+bandOffDuration;
        [duration offStart offEnd]=getBandOffTimeFromWakingHour(R,time(chunkInd(i)),time(chunkInd(i)+1))
        missngBandOffBandLoose_ecg.bandOffEpisode(bandOffEpisodeCount).start=offStart;
        missngBandOffBandLoose_ecg.bandOffEpisode(bandOffEpisodeCount).end=offEnd;
        bandOffEpisodeCount=bandOffEpisodeCount+1;
        
        %bandOff=bandOff+duration;
        %bandLoose=bandLoose+bandLooseDuration;
        start=endd+1;
    end
end

%[totalSamplesExpected totalSampleMissing bandOffDuration bandLooseDuration]=ripQualityCalculation(R.sensor(SENSOR.R_RIPID).sample(start:end),R.sensor(SENSOR.R_RIPID).timestamp(start:end),SENSOR.ID(SENSOR.R_RIPID).FREQ);
missngBandOffBandLoose_ecg=ecgQualityCalculation(R.sensor(SENSOR.R_ECGID).sample(start:end),R.sensor(SENSOR.R_ECGID).timestamp(start:end),SENSOR.ID(SENSOR.R_ECGID).FREQ,missngBandOffBandLoose_ecg);

%expectedTotalSample=expectedTotalSample+totalSamplesExpected;
%missingSample=missingSample+totalSampleMissing;
%bandOff=bandOff+bandOffDuration;
%bandLoose=bandLoose+bandLooseDuration;

%R.sensor(SENSOR.R_RIPID).ripDataQ.expectedTotalSample=expectedTotalSample;
%R.sensor(SENSOR.R_RIPID).ripDataQ.missingSample=missingSample;
%R.sensor(SENSOR.R_RIPID).ripDataQ.bandOff=bandOff;
%R.sensor(SENSOR.R_RIPID).ripDataQ.bandLoose=bandLoose;

ecg_quality.validityBandOffLoose=missngBandOffBandLoose_ecg;

outdir=[DIR.ECGQUALITY];
%outfile=[DIR.SESSIONTYPE_NAME(1) '_' pid '_' sid '_' FILE.MISSINGBANDOFFBANDLOOSE];
outfile=[DIR.SESSIONTYPE_NAME(1) '_' pid '_' sid '_' FILE.ECGQUALITY];
if isempty(dir(outdir))
    mkdir(outdir);
end

save([outdir '/' outfile],'ecg_quality');
end
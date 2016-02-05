function [ripMissingRate ecgMissingRate]=getMissingRateFromFormatteddata2(pid,sid)
    load(['c:\dataProcessingFrameworkV2\data\memphis\formatteddata\' pid '_' sid '_frmtdata.mat'])
    ripMissingRate=-1;ecgMissingRate=-1;
    ripSamples=0;ripDuration=0;   %duration in seconds
    ecgSamples=0;ecgDuration=0;
    ripTimestamps=D.sensor{1}.timestamp_all;
    episodes=getEpisodes(str2num(pid(2:end)),str2num(sid(2:end)),ripTimestamps,1);
    if ~isempty(episodes)
        [r c]=size(episodes);
        for i=1:r
            ind=find(ripTimestamps>=episodes(i,3) & ripTimestamps<=episodes(i,4));
            ripSamples=ripSamples+length(ind);
            ripDuration=ripDuration+(episodes(i,4)-episodes(i,3))/1000;
        end
    end
    ecgTimestamps=D.sensor{2}.timestamp_all;
    episodes=getEpisodes(str2num(pid(2:end)),str2num(sid(2:end)),ecgTimestamps,1);
    if ~isempty(episodes)
        [r c]=size(episodes);
        for i=1:r
            ind=find(ecgTimestamps>=episodes(i,3) & ecgTimestamps<=episodes(i,4));
            ecgSamples=ecgSamples+length(ind);
            ecgDuration=ecgDuration+(episodes(i,4)-episodes(i,3))/1000;
        end
    end
    expectedEcgSamples=ecgDuration*64;
    expectedRipSamples=ripDuration*21.33;
    ripMissingRate=100*(expectedRipSamples-ripSamples)/expectedRipSamples;
    ecgMissingRate=100*(expectedEcgSamples-ecgSamples)/expectedEcgSamples;
end
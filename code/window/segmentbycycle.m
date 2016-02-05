function W=segmentbycycle(MODEL,D,W)
global SENSOR WINDOW
%This function takes in samples and timestamps and segments it into cycles
%each segment: has its samples and timestamps
%              start time = valley time, endtime = next_valley_time -1
%              peak = index of the peak in this cycle, valley is at 1
%{
ind=0;
for starttimestamp=T(1):WINDOW.PEAKVALLEY:T(end)
    endtimestamp=starttimestamp+WINDOW.PEAKVALLEY;
    
    selected=find(T>=starttimestamp & T<=endtimestamp);
    ripV=V(selected);
    ripT=T(selected);
    if size(ripV,2)==0
        continue;
    end
    [vInd , vvDiff, rpvIndVal]=RipPVDetect(ripV);
    
    
    %%
    % IsERROR
    if isempty(vInd) || isempty(vvDiff) || isempty(rpvIndVal)
    %    str=sprintf('Error: [subject=%d day=%d valleyindex=%d v_to_v_diff=%d rpvindexvalue=%d] valley empty',subj,day,length(vInd),length(vvDiff),length(rpvIndVal));disp(str);
        continue;
    end;
    tind=find(rpvIndVal<0);
    if ~isempty(tind)
        str=sprintf('Error: rpvindexvalue negative');
        disp(str);
        disp(rpvIndVal);
        disp(tind); vInd=[];continue;end;
    %%
    %    bMinVent=BreathMinVent(rpvIndVal,length(vvDiff));
    %    peakIndex(1:end-1);
    %    v=valleyIndex(2:end);
    
    %valleyIndex=rpvIndVal(1:4:end-4);
    %peakIndex=rpvIndVal(3:4:end-4);
    
    valleyIndex = rpvIndVal(1:4:end);
    peakIndex = rpvIndVal(3:4:end);
    
    %    peakIndex = p(1:end-1);
    %    valleyIndex = v(2:end);
%}
ind=0;
for i=1:2:size(D.sensor(SENSOR.R_RIPID).peakvalley_sample,2)-2
    starttimestamp=D.sensor(SENSOR.R_RIPID).peakvalley_timestamp(i);
    endtimestamp=D.sensor(SENSOR.R_RIPID).peakvalley_timestamp(i+2);
    index=find(D.sensor(SENSOR.R_RIPID).timestamp>=starttimestamp & D.sensor(SENSOR.R_RIPID).timestamp<endtimestamp);
    if isempty(index)
        continue;
    end;
%    W.sensor(SENSOR.R_RIPID).window(ind).sample
%    if valleyIndex(i)==valleyIndex(i+1) || peakIndex(i)==peakIndex(i+1) || peakIndex(i)>valleyIndex(i+1)
%        continue;
%    end
    ind=ind+1;
    W.sensor(SENSOR.R_RIPID).window(ind).sample =D.sensor(SENSOR.R_RIPID).sample(index);
    W.sensor(SENSOR.R_RIPID).window(ind).timestamp =D.sensor(SENSOR.R_RIPID).timestamp(index);
    
    a=find(W.sensor(SENSOR.R_RIPID).window(ind).timestamp==D.sensor(SENSOR.R_RIPID).peakvalley_timestamp(i+1));
    W.sensor(SENSOR.R_RIPID).window(ind).peakindex = a;
    W.sensor(SENSOR.R_RIPID).window(ind).valleyindex = 1;
    
    W.starttimestamp=W.sensor(SENSOR.R_RIPID).window(ind).timestamp(1);
    W.endtimestamp=W.sensor(SENSOR.R_RIPID).window(ind).timestamp(end);
    
    
%    W.sensor(SENSOR.R_RIPID).window(ind).timestamp = ripT(valleyIndex(i):valleyIndex(i+1)-1);
%    W.starttimestamp(ind) = ripT(valleyIndex(i));
%    W.endtimestamp(ind) = ripT(valleyIndex(i+1)-1);
%    W.sensor(SENSOR.R_RIPID).window(ind).peakindex = peakIndex(i)-valleyIndex(i);
%    W.sensor(SENSOR.R_RIPID).window(ind).valleyindex = 1;
end
end

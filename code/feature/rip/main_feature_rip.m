function window=main_feature_rip(G,window)
fprintf('...RIP');
numofwindow = length(window);

for i=1: numofwindow
    window(i).feature{G.FEATURE.R_RIPID}.quality=window(i).sensor{G.SENSOR.R_RIPID}.quality;
    if window(i).sensor{G.SENSOR.R_RIPID}.quality~=G.QUALITY.GOOD, continue;end;
    
    window(i).feature{G.FEATURE.R_RIPID}.value=ripfeature_extraction(G,window(i).sensor{G.SENSOR.R_RIPID});
    %    F.sensor(FEATURE.RIPID).window(i).starttimestamp=W.sensor(SENSOR.R_RIPID).window(i).timestamp(1);
    %    F.sensor(FEATURE.RIPID).window(i).endtimestamp=W.sensor(SENSOR.R_RIPID).window(i).timestamp(end);
    %    F.sensor(FEATURE.RIPID).window(i).valid=W.sensor(FEATURE.RIPID).window(i).valid;
    %    if F.sensor(FEATURE.RIPID).window(i).valid~=WINDOW.VALID
    %        continue;
    %    end
    %    F.sensor(FEATURE.RIPID).window(i).feature=ripfeature_extraction(W,i,MODEL);
end

%if strcmp(MODEL.WINDOWTYPE,'cycle')
%first order differences
%    F.sensor(FEATURE.RIPID).feature = ripfeature_FD(F.sensor(FEATURE.RIPID).feature);
%MXMDSTRETCH
%    F.sensor(FEATURE.RIPID).feature = ripfeature_MXMDSTRETCHRATIO(F.sensor(FEATURE.RIPID).feature);
%    F.sensor(FEATURE.RIPID).feature = ripfeature_5cycle(F.sensor(FEATURE.RIPID).feature);
%    F.sensor(FEATURE.RIPID).featurename = FEATURE.RIP.NAME;
%else
%    F.sensor(FEATURE.RIPSTATID).featurename = FEATURE.RIPSTAT.NAME;
%end

end

function features=ripfeature_extraction(G,window)
features=[];
if ~isfield(window,'peakvalley')
    return;
end
FEATURE=G.FEATURE.R_RIP;
%startind=1; %% 1 if sequence starts with valley
%if window.peakvalley.sequence(1)==1
%    startind=2; %% if sequence starts with peak. Discard Initial peak
%end
%if mod(length(window.peakvalley.sequence(startind:end)),2)==0
%    endind=length(window.peakvalley.sequence(startind:end))-1;  %% endind indicates last the valley, no peak after that
%else
%    endind=length(window.peakvalley.sequence(startind:end));
%end
%seg=W.sensor(SENSOR.R_RIPID).window(ind);
%% respiration duration
respV = (window.peakvalley.timestamp(3:2:end)-window.peakvalley.timestamp(1:2:end-2))/1000;%double(RespirationDurationCalculate(seg.peakvalley_timestamp));

ind=find(respV>=(60/65) & respV <=(60/8));  %% Outlier removal . Valid range 8 breathe/min ~ 60 breathe/min

if isempty(ind)
    return;
end

respV=respV(ind);

features{FEATURE.RESPDURATION} = double(respV);
features{FEATURE.RESPDURQUARTDEV} = 0.5*(prctile(respV,75)-prctile(respV,25));
features{FEATURE.RESPDURMEAN} = mean(respV);
features{FEATURE.RESPDURMEDIAN} = median(respV);
features{FEATURE.RESPDUR80PERCENT} = double(prctile(respV,80));

%% inspiration duration
%inspV = window.peakvalley.timestamp(2:2:end)-window.peakvalley.timestamp(1:2:end-1);
%double(InspirationDurationCalculate(seg.peakvalley_timestamp));
inspV=(window.peakvalley.timestamp(2:2:end)-window.peakvalley.timestamp(1:2:end-1))/1000;
inspV=inspV(ind); 

features{FEATURE.INSPDURATION}=inspV;
features{FEATURE.INSPDURQUARTDEV} = 0.5*(prctile(inspV,75)-prctile(inspV,25));
features{FEATURE.INSPDURMEAN} = mean(inspV);
features{FEATURE.INSPDURMEDIAN} = median(inspV);
features{FEATURE.INSPDUR80PERCENT} = double(prctile(inspV,80));
%%Stretch UP
stretchUpValue=window.peakvalley.sample(2:2:end)-window.peakvalley.sample(1:2:end-1);
stretchUpValue=stretchUpValue(ind);
features{FEATURE.STRETCHUP}=median(stretchUpValue);
%% expiration duration
exprV = (window.peakvalley.timestamp(3:2:end)-window.peakvalley.timestamp(2:2:end))/1000;  
exprV=exprV(ind);
%double(ExpirationDurationCalculate(seg.peakvalley_timestamp));
features{FEATURE.EXPRDURATION} = double(exprV);
features{FEATURE.EXPRDURQUARTDEV} = 0.5*(prctile(exprV,75)-prctile(exprV,25));
features{FEATURE.EXPRDURMEAN} = mean(exprV);
features{FEATURE.EXPRDURMEDIAN} = median(exprV);
features{FEATURE.EXPRDUR80PERCENT} = double(prctile(exprV,80));

%% breath rate, minute ventilation
features{FEATURE.BREATHRATE} = double(median(60./respV));
features{FEATURE.MINUTEVENT} = double(BreathMinVent(window.peakvalley.sample,window.peakvalley.timestamp));
%% ie ratio
n = min(length(inspV),length(exprV));
ieRatio = inspV(1:n)./exprV(1:n);
features{FEATURE.IERATIO} = double(ieRatio);
features{FEATURE.IERATIOQUARTDEV}= 0.5*(prctile(ieRatio,75)-prctile(ieRatio,25));
features{FEATURE.IERATIOMEAN}= mean(ieRatio);
features{FEATURE.IERATIOMEDIAN}= median(ieRatio);
features{FEATURE.IERATIO80PERCENT}= prctile(ieRatio,80);

%% RSA
%rsaV=RSACalculate(seg.peakvalley_timestamp,seg.peakvalley_sample,W.sensor(SENSOR.R_ECGID).window(ind).rr_value,W.sensor(SENSOR.R_ECGID).window(ind).rr_timestamp);
%if isempty(rsaV)
%    rsaV = nan;
%else
%    features{FR.RSA}=rsaV;
%    features{FR.RSAQUARTDEV}= 0.5*(prctile(rsaV,75)-prctile(rsaV,25));
%    features{FR.RSAMEAN}= mean(rsaV);
%    features{FR.RSAMEDIAN}= median(rsaV);
%    features{FR.RSA80PERCENT}= prctile(rsaV,80);
%end
%% Stretch

strchV = double(BreathStretchCalculate(window.sample,window.timestamp,window.peakvalley.sample,window.peakvalley.timestamp));
features{FEATURE.STRETCH} = strchV;
features{FEATURE.STRETCHQUARTDEV}= 0.5*(prctile(strchV,75)-prctile(strchV,25));
features{FEATURE.STRETCHMEAN}= mean(strchV);
features{FEATURE.STRETCHMEDIAN}= median(strchV);
features{FEATURE.STRETCH80PERCENT}= prctile(strchV,80);
end

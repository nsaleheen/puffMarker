function MODEL=config_model(G)
MODEL.STRESS60.STUDYTYPE='field';  % working with field data
MODEL.STRESS60.NAME='stress60';  % model name

% list of sensors used in this model
MODEL.STRESS60.SENSORLIST=[G.SENSOR.R_ECGID,G.SENSOR.R_RIPID,G.SENSOR.R_ACLXID,G.SENSOR.R_ACLYID,G.SENSOR.R_ACLZID];
% MODEL.STRESS60.SENSORLIST=[G.SENSOR.R_ACLXID,G.SENSOR.R_ACLYID,G.SENSOR.R_ACLZID];
MODEL.STRESS60.WINDOWTYPE='time'; % window is based on time. other option: "cycle" (by peakvalley),"variable"
MODEL.STRESS60.WINDOW_LEN=1*60*1000; %length of the window: 1 minute
MODEL.STRESS60.MISSINGRATE=0.33; % work on window if the missing rate is <33% 

% MODEL.STRESS60.NORMALIZE.SENSOR.WINSORIZE=[G.SENSOR.R_ACLXID,G.SENSOR.R_ACLYID,G.SENSOR.R_ACLZID];
% MODEL.STRESS60.NORMALIZE.SENSOR.WINSORIZE_WINLEN=[inf,inf,inf];

MODEL.STRESS30.STUDYTYPE='field';  % working with field data
MODEL.STRESS30.NAME='stress30';  % model name

% list of sensors used in this model
MODEL.STRESS30.SENSORLIST=[G.SENSOR.R_RIPID,G.SENSOR.R_ECGID,G.SENSOR.R_ACLXID,G.SENSOR.R_ACLYID,G.SENSOR.R_ACLZID];
MODEL.STRESS30.WINDOWTYPE='time'; % window is based on time. other option: "cycle" (by peakvalley),"variable"
MODEL.STRESS30.WINDOW_LEN=1*30*1000; %length of the window: 1 minute
MODEL.STRESS30.MISSINGRATE=0.33; % work on window if the missing rate is <33% 

%MODEL.STRESS30.NORMALIZE.SENSOR.WINSORIZE=[G.SENSOR.R_ACLXID,G.SENSOR.R_ACLYID,G.SENSOR.R_ACLZID];
%MODEL.STRESS30.NORMALIZE.SENSOR.WINSORIZE_WINLEN=[inf,inf,inf];

%% Drug
MODEL.DRUG60.STUDYTYPE='field';  % working with field data
MODEL.DRUG60.NAME='drug60';  % model name
% list of sensors used in this model
MODEL.DRUG60.SENSORLIST=[G.SENSOR.R_RIPID,G.SENSOR.R_ECGID,G.SENSOR.R_ACLXID,G.SENSOR.R_ACLYID,G.SENSOR.R_ACLZID];
MODEL.DRUG60.WINDOWTYPE='time'; % window is based on time. other option: "cycle" (by peakvalley),"variable"
MODEL.DRUG60.WINDOW_LEN=1*60*1000; %length of the window: 1 minute
MODEL.DRUG60.MISSINGRATE=0.33; % work on window if the missing rate is <33% 
%MODEL.DRUG60.NORMALIZE.SENSOR.WINSORIZE=[G.SENSOR.R_ACLXID,inf;G.SENSOR.R_ACLYID,inf;G.SENSOR.R_ACLZID,inf];
%MODEL.DRUG60.NORMALIZE.RR=1*60*60*1000; % 1 hour

MODEL.DRUG10.STUDYTYPE='field';  % working with field data
MODEL.DRUG10.NAME='drug10';  % model name
% list of sensors used in this model
MODEL.DRUG10.SENSORLIST=[G.SENSOR.R_ECGID,G.SENSOR.R_ACLXID,G.SENSOR.R_ACLYID,G.SENSOR.R_ACLZID];
MODEL.DRUG10.WINDOWTYPE='time'; % window is based on time. other option: "cycle" (by peakvalley),"variable"
MODEL.DRUG10.WINDOW_LEN=10*1000; %length of the window: 1 minute
MODEL.DRUG10.MISSINGRATE=0.33; % work on window if the missing rate is <33% 
%MODEL.DRUG60.NORMALIZE.SENSOR.WINSORIZE=[G.SENSOR.R_ACLXID,inf;G.SENSOR.R_ACLYID,inf;G.SENSOR.R_ACLZID,inf];
%MODEL.DRUG60.NORMALIZE.RR=1*60*60*1000; % 1 hour

%% Activity
MODEL.ACT10.STUDYTYPE='field';  % working with field data
%MODEL.ACT10.STUDYTYPE='pilot';
MODEL.ACT10.NAME='act10';  % model name
% list of sensors used in this model
MODEL.ACT10.SENSORLIST=[G.SENSOR.R_ACLXID,G.SENSOR.R_ACLYID,G.SENSOR.R_ACLZID];
MODEL.ACT10.WINDOWTYPE='time'; % window is based on time. other option: "cycle" (by peakvalley),"variable"
MODEL.ACT10.WINDOW_LEN=10*1000; %length of the window: 10 second
MODEL.ACT10.MISSINGRATE=0.33; % work on window if the missing rate is <33% 
%MODEL.ACT10.NORMALIZE.SENSOR.WINSORIZE=[G.SENSOR.R_ACLXID,inf;G.SENSOR.R_ACLYID,inf;G.SENSOR.R_ACLZID,inf];
%MODEL.ACT10.NORMALIZE.RR=1*60*60*1000; % 1 hour
%% Activity
MODEL.ACT10SLIDE.STUDYTYPE='field';  % working with field data
%MODEL.ACT10.STUDYTYPE='pilot';
MODEL.ACT10SLIDE.NAME='act10slide';  % model name
% list of sensors used in this model
MODEL.ACT10SLIDE.SENSORLIST=[G.SENSOR.R_ACLXID,G.SENSOR.R_ACLYID,G.SENSOR.R_ACLZID];
MODEL.ACT10SLIDE.WINDOWTYPE='sliding'; % window is based on time. other option: "cycle" (by peakvalley),"variable"
MODEL.ACT10SLIDE.WINDOW_LEN=10*1000; %length of the window: 10 second
MODEL.ACT10SLIDE.MISSINGRATE=0.33; % work on window if the missing rate is <33% 
MODEL.ACT10SLIDE.WINDOW_SLIDING=1*1000; % sliding = 1 second

%-----------
%%Human Identification
MODEL.AUTH10.STUDYTYPE='field';  % working with field data
MODEL.AUTH10.NAME='AUTH10';  % model name for authentication
% list of sensors used in this model
MODEL.AUTH10.SENSORLIST=[G.SENSOR.R_RIPID,G.SENSOR.R_ECGID];%, G.SENSOR.R_ACLXID,G.SENSOR.R_ACLYID,G.SENSOR.R_ACLZID];
MODEL.AUTH10.WINDOWTYPE='time'; % window is based on time. other option: "cycle" (by peakvalley),"variable"
MODEL.AUTH10.WINDOW_LEN=10*1000; %length of the window: 10 seconds
MODEL.AUTH10.MISSINGRATE=0.33; % work on window if the missing rate is <33% 
end

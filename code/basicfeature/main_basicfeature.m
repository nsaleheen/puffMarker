function B=main_basicfeature(G,B)
%% Load Data (Formatted Raw, Formatted Data)
for i=1:length(B.sensor)
    if isfield(B.sensor{i},'matlabtime_all'), B.sensor{i}=rmfield(B.sensor{i},'matlabtime_all');end
    if isfield(B.sensor{i},'timestamp_all'), B.sensor{i}=rmfield(B.sensor{i},'timestamp_all');end
    if isfield(B.sensor{i},'sample_all'), B.sensor{i}=rmfield(B.sensor{i},'sample_all');end
    if i==1, if isfield(B.sensor{i},'quality'), B.sensor{i}=rmfield(B.sensor{i},'quality');end;end
end

if G.RUN.BASICFEATURE.PEAKVALLEY,
%    [B.sensor{G.FEATURE.R_RIPID}.peakvalley,B.sensor{G.FEATURE.R_RIPID}.feature]=main_basicfeature_rip(G,D.sensor{G.SENSOR.R_RIPID}.sample,D.sensor{G.SENSOR.R_RIPID}.timestamp);end
    [B.sensor{G.FEATURE.R_RIPID}.peakvalley_1,B.sensor{G.FEATURE.R_RIPID}.peakvalley_2]=main_basicfeature_rip(G,B.sensor{G.SENSOR.R_RIPID}.sample,B.sensor{G.SENSOR.R_RIPID}.timestamp);
end
fprintf(') =>  done\n');

end


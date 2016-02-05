function window=main_feature_accel(G,window)
fprintf('...accel');
numofwindow = length(window);
%basic features
for i=1: numofwindow
    if window(i).sensor{G.SENSOR.R_ACLXID}.quality~=G.QUALITY.GOOD || ...
        window(i).sensor{G.SENSOR.R_ACLYID}.quality~=G.QUALITY.GOOD ||...
        window(i).sensor{G.SENSOR.R_ACLZID}.quality~=G.QUALITY.GOOD, 
        window(i).feature{G.FEATURE.R_ACLID}.quality=G.QUALITY.BAD;
        continue;
    end;
    window(i).feature{G.FEATURE.R_ACLID}.quality=G.QUALITY.GOOD;
    %window(i).feature{G.FEATURE.R_ACLID}.value=accelerometerfeature_extraction(G,window(i).sensor{G.SENSOR.R_ACLXID},window(i).sensor{G.SENSOR.R_ACLYID},window(i).sensor{G.SENSOR.R_ACLZID});
    window(i).feature{G.FEATURE.R_ACLID}.value=accelerometerfeature_extraction_new(G,window(i).sensor{G.SENSOR.R_ACLXID},window(i).sensor{G.SENSOR.R_ACLYID},window(i).sensor{G.SENSOR.R_ACLZID},32/3);

%    accelerometerfeature_extraction(W.sensor{SENSOR.R_ACLXID}.window(i),W.sensor{SENSOR.R_ACLYID}.window(i),W.sensor{SENSOR.R_ACLZID}.window(i));
%    end
end


end

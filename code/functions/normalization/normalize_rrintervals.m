function D=normalize_rrintervals(D,normalization_times,type)
global SENSOR
global NORMALIZATION

if nargin < 3
    type = 1;
end
temp = D.sensor(SENSOR.R_ECGID);
if nargin >= 2
    inds = [];
    for i=1:size(normalization_times,1)
        inds = [inds, find(temp.rr_timestamp >= normalization_times(i,1) & temp.rr_timestamp <= normalization_times(i,2))];
    end

    x = temp.rr_value(inds);
    x = x(temp.rr_outlier(inds) ~= 1);
else
    x = temp.rr_value(temp.rr_outlier ~= 1);
end

med = nanmedian(x);
mad = nanmedian(abs(x-med));


low = med-NORMALIZATION.BETA*mad;
high = med+NORMALIZATION.BETA*mad;
if NORMALIZATION.TRIM
    x = x(x<=high & x >= low);
else
    x(x>high) = high;
    x(x<low) = low;
end

if type == 1
    D.sensor(SENSOR.R_ECGID).rr_value(temp.rr_outlier ~= 1)=(D.sensor(SENSOR.R_ECGID).rr_value(temp.rr_outlier ~= 1)-nanmean(x))/sqrt(nanvar(x));
elseif type == 2
    D.sensor(SENSOR.R_ECGID).rr_value(temp.rr_outlier ~= 1)=(x-nanmean(x))/sqrt(nanvar(x));
else    
    D.sensor(SENSOR.R_ECGID).rr_value(temp.rr_outlier ~= 1)=(D.sensor(SENSOR.R_ECGID).rr_value(temp.rr_outlier ~= 1)-nanmean(D.sensor(SENSOR.R_ECGID).rr_value(temp.rr_outlier ~= 1)))/sqrt(nanvar(D.sensor(SENSOR.R_ECGID).rr_value(temp.rr_outlier ~= 1)));
end
end

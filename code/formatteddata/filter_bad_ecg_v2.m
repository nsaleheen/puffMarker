function [sample,timestamp]=filter_bad_ecg_v2(sample,timestamp)

windowlength=128;
range_threshold=200;
slope_threshold=50;

for i=1:windowlength:length(sample)-(windowlength-1)
   win = i:i+windowlength-1;
   mins = min(sample(win));
   maxs = max(sample(win));
   range=maxs-mins;
   median_slope = median(abs(diff(sample(win))));

    if range<range_threshold ||median_slope > slope_threshold || maxs > 4000
       sample(win) = nan;
       timestamp(win) = nan;
    end  
end

sample = sample(~isnan(sample));
timestamp = timestamp(~isnan(timestamp));

end
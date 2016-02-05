function [sample,timestamp,matlabtime]=filter_bad_ecg(sample,timestamp,matlabtime, windowlength,threshold)
if nargin < 5
   threshold = 50;
end
if nargin < 4
   windowlength = 50;
end

for i=1:windowlength:length(sample)-(windowlength-1)
   win = i:i+windowlength-1;
   mins = min(sample(win));
   maxs = max(sample(win));
   median_slope = median(abs(diff(sample(win))));

   if median_slope > threshold || maxs > 4000 || mins == 0
       sample(win) = nan;
       timestamp(win) = nan;
	   matlabtime(win)=nan;
   end
end
sample = sample(~isnan(sample));
timestamp = timestamp(~isnan(timestamp));
matlabtime=matlabtime(~isnan(matlabtime));
end

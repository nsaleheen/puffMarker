function [sample,timestamp,matlabtime]=filter_bad_RIP(sample,timestamp,matlabtime, windowlength,range_threshold)
if nargin < 5
   range_threshold = 100;
end
if nargin < 4
   windowlength = 50;
end

for i=1:windowlength:length(sample)-(windowlength-1)
   win = i:i+windowlength-1;
   mins = min(sample(win));
   maxs = max(sample(win));
   range=maxs-mins;
   stdDev=std(sample(win));

    if range<range_threshold % if variation/range of windowed signal is less than threshold 
       sample(win) = nan;
       timestamp(win) = nan;
	   matlabtime(win)=nan;
   end
end
if (length(sample)-i)>0
	sample(i:end)=nan;
	timestamp(i:end)=nan;
	matlabtime(i:end)=nan;
end
sample = sample(~isnan(sample));
timestamp = timestamp(~isnan(timestamp));
matlabtime=matlabtime(~isnan(matlabtime));

end

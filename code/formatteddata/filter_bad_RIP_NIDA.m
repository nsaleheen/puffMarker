function[sample,timestamp,matlabtime]=filter_bad_RIP_NIDA(sample,timestamp,matlabtime)

 windowlength = 50;
 range_threshold = 100;
 slope_threshold=1500;

% figure;
% % plot(sample,'m');hold on;
for i=1:windowlength:length(sample)-(windowlength-1)
     win = i:i+windowlength-1;
     mins = min(sample(win));
     maxs = max(sample(win));
     range=maxs-mins;
     maximum_slope=(max(diff(sample(win))));
     
     if (range<range_threshold && maxs > 4000) || mins==0 || maximum_slope > slope_threshold % if variation/range of windowed signal is less than threshold
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
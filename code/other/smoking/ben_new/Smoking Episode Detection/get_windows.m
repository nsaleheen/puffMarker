function [windows] = get_windows(puff_timesL,puff_timesR, window_size)

%Compute the number of windows
start_time   = min(puff_timesL(1),puff_timesR(1));
end_time     = max(puff_timesL(end),puff_timesR(end));
num_windows  = ceil((end_time-start_time)/window_size);

%Define window start and end times
windows = start_time + [(0:window_size:(num_windows-1)*window_size)',... 
                        (window_size:window_size:(num_windows)*window_size)'];



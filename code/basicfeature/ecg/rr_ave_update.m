function rr_ave1 = rr_ave_update(Rpeak_temp1,rr_ave2)
peak_interval = diff([0 Rpeak_temp1]);
if length(peak_interval) <= 7
    rr_ave1 = rr_ave2;
else
    rr_ave1 = sum(peak_interval(end-7:end))/8;
end

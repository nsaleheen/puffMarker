function [RR_new, time_new]=preprocess(RR,seg,TIME)
time = [];
time(1) = 0;
for i = 1:length(RR)-1
    time(i+1) = time(i)+RR(i);
end
m = floor(time/seg);
for j = 1:floor(max(time)/seg)+1
    if sum(m==j-1) < 0.25*seg
        RR_new1(j) = NaN;
    else  
    RR_new1(j) = median(RR(find(m==j-1)));
    end 
end
nan_index = find((isnan(RR_new1)==1));
mn = mean(RR_new1(find(isnan(RR_new1)~=1)));
RR_new1(nan_index) = mn;
RR_new_fil = filter_RR(RR_new1,seg);
RR_new = RR_new1;
RR_new(nan_index) = RR_new_fil(nan_index);


for k = 1:length(RR_new)
    time_new(k) = k*seg;
end




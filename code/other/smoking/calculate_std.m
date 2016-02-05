function [res]=calculate_std(sample,timestamp,duration)
res=zeros(1,length(sample));
v=30*duration/1000;
for i=1:length(sample)
    curtime=timestamp(i);
    if i<=v, temp_s=sample(1:i);temp_t=timestamp(1:i);
    else temp_s=sample(i-v:i);temp_t=timestamp(i-v:i);
    end
    ind=find(temp_t>=curtime-duration & temp_t<=curtime);
    res(i)=res(temp_s(ind));
end

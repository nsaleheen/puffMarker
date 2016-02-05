function [out,time]=compute_moving_avg(sample,timestamp,w,start_timestamp,end_timestamp)
out=[];time=[];
if isempty(timestamp), return;end;
out=[];
time=[];
now=0;
for i=start_timestamp:1000:end_timestamp % moving by 1 second
    now=now+1;
    ind=find(timestamp>=i-(w/2)*1000 & timestamp<=i+(w/2)*1000);
    time(now)=i;
    if isempty(ind), 
        if now==1, out(now)=0;
        else out(now)=out(now-1);
        end
    else
        out(now)=mean(sample(ind));
    end
end
end

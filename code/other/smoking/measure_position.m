function [avg,time]=measure_position(sample,timestamp,slide,move,threshold)
now=0;
for curtime=timestamp(1):move:timestamp(end)
    ind=find(timestamp>=curtime-slide & timestamp<=curtime);
    p=length(find(sample(ind)>threshold));
    n=length(find(sample(ind)<-threshold));
    now=now+1;
    if p==0 && n==0, avg(now)=0;
    elseif p>n, avg(now)=1;
    else avg(now)=-1;
    end
    time(now)=curtime;
end

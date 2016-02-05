function [mv1,mv2,pos1,pos2]=find_macd_intersect(sample,slow,fast,signal)

[mv1,mv2]=compute_macd_moving(sample,slow,fast,signal);
val=(mv1-mv2);
pos1=find(val(1:end-1)>=0 & val(2:end)<0);
pos2=find(val(1:end-1)<=0 & val(2:end)>0);
end

function [mavg1,mavg2]=compute_macd_moving(sample,p1,p2,p3)
[mavg1,mavg2]=macd(sample',p1,p2,p3);
end
%{
function [mavg1,mavg2,time]=compute_macd(sample,matlabtime,p1,p2,p3,wsize)
out=zeros(1,length(matlabtime(1):(1.0*wsize)/(24*60*60):matlabtime(end)));
time=zeros(1,length(matlabtime(1):(1.0*wsize)/(24*60*60):matlabtime(end)));
now=0;

for i=matlabtime(1):(1.0*wsize)/(24*60*60):matlabtime(end)
    now=now+1;
    ind=find(matlabtime>=i & matlabtime<=i+(wsize)/(24*60*60));
    time(now)=i+(wsize/2)/(24*60*60);
    if isempty(ind), out(now)=out(now-1);
    else out(now)=mean(sample(ind));
    end
end
[mavg1,mavg2]=macd(out',p1,p2,p3);
end

function [out,time]=compute_moving_avg(sample,matlabtime,w)
out=zeros(1,length(matlabtime(1):1.0/(24*60*60):matlabtime(end)));
time=zeros(1,length(matlabtime(1):1.0/(24*60*60):matlabtime(end)));
now=0;
for i=matlabtime(1):1.0/(24*60*60):matlabtime(end) % moving by 1 second
    now=now+1;
    ind=find(matlabtime>=i-(w/2)/(24*60*60) & matlabtime<=i+(w/2)/(24*60*60));
    time(now)=i;
    if isempty(ind), 
        out(now)=out(now-1);
    else
        out(now)=mean(sample(ind));
    end
end
end
%}
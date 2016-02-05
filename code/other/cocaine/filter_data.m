function [v,t]=filter_data(N)
v=N.rr.avg.t60;        t=N.rr.avg.timestamp;
return;
[x,y]=min(v);        v(1:y)=[];t(1:y)=[];
H=max(N.rr.avg.t60)-min(N.rr.avg.t60);
h=max(N.rr.avg.t60(1:valid_ind))-min(N.rr.avg.t60(1:valid_ind));
if H*.95>h,
    v=[];t=[];
end
end

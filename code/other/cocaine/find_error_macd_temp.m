function both=find_error_macd_temp(G,pid,sid,P,w,slow,fast,signal,M)
both=0;
ppid=str2num(pid(2:end));ssid=str2num(sid(2:end));
time=P.rr.smoothtime;
sample=P.rr.(['t' num2str(w)]);
[mv1,mv2,pos]=find_macd_intersect(sample,slow,fast,signal);
if ~isempty(M{1}{ppid,ssid})
    time=sort(M{1}{ppid,ssid});
    for i=1:2:length(time)
        [res,ind]=min(abs(P.rr.smoothtime(pos)-time(i)));
        if length(pos)==ind, continue;end;
        res=res*24*60*60;
        temp=abs(P.rr.smoothtime(pos(ind+1))-time(i+1));
        temp=temp*24*60*60;
        both=both+res+temp;
    end
end
end

function [left,right]=find_error_macd_left_right(G,pid,sid,P,w,slow,fast,signal,M,posM)
left=0;right=0;
ppid=str2num(pid(2:end));ssid=str2num(sid(2:end));
time=P.rr.smoothtime;
sample=P.rr.(['t' num2str(w)]);
[mv1,mv2,pos]=find_macd_intersect(sample,slow,fast,signal);
if ~isempty(M{1}{ppid,ssid})
    time=sort(M{1}{ppid,ssid});
    for i=1:2:length(time)
        if i==length(time), continue;end;
        [res,mpos]=min(abs(P.rr.smoothtime(posM)-time(i)));
        [res,ind]=min(abs(P.rr.smoothtime(pos)-P.rr.smoothtime(posM(mpos))));
        left=left+abs(time(i)-P.rr.smoothtime(pos(ind)))*24*60*60;
        [res,mpos]=min(abs(P.rr.smoothtime(posM)-time(i+1)));
        [res,ind]=min(abs(P.rr.smoothtime(pos)-P.rr.smoothtime(posM(mpos))));
        right=right+abs(time(i+1)-P.rr.smoothtime(pos(ind)))*24*60*60;
    end
end
end

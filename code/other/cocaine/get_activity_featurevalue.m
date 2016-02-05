function [value,timestamp,matlabtime,quality]=get_activity_featurevalue(G,pid,sid,MODEL)
indir=[G.DIR.DATA G.DIR.SEP 'feature'];infile=[MODEL.STUDYTYPE '_' pid '_' sid '_' MODEL.NAME '_' G.FILE.FEATURE_MATNAME];
load([indir G.DIR.SEP infile]);

value=[];
timestamp=[];
matlabtime=[];
now=0;
for i=1:length(F.window)
    now=now+1;
    timestamp(now)=(F.window(i).starttimestamp+F.window(i).endtimestamp)/2;
    matlabtime(now)=(F.window(i).start_matlabtime+F.window(i).end_matlabtime)/2;
    quality(now)=F.window(i).feature{4}.quality;
    if F.window(i).feature{4}.quality~=0, 
        if now==1, value(now)=0;else value(now)=value(now-1);end;
        continue;
    end;
    value(now)=F.window(i).feature{4}.value{30};
end
k=prctile(value,99);
value(find(value>k))=k;
k=prctile(value,1);
value(find(value<k))=k;
end

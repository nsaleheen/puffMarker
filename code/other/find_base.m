function [baserr,baseacl,aclmax,aclmid]=find_base(G,B,F,D)

[timestamp2,matlabtime2,value2]=get_featurevalue(G,F,G.FEATURE.R_ACLID,G.FEATURE.R_ACL.STDEVMAGNITUDE);
x=value2(find(value2~=-1));
baseacl=prctile(x,33);
aclmax=prctile(x,75);
aclmid=prctile(x,50);
len=12;

ind=find(B.sensor{G.SENSOR.R_ECGID}.rr.quality==G.QUALITY.GOOD);
rr=[];
for i=1:length(value2)-len
    if ~isempty(find(value2(i:i+len)==-1, 1)), continue;end;
    if length(find(value2(i:i+len)<aclmid))>=len-2 && value2(i+len)<baseacl,
        timestamp=timestamp2(i+len);
        flag=0;
        if isfield(D.adminmark,'timestamp')
            for k=1:length(D.adminmark.timestamp)
                if abs(timestamp-D.adminmark.timestamp(k))<40*60*1000,flag=1;end;
            end
        end
        if flag==0
            ind1=find(B.sensor{G.SENSOR.R_ECGID}.rr.timestamp(ind)>=timestamp & B.sensor{G.SENSOR.R_ECGID}.rr.timestamp(ind)<=timestamp+10000);
            rr=[rr B.sensor{G.SENSOR.R_ECGID}.rr.sample(ind(ind1))];
        end
    end
end
baserr=median(rr);
end

function [timestamp,matlabtime,value]=get_featurevalue(G,F,fid,ffid)
matlabtime=[];value=[];
for w=1:length(F.window)
    matlabtime(w)=-1;value(w)=-1;timestamp(w)=-1;
    
    if F.window(w).feature{fid}.quality~=G.QUALITY.GOOD, continue;end
    if F.window(w).starttimestamp==0, continue;end;
    if F.window(w).start_matlabtime==0, continue;end;
    if length(F.window(w).feature{fid}.value)<ffid,continue;end;
    matlabtime(w)=F.window(w).start_matlabtime;
    value(w)=F.window(w).feature{fid}.value{ffid};
    timestamp(w)=F.window(w).starttimestamp;
end

end

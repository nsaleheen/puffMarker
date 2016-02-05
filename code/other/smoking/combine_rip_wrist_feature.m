function F=combine_rip_wrist_feature(G,rip,wrist,P)
fripno=size(rip.feature,1);
fwristno=size(wrist{1}.feature,1);
F{1}.featurename=[rip.featurename,wrist{1}.featurename,'RStime-WStime','REtime-WStime','RStime-WEtime','REtime-WEtime','RPStime-WEtime'];
F{2}.featurename=[rip.featurename,wrist{1}.featurename,'RStime-WStime','REtime-WStime','RStime-WEtime','REtime-WEtime','RPStime-WEtime'];
for i=1:2
    s=0;
    F{i}.wrist_ind=wrist{i}.ind;
    F{i}.peak_ind=wrist{i}.peak_ind;
    for now=1:length(wrist{i}.starttimestamp)
        peak_ind=wrist{i}.peak_ind(now)/2;
        if peak_ind==0, continue;end;
        if length(rip.starttimestamp)<peak_ind, continue;end;
        
        s=s+1;
        
        rstime=rip.starttimestamp(peak_ind);retime=rip.endtimestamp(peak_ind);
        rptime=P.sensor{1}.peakvalley_new_3.timestamp(peak_ind*2);

        wstime=wrist{i}.starttimestamp(now);wetime=wrist{i}.endtimestamp(now);
        F{i}.rip.missing(s)=rip.missing(peak_ind);
        F{i}.wrist.missing(s)=wrist{i}.missing(now);
        F{i}.missing(s)=find_missing(G,P,i, min(rstime,wstime)-3000,max(retime,wetime)+3000);
        F{i}.puff(s)=wrist{i}.puff(now);
        F{i}.episode(s)=wrist{i}.episode(now);
        
        F{i}.feature(s,1:fripno)=rip.feature(:,peak_ind);
        F{i}.feature(s,fripno+1:fripno+fwristno)=wrist{i}.feature(:,now);
        F{i}.feature(s,fripno+fwristno+1)=rstime-wstime;
        F{i}.feature(s,fripno+fwristno+2)=retime-wstime;
        F{i}.feature(s,fripno+fwristno+3)=rstime-wetime;
        F{i}.feature(s,fripno+fwristno+4)=retime-wetime;
        F{i}.feature(s,fripno+fwristno+5)=rptime-wetime;
        F{i}.rstime(s)=rstime;
        F{i}.retime(s)=retime;
        F{i}.rstime(s)=wstime;
        F{i}.retime(s)=wetime;
        
    end
end
end
function missing=find_missing(G,P,i,stime,etime)
if i==1, IDS=[G.SENSOR.R_RIPID,G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_GYRZID];
else IDS=[G.SENSOR.R_RIPID,G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_GYRZID];
end
missing=0;
for id=IDS
    freq=G.SENSOR.ID(id).FREQ;
    [a,b]=binarysearch(P.sensor{id}.timestamp,stime,etime);
    len=b-a+1;
    m=1-len/(freq*((etime-stime)/1000));
    if m>missing, missing=m;end
end
end

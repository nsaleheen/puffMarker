function P=find_mark_peakvalley(G,P)
P.wrist{1}.gyr.segment.peak_ind=zeros(1,length(P.wrist{1}.gyr.segment.startmatlabtime));
P.wrist{2}.gyr.segment.peak_ind=zeros(1,length(P.wrist{2}.gyr.segment.startmatlabtime));

for e=1:length(P.smoking_episode)
    if ~isfield(P.smoking_episode{e},'puff'), continue;end;
    if isempty(P.smoking_episode{e}.puff), continue;end;
    if isempty(P.smoking_episode{e}.puff.timestamp), continue;end;
    id=P.smoking_episode{e}.puff.gyr.id;
    P.smoking_episode{e}.puff.gyr.peak_ind=ones(1,length(P.smoking_episode{e}.puff.gyr.starttimestamp))*-1;
    for p=1:length(P.smoking_episode{e}.puff.gyr.starttimestamp)
        if P.smoking_episode{e}.puff.gyr.valid(p)~=0, continue;end;
        stime=P.smoking_episode{e}.puff.gyr.starttimestamp(p);
        etime=P.smoking_episode{e}.puff.gyr.endtimestamp(p);
        seg_ind=P.smoking_episode{e}.puff.gyr.seg_ind(p);
        x=find(P.sensor{1}.peakvalley_new_3.timestamp>=etime);
        if isempty(x), continue;end;
        index=x(1);
        if mod(index,2)==1, index=index+1;end;
        if P.sensor{1}.peakvalley_new_3.sample(index+2)-100>P.sensor{1}.peakvalley_new_3.sample(index) && P.sensor{1}.peakvalley_new_3.timestamp(index+2)-etime<6000, index=index+2;end;
        P.smoking_episode{e}.puff.gyr.peak_ind(p)=index;
        P.wrist{id}.gyr.segment.peak_ind(seg_ind)=index;        
    end
end
end
%{
if P.smoking_episode{episode}.hand=='R'
    segind=P.smoking_episode{episode}.puff.seg_R_ind;
    sind=P.sensor{G.SENSOR.WR9_ACLYID}.segment(segind);
    eind=P.sensor{G.SENSOR.WR9_ACLYID}.segment(segind+1);
    stime=P.sensor{G.SENSOR.WR9_ACLYID}.timestamp(sind);
    etime=P.sensor{G.SENSOR.WR9_ACLYID}.timestamp(eind);
else
    segind=P.smoking_episode{episode}.puff.seg_L_ind;
    sind=P.sensor{G.SENSOR.WL9_ACLYID}.segment(segind);
    eind=P.sensor{G.SENSOR.WL9_ACLYID}.segment(segind+1);
    stime=P.sensor{G.SENSOR.WL9_ACLYID}.timestamp(sind);
    etime=P.sensor{G.SENSOR.WL9_ACLYID}.timestamp(eind);
end

peak_ind=[];
for p=1:length(P.smoking_episode{episode}.puff.timestamp)
    ind=find_peak(G,P,stime(p),etime(p));
    peak_ind=[peak_ind, ind];
end
P.smoking_episode{episode}.puff.peak_ind=peak_ind;

end

function peak_ind=find_peak(G,P,stime,etime)
peak_ind=-1;
p_timestamp=P.sensor{G.SENSOR.R_RIPID}.peakvalley.timestamp(2:2:end);
ind=find(p_timestamp>=stime & p_timestamp<=etime+5*1000);
if isempty(ind), return;end
stretch=0;who=-1;
for i=1:length(ind)
    vstime=P.sensor{G.SENSOR.R_RIPID}.peakvalley.timestamp(ind(i)*2-1);
    vetime=P.sensor{G.SENSOR.R_RIPID}.peakvalley.timestamp(ind(i)*2+1);
    ind1=find(P.sensor{G.SENSOR.R_RIPID}.timestamp>=vstime & P.sensor{G.SENSOR.R_RIPID}.timestamp<=vetime);
    strch=max(P.sensor{G.SENSOR.R_RIPID}.sample(ind1))-min(P.sensor{G.SENSOR.R_RIPID}.sample(ind1));
    if strch>stretch, stretch=strch; who=i;end;
    %    p_timestamp(ind(i)
    %    [value,pos]=max(p_sample(xx));
    
    %    puff.ind_R_V(puffno)=xx(pos)*2-1;
end
peak_ind=ind(who)*2;
end
%}
function P=map_wrist_rip(G,P)
for i=1:2
    P.wrist{i}.gyr.segment.peak_ind=zeros(1,length(P.wrist{i}.gyr.segment.starttimestamp));
    vind=find(P.wrist{i}.gyr.segment.valid_all==0);
    for j=vind
        etime=P.wrist{i}.gyr.segment.endtimestamp(j);
        x=find(P.sensor{1}.peakvalley_new_3.timestamp>=etime);
        if isempty(x), P.wrist{i}.gyr.segment.peak_ind(j)=0;continue;end;
        index=x(1);
        if mod(index,2)==1, index=index+1;end;
%        if index+3<=length(P.sensor{1}.peakvalley_new_3.sample) && P.sensor{1}.peakvalley_new_3.sample(index+2)-min(P.sensor{1}.peakvalley_new_3.sample(index+1),P.sensor{1}.peakvalley_new_3.sample(index+3))>P.sensor{1}.peakvalley_new_3.sample(index)-min(P.sensor{1}.peakvalley_new_3.sample(index-1),P.sensor{1}.peakvalley_new_3.sample(index+1)), index=index+2;end;
%         if index+2<=length(P.sensor{1}.peakvalley_new_3.sample)  && P.sensor{1}.peakvalley_new_3.timestamp(index+2)-etime<6000 
%             if P.sensor{1}.peakvalley_new_3.sample(index+2)-100>P.sensor{1}.peakvalley_new_3.sample(index), 
%                 index=index+2;
%             end;
%         end
        if index+2<=length(P.sensor{1}.peakvalley_new_3.sample)  && P.sensor{1}.peakvalley_new_3.timestamp(index+2)-etime<6000 
            next=P.sensor{1}.peakvalley_new_3.sample(index+2)-min(P.sensor{1}.peakvalley_new_3.sample(index+1),P.sensor{1}.peakvalley_new_3.sample(index+3));
            cur=P.sensor{1}.peakvalley_new_3.sample(index)-min(P.sensor{1}.peakvalley_new_3.sample(index-1),P.sensor{1}.peakvalley_new_3.sample(index+1));
            if next>cur
                index=index+2;
            end;
        end
        
        P.wrist{i}.gyr.segment.peak_ind(j)=index;
    end
end
if ~isfield(P,'smoking_episode'), return ;end;
count=0;
for e=1:length(P.smoking_episode)
    if ~isfield(P.smoking_episode{e},'puff'), continue;end;
    if ~isfield(P.smoking_episode{e}.puff,'gyr'), continue;end;
    if isempty(P.smoking_episode{e}.puff), continue;end;
    if isempty(P.smoking_episode{e}.puff.timestamp), continue;end;
    id=P.smoking_episode{e}.puff.gyr.id;
    P.smoking_episode{e}.puff.gyr.peak_ind=ones(1,length(P.smoking_episode{e}.puff.gyr.starttimestamp))*-1;
    for p=1:length(P.smoking_episode{e}.puff.gyr.starttimestamp)
        if P.smoking_episode{e}.puff.gyr.valid(p)~=0, continue;end;
        seg_ind=P.smoking_episode{e}.puff.gyr.seg_ind(p);
        P.smoking_episode{e}.puff.gyr.peak_ind(p)=P.wrist{id}.gyr.segment.peak_ind(seg_ind);
        count=count+1;
    end
end
end


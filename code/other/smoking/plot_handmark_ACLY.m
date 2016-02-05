function plot_handmark_ACLY(G,data,SENSORIDS)

ymax=0;
for s=SENSORIDS
    ymax=ymax+max(data.sensor{s}.sample)+abs(min(data.sensor{s}.sample));
end
offset=ymax;
for s=SENSORIDS
    hold on;
    offset=offset-max(data.sensor{s}.sample)-abs(min(data.sensor{s}.sample));
    if isempty(data.sensor{s}.matlabtime),        continue;    end
    for e=1:length(data.smoking_episode)
        if isfield(data.smoking_episode{e},'hand')==1 && data.smoking_episode{e}.hand=='R' && s==G.SENSOR.WR9_ACLYID
            minv=min(data.sensor{s}.sample);
            segind=data.smoking_episode{e}.puff.seg_R_ind;
            sind=data.sensor{s}.segment(segind);
            eind=data.sensor{s}.segment(segind+1);
            plot_signal(data.sensor{s}.matlabtime(sind),data.sensor{s}.sample_filtered(sind)+abs(minv),'r','o',5,offset);
            plot_signal(data.sensor{s}.matlabtime(eind),data.sensor{s}.sample_filtered(eind)+abs(minv),'r','o',5,offset);
            
%             for p=1:length(data.smoking_episode{e}.puff.seg_R_ind)
%                 segind=data.smoking_episode{e}.puff.seg_R_ind(p);
%                 sind=data.sensor{s}.segment(segind);
%                 eind=data.sensor{s}.segment(segind+1);
%                 plot_signal(data.sensor{s}.matlabtime(sind),data.sensor{s}.sample_filtered(sind)+abs(minv),'ro',5,offset);
%                 plot_signal(data.sensor{s}.matlabtime(eind),data.sensor{s}.sample_filtered(eind)+abs(minv),'ro',5,offset);
%             end
            
        elseif isfield(data.smoking_episode{e},'hand')==1 && data.smoking_episode{e}.hand=='L' && s==G.SENSOR.WL9_ACLYID
            minv=min(data.sensor{s}.sample);
            segind=data.smoking_episode{e}.puff.seg_L_ind;
            sind=data.sensor{s}.segment(segind);
            eind=data.sensor{s}.segment(segind+1);
            plot_signal(data.sensor{s}.matlabtime(sind),data.sensor{s}.sample_filtered(sind)+abs(minv),'ro',5,offset);
            plot_signal(data.sensor{s}.matlabtime(eind),data.sensor{s}.sample_filtered(eind)+abs(minv),'ro',5,offset);
            
%             for p=1:length(data.smoking_episode{e}.puff.seg_L_ind)
%                 segind=data.smoking_episode{e}.puff.seg_L_ind(p);
%                 sind=data.sensor{s}.segment(segind);
%                 eind=data.sensor{s}.segment(segind+1);
%                 plot_signal(data.sensor{s}.matlabtime(sind),data.sensor{s}.sample_filtered(sind)+abs(minv),'ro',5,offset);
%                 plot_signal(data.sensor{s}.matlabtime(eind),data.sensor{s}.sample_filtered(eind)+abs(minv),'ro',5,offset);
%             end
        end
    end
end
end

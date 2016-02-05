function plot_handmark_RIP(G,data,SENSORIDS)

ymax=0;
for s=SENSORIDS
    ymax=ymax+max(data.sensor{s}.sample)+abs(min(data.sensor{s}.sample));
end
offset=ymax;
for s=SENSORIDS
    hold on;
    offset=offset-max(data.sensor{s}.sample)-abs(min(data.sensor{s}.sample));
    if isempty(data.sensor{s}.matlabtime),        continue;    end
    if s~=G.SENSOR.R_RIPID, continue;end;
    for e=1:length(data.smoking_episode)
        minv=min(data.sensor{s}.sample);
        if isfield(data.smoking_episode{e}.puff,'peak_ind')~=1, continue;end;
        peak_ind=data.smoking_episode{e}.puff.peak_ind;
        peak_ind(peak_ind==-1)=[];
        plot_signal(data.sensor{s}.peakvalley.matlabtime(peak_ind-1),data.sensor{s}.peakvalley.sample(peak_ind-1)+abs(minv),'r','o',5,offset);
        plot_signal(data.sensor{s}.peakvalley.matlabtime(peak_ind),data.sensor{s}.peakvalley.sample(peak_ind)+abs(minv),'r','o',5,offset);
        plot_signal(data.sensor{s}.peakvalley.matlabtime(peak_ind+1),data.sensor{s}.peakvalley.sample(peak_ind+1)+abs(minv),'r','o',5,offset);
        
    end
end
end

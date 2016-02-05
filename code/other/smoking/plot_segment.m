function plot_segment(G,data,SENSORIDS)

ymax=0;
for s=SENSORIDS
    ymax=ymax+max(data.sensor{s}.sample)+abs(min(data.sensor{s}.sample));
end
offset=ymax;
for s=SENSORIDS
    hold on;
    offset=offset-max(data.sensor{s}.sample)-abs(min(data.sensor{s}.sample));
    if isempty(data.sensor{s}.matlabtime),        continue;    end
    if s==G.SENSOR.WR9_ACLYID || s==G.SENSOR.WL9_ACLYID
        minv=min(data.sensor{s}.sample);
        segment=data.sensor{s}.segment;
        plot_signal(data.sensor{s}.matlabtime(segment(1:2:end)),data.sensor{s}.sample_filtered(segment(1:2:end))+abs(minv),'bo',5,offset);
        plot_signal(data.sensor{s}.matlabtime(segment(2:2:end)),data.sensor{s}.sample_filtered(segment(2:2:end))+abs(minv),'ro',5,offset);        
    end
end
end

function plot_filtered(G,data,SENSORIDS)

ymax=0;
for s=SENSORIDS
    ymax=ymax+max(data.sensor{s}.sample)+abs(min(data.sensor{s}.sample));
end
offset=ymax;
for s=SENSORIDS
    hold on;
    offset=offset-max(data.sensor{s}.sample)-abs(min(data.sensor{s}.sample));
    if isempty(data.sensor{s}.matlabtime),        continue;    end
    if s~=G.SENSOR.R_RIPID
        minv=min(data.sensor{s}.sample);
        plot_signal(data.sensor{s}.matlabtime,data.sensor{s}.sample_filtered+abs(minv),'r','-',2,offset);
%    end
end
end

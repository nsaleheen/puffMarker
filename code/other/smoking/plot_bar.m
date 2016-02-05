function plot_bar(G,data,SENSORIDS,barvalue)

ymax=0;
for s=SENSORIDS
    ymax=ymax+max(data.sensor{s}.sample)+abs(min(data.sensor{s}.sample));
end
offset=ymax;
for s=SENSORIDS
    hold on;
    offset=offset-max(data.sensor{s}.sample)-abs(min(data.sensor{s}.sample));
    if isempty(data.sensor{s}.matlabtime),        continue;    end
    if s==G.SENSOR.R_RIPID, continue;end;
    minv=min(data.sensor{s}.sample);
    for i=1:length(barvalue)
        if barvalue(i)==0,
            plot(xlim,[barvalue(i)+abs(minv)+offset,barvalue(i)+abs(minv)+offset],'k:','linewidth',1);
        else
            plot(xlim,[barvalue(i)+abs(minv)+offset,barvalue(i)+abs(minv)+offset],'k--','linewidth',1);
        end
    end
end
end

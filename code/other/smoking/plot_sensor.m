function plot_sensor(G,data,SENSORIDS)
color={[0,0.7,0],[0,0.25,0.5],[0.8,0.4,0]};
line='-';
%color={'g-','b-','m-'};

ymax=0;
for s=SENSORIDS
    ymax=ymax+max(data.sensor{s}.sample)+abs(min(data.sensor{s}.sample));
end
offset=ymax;
i=0;
for s=SENSORIDS
    hold on;
    offset=offset-max(data.sensor{s}.sample)-abs(min(data.sensor{s}.sample));
    if isempty(data.sensor{s}.matlabtime),        continue;    end
    minv=min(data.sensor{s}.sample);
    if s==1,
        plot_signal(data.sensor{s}.matlabtime,data.sensor{s}.sample_new+abs(minv),color{rem(i,length(color))+1},line,2,offset);
    else
        if isfield(data.sensor{s},'sample_org')
            plot_signal(data.sensor{s}.matlabtime,data.sensor{s}.sample_org+abs(minv),color{rem(i,length(color))+1},line,2,offset);
        end
        plot_signal(data.sensor{s}.matlabtime,data.sensor{s}.sample+abs(minv),'c',line,2,offset);        
        
    end
    
    i=i+1;
end
end

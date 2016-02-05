function plot_orientation(G,data)

for i=[G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_ACLZID,G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_ACLZID]
    hold on;
    y=ylim;
    offset=y(1);
    plot(data.sensor{i}.matlabtime,data.sensor{i}.sample_org+offset,'b.');
    plot(data.sensor{i}.matlabtime,data.sensor{i}.sample+offset,'r.');
    
end

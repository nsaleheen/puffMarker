function  memphis_nazir_plot_acl_gyr_segments( P )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
for i=1:2
    acl_startmatlabtime = P.wrist{i}.acl.segment.startmatlabtime;
    acl_endmatlabtime = P.wrist{i}.acl.segment.endmatlabtime;
    validRP = zeros(1,length(P.wrist{i}.acl.segment.starttimestamp));
        gyr_startmatlabtime = P.wrist{i}.gyr.segment.startmatlabtime;
    gyr_endmatlabtime = P.wrist{i}.gyr.segment.endmatlabtime;
    
    for j=1:length(acl_startmatlabtime)
        plot([acl_startmatlabtime(j), acl_endmatlabtime(j)], [0, 0], '-r');
        hold on;
    end
    for j=1:length(gyr_startmatlabtime)
        plot([gyr_startmatlabtime(j), gyr_endmatlabtime(j)], [1, 1], '-g');
        hold on;
    end
    
%     plot(acl_startmatlabtime, validRP, 'r*');
%     hold on;
%     plot(acl_endmatlabtime , validRP, 'g+');
%     
%     hold on;
% 
% 
%     validRP = zeros(1,length(P.wrist{i}.gyr.segment.starttimestamp));
%     validRP=validRP+2;
%     plot(gyr_startmatlabtime , validRP, 'bo');
%     hold on;
%     plot(gyr_endmatlabtime , validRP, 'c^');
    
    
    
end

end


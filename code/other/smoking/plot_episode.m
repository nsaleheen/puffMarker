function plot_episode(G,data,SENSORIDS)
for i=1:2
    y=ylim;
    if ~isfield(data.wrist{i}.gyr.segment.svm_episode,'startmatlabtime'), continue;end;
    for j=1:length(data.wrist{i}.gyr.segment.svm_episode.startmatlabtime)
        plot([data.wrist{i}.gyr.segment.svm_episode.startmatlabtime(j),data.wrist{i}.gyr.segment.svm_episode.endmatlabtime(j)],[y(2)+100,y(2)+100],'m-','linewidth',40);
    end
end

end

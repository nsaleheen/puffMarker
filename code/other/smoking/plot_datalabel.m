function plot_datalabel(G,data)
if isfield(data,'datalabel')~=1, return;end;
count=0;
for i=1:length(data.datalabel)
    hold on;
    plot_signal([data.datalabel(i).startmatlabtime,data.datalabel(i).startmatlabtime],ylim,'r-',2);
    hold on;
    if ~isempty(strfind(data.datalabel(i).label,'Smoking'))
        count=count+1;
        text(data.datalabel(i).startmatlabtime, 0  , [data.datalabel(i).label ' : ' num2str(count)], 'Color', 'k','FontSize',18,'Rotation',90);    
    else
        text(data.datalabel(i).startmatlabtime, 0  , [data.datalabel(i).label ' : Start'], 'Color', 'k','FontSize',18,'Rotation',90);            
    end
    if data.datalabel(i).startmatlabtime~=data.datalabel(i).endmatlabtime,
        plot_signal([data.datalabel(i).endmatlabtime,data.datalabel(i).endmatlabtime],ylim,'m-',2);
    if ~isempty(strfind(data.datalabel(i).label,'Smoking'))
        text(data.datalabel(i).endmatlabtime, 0  , [data.datalabel(i).label ' : ' num2str(count)], 'Color', 'k','FontSize',18,'Rotation',90);    
    else
        text(data.datalabel(i).endmatlabtime, 0  , [data.datalabel(i).label ' : End'], 'Color', 'k','FontSize',18,'Rotation',90);            
    end
    end
end

end

function plot_selfreport_smoking(G,data)
if isfield(data,'selfreport')~=1, return;end;
list_selfreport=[G.SELFREPORT.SMKID];
ylimit=ylim;
for s=list_selfreport
    hold on;
    for i=1:length(data.selfreport{s}.matlabtime)
        hold on;
        plot([data.selfreport{s}.matlabtime(i),data.selfreport{s}.matlabtime(i)],ylimit,'r-','linewidth',2);
        hold on;
        if isfield(data.selfreport{s},'label')~=1, continue;end;
        text(data.selfreport{s}.matlabtime(i), ylimit(1)  , [data.selfreport{s}.NAME ' : ' int2str(i) '(',data.selfreport{s}.label{i} ')'], 'Color', 'k','FontSize',18,'Rotation',90);
    end
end

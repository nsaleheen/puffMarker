function plot_selfreport(G,pid,sid,INDIR,list_selfreport)

data=findfile_pid_sid_dir(G,pid,sid,INDIR);
for s=list_selfreport
    hold on;
    for i=1:length(data.selfreport{s}.matlabtime)
        hold on;
        plot([data.selfreport{s}.matlabtime(i),data.selfreport{s}.matlabtime(i)],ylim,'r-','LineWidth',2);
        hold on;
        text(data.selfreport{s}.matlabtime(i), 0  , [data.selfreport{s}.NAME ' : ' int2str(i)], 'Color', 'k','FontSize',18,'Rotation',90);
    end
end
end

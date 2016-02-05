function plot_labstudymark(G,pid,sid,INDIR)

data=findfile_pid_sid_dir(G,pid,sid,INDIR);
for l=1:length(data.labstudy_mark.eventname)
    hold on;
    plot([data.labstudy_mark.start_matlabtime(l),data.labstudy_mark.start_matlabtime(l)],ylim,'r-','LineWidth',2);
    hold on;
    text(data.labstudy_mark.start_matlabtime(l), 0  , data.labstudy_mark.eventname{l}, 'Color', 'k','FontSize',18,'Rotation',90);
end
end

function plot_ema(G,pid,sid,INDIR,context)

R=findfile_pid_sid_dir(G,pid,sid,INDIR);

for i=1:size(R.ema.data,1)
    hold on;
    if str2num(char(R.ema.data(i,3)))==context
        starttimestamp=R.ema.data(i,7);
        emaStart=str2num(char(starttimestamp));
        plot([convert_timestamp_matlabtimestamp(G,emaStart),convert_timestamp_matlabtimestamp(G,emaStart)],ylim,'k-','LineWidth',2);
        hold on;
        text(convert_timestamp_matlabtimestamp(G,emaStart), 0  , 'EMA', 'Color', 'r','FontSize',18,'Rotation',90);
    end
end

end

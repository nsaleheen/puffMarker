function smoking_lab_data_generate_plot(participant, starttimestr, endtimestr)

G=config();
G=config_run_SmokingLab(G);

pid = ['p' num2str(participant,'%02d')];
sid = 's01';

G.RUN.FRMTRAW.CRESS=1;

G.RUN.FRMTRAW.SENSORLIST_TOS=[ ...
    G.SENSOR.R_RIPID,...
    G.SENSOR.WR9_ACLYID, ...
    G.SENSOR.WR9_GYRZID, ...
    G.SENSOR.WL9_ACLYID, ...
    G.SENSOR.WL9_GYRZID ...
    ];

smoking_lab_formattedraw(G,pid,sid,'raw','formattedraw_lab', starttimestr, endtimestr);

sensorPlotList=G.RUN.FRMTRAW.SENSORLIST_TOS;
iplot4(G, participant, 1, 'formattedraw_lab', sensorPlotList, 1, (0)/(60*60*24));

end


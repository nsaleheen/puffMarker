clear all
close all
G=config();
%G=config_run_monowar_Memphis_Smoking_Lab(G);
%G=config_run_monowar_Memphis_Smoking(G);
G=config_run_MinnesotaLab(G);

PS_LIST=G.PS_LIST;
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        main_formattedraw(G,pid,sid,'raw','formattedraw');
%        read_selfreport_smokingposition(G,pid,sid,'raw','formattedraw');
        main_formatteddata(G,pid,sid,'formattedraw','formatteddata');
%        plot_custom(G,pid,sid,'formatteddata','plot_formatteddata',[G.SENSOR.R_RIPID,G.SENSOR.WR9_ACLYID,G.SENSOR.WL9_ACLYID],'bar',[-700,0,700],'smokinglabel');
    end
end

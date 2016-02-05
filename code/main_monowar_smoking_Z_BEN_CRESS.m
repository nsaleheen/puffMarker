function main_monowar_smoking_3_BEN_CRESS()
close all;
clear all
G=config();
G=config_run_monowar_Memphis_Smoking(G);
G.PS_LIST= {
{'p10'},(cellstr(strcat('s',num2str((1:3)','%02d'))))';
{'p11'},(cellstr(strcat('s',num2str((1:3)','%02d'))))';
{'p12'},(cellstr(strcat('s',num2str((1:4)','%02d'))))';
{'p14'},(cellstr(strcat('s',num2str((1:3)','%02d'))))';
{'p15'},(cellstr(strcat('s',num2str((1:3)','%02d'))))';
{'p16'},(cellstr(strcat('s',num2str((1:3)','%02d'))))';
};

PS_LIST=G.PS_LIST;
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        disp(['pid=' pid ' sid=' sid]);
%        cut_cress_data(G,pid,sid,'cress');
%        plot_cress_data(G,pid,sid,cress');
%        iplot4_monowar(G,pid,sid, 'formattedraw', [G.SENSOR.R_RIPID,G.SENSOR.WR9_ACLYID,G.SENSOR.WR9_GYRZID,G.SENSOR.WL9_ACLYID,G.SENSOR.WL9_GYRZID], 1, (0)/(60*60*24));
    end
end
end

close all
clear all
G=config();
%G=config_run_monowar_Memphis_Smoking_Lab(G);
G=config_run_monowar_Memphis_Smoking(G);
PS_LIST=G.PS_LIST;
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s\n',pid,sid);
         plot_custom(G,pid,sid,'preprocess_wrist2','plot_right_R_A_G_M',[G.SENSOR.R_RIPID,G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_GYRZID],...
             'gyrmag',[2],'smokinglabel','bar',[-600,0,600],'save',[0.5,0.5]);
         plot_custom(G,pid,sid,'preprocess_wrist2','plot_left_R_A_G_M',[G.SENSOR.R_RIPID,G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_GYRZID],...
             'gyrmag',[1],'smokinglabel','bar',[-600,0,600],'save',[0.5,0.5]);
         
    end
end
fprintf(') =>  done\n');

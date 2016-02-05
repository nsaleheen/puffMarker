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
        plot_custom(G,pid,sid,'segment','field_selfreport',[G.SENSOR.R_RIPID,G.SENSOR.WR9_ACLYID,G.SENSOR.WL9_ACLYID],...
                 'smokinglabel','gyrmag',[2,1],'segment_gyr','selfreport','save',[10,2],'bar',[0,250]);
        
    end
end
disp('abc');

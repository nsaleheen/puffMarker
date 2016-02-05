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
        load('RP.mat');
        filter_segment_all_gyr(G,pid,sid,'segment','segment',0.33,500,10000,[5,10]);        
        plot_custom(G,pid,sid,'segment','field_selfreport',[G.SENSOR.R_RIPID],...
                 'smokinglabel','acl',[2,1],'segment_gyr_acl','gyrmag',[2,1],'segment_gyr','selfreport','save',[15,2]);
        
    end
end
fprintf(') =>  done\n');

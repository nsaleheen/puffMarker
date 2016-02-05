close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);

list={
    {'p01','s02',1:3},{'p01','s03',1:4},{'p01','s04',1:3},{'p01','s05',1:3},...
    {'p02','s03',1:3},{'p02','s04',1},{'p02','s05',1},{'p02','s06',1},{'p02','s08',1:4},...
    {'p03','s01',1:3},{'p03','s02',2:3},{'p03','s03',1:2},...
    {'p04','s01',1:1}
};
for l=1:length(list)
    pid=list{l}{1};sid=list{l}{2};
    fprintf('pid=%s sid=%s\n',pid,sid);
    correct_marktime_manually(G,pid,sid,'segment');
    find_mark_acl(G,pid,sid,list{l}{3},'segment','segment');
    correct_handmarktime_manually(G,pid,sid,'segment');
    remove_missing_handmark(G,pid,sid,'segment',0.75);
    
%        plot_custom(G,pid,sid,'segment','handmark_acl',[G.SENSOR.R_RIPID,G.SENSOR.WR9_ACLXID,G.SENSOR.WR9_ACLZID],...
%            'bar',[-600,0,600],'smokinglabel','acl',[2,1],'segment_acl','handmark_acl','gyrmag',[2,1],'segment_acl_gyr','save',[0.5,0.5]);


 %   TOT=TOT+tot;MISS=MISS+miss;VALID=VALID+valid;
%        plot_custom(G,pid,sid,'preprocess','handmark_acl',[G.SENSOR.R_RIPID],...
%            'bar',[-600,0,600],'smokinglabel','acl',[2,1],'segment_acl','handmark_acl','save',[0.5,0.5],'gyrmag',[2,1]);
%        plot_custom(G,pid,sid,'preprocess','handmark_acl_gyr',[G.SENSOR.R_RIPID],...
%            'bar',[-600,0,600],'smokinglabel','acl',[2,1],'segment_acl','handmark_acl','gyrmag',[2,1],'segment_acl_gyr');
    
%        plot_custom(G,pid,sid,'preprocess','puff_figure',[G.SENSOR.WR9_ACLYID,G.SENSOR.WL9_ACLYID],...
%            'bar',[-700,0,700],'smokinglabel','gyrmag',[2,1],'handmark_GYR','save',[0,0]);
    
end
fprintf(') =>  done\n');

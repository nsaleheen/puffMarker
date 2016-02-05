close all
clear all
G=config();
%G=config_run_monowar_Memphis_Smoking_Lab(G);
G=config_run_monowar_Memphis_Smoking(G);
PS_LIST=G.PS_LIST;
for pp=1:size(PS_LIST,1)
    pid=char(PS_LIST{pp,1});
    slist=PS_LIST{pp,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s\n',pid,sid);
%        plot_custom(G,pid,sid,'svm_output','plot_svm_output',[],'smokinglabel','map',[2,1],'selfreport','svm');        
%        plot_custom(G,pid,sid,'svm_output','plot_svm_output',[],'smokinglabel','gyrmag',[2,1],'segment_gyr','map',[2,1],'selfreport','svm','save',[15,5]);
        plot_custom(G,pid,sid,'preprocess_wrist2','plot_leftright',[G.SENSOR.WR9_ACLYID,G.SENSOR.WL9_ACLYID],'smokinglabel','selfreport','bar',[-600,0,600]);

        disp('abc');
    end
end

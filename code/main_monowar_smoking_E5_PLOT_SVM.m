close all
clear all
G=config();
% G=config_run_monowar_Memphis_Smoking_Lab(G);
% G=config_run_monowar_Memphis_Smoking(G);
if strcmp(G.DATASET_NAME, 'minnesota_lab')==1
    G=config_run_MinnesotaLab(G);
elseif strcmp(G.DATASET_NAME, 'memphis_lab')==1
    G=config_run_monowar_Memphis_Smoking_Lab(G);
elseif strcmp( G.DATASET_NAME, 'memphis_field')==1
    G=config_run_monowar_Memphis_Smoking(G);
end

PS_LIST=G.PS_LIST;
for pp=1:size(PS_LIST,1)
    pid=char(PS_LIST{pp,1});
    slist=PS_LIST{pp,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s\n',pid,sid);
%        plot_custom(G,pid,sid,'svm_output','plot_svm_output',[],'smokinglabel','map',[2,1],'selfreport','svm');        
%        plot_custom(G,pid,sid,'svm_output','plot_svm_output',[],'smokinglabel','gyrmag',[2,1],'segment_gyr','map',[2,1],'selfreport','svm','save',[15,5]);

%plot_custom(G,pid,sid,'svm_output','plot_svm_output_episode',[],'smokinglabel','gyrmag',[2,1],'segment_gyr','map',[2,1],'selfreport','svm','episode');
plot_custom(G,pid,sid,'svm_output_prequit','plot_svm_output',[],'smokinglabel','gyrmag',[2,1],'segment_gyr','map',[2,1],'selfreport','svm');

        disp('abc');
    end
end

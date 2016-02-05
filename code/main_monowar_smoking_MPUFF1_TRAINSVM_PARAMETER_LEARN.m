function main_monowar_smoking_MPUFF1_TRAINSVM_PARAMETER_LEARN()
close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
G=main_monowar_smoking_E0_CONFIG_SVM(G);
%SVM_RBF_parameter_learn(G,G.SVM.RIP_MPUFF_ROC_WRIST_MRP_TIME.NAME);
SVM_RBF_parameter_learn(G,G.SVM.HN_RIP_SELECTED_WRIST_SELECTED.NAME);
end


function SVM_RBF_parameter_learn(G,fname)
wekafile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP 'weka_train_new.arff'];
outfile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP 'weka_train_new_output.txt'];
modelfile=[G.DIR.ROOT G.DIR.SEP 'weka' G.DIR.SEP 'weka_train_new_model.model'];
parameterfile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP 'weka_train_new_parameter.csv'];

max_detail=-inf;
id=fopen(parameterfile,'w');
for c=pow2(-10):pow2(0.5):pow2(5)
    for g=pow2(-10):pow2(.5):pow2(5)
        weka_train_SMO_PARAMETER_smoking(wekafile,modelfile,outfile,c,g);
        [result,acc,kappa,detail,conf]=get_weka_results_smoking_parts(outfile);
        if isempty(result), continue;end;
        if acc>max_detail, max_detail=acc;C=c;G=g;end
        fprintf(id,'%f,%f,%f,%f,%d,%d,%d,%d',c,g,acc,kappa,conf(1,1),conf(1,2),conf(2,1),conf(2,2));
        for i=1:3, for j=1:6, fprintf(id,',%f',detail(i,j));end;end;
        fprintf(id,'\n');
        fprintf('(%f,%f,%f) : (%f,%f,%f)\n',c,g,acc,C,G,max_detail);
    end
end
fclose(id);
end

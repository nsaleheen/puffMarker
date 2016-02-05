function main_monowar_smoking_E1_TRAINSVM_PARAMETER_LEARN()
close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
SVM_RBF_parameter_learn(G,'rip_mpuff_roc_wrist_mrp_time');
end
function SVM_RBF_parameter_learn(G,fname)
wekafile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP 'train_' fname '.arff'];
outfile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP 'train_' fname '_output.txt'];
modelfile=[G.DIR.ROOT G.DIR.SEP 'weka' G.DIR.SEP 'train_' fname '_model.model'];
parameterfile=[G.DIR.ROOT G.DIR.SEP 'weka' G.DIR.SEP 'train_' fname '_parameter.csv'];

max_detail=-inf;
id=fopen(parameterfile,'w');
for c=1:0.1:10
    for g=1:0.1:10
        weka_train_SMO_PARAMETER_smoking(wekafile,modelfile,outfile,c,g);
        [result,acc,kappa,detail,conf]=get_weka_results_smoking_parts(outfile);
        if isempty(result), continue;end;
        if detail(1,1)>max_detail, max_detail=detail(1,1);C=c;G=g;end
        fprintf(id,'%f,%f,%f,%f,%d,%d,%d,%d',c,g,acc,kappa,conf(1,1),conf(1,2),conf(2,1),conf(2,2));
        for i=1:3, for j=1:6, fprintf(id,',%f',detail(i,j));end;end;
        fprintf(id,'\n');
        fprintf('(%f,%f,%f) : (%f,%f,%f)\n',c,g,detail(1,1),C,G,max_detail);
        
    end
end
fclose(id);
end

close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
%G=config_run_monowar_Memphis_Smoking(G);
for i=1:2
    outfile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP '_train_all_test_' num2str(i) '_output.txt'];
    modelfile=[G.DIR.ROOT G.DIR.SEP 'weka' G.DIR.SEP '_train_all_' num2str(i) '_model.model'];
    wekafile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP '_train_all_' num2str(i) '.arff'];

    TestSVM_smoking(modelfile,wekafile,outfile);
    [actual,predict,prob]=TestSVM_parse_results_smoking(outfile);
    A=zeros(1,length(actual));P=zeros(1,length(predict));
    A(strcmp(actual(:),'puff')==1)=1;
    P(strcmp(predict(:),'puff')==1)=1;
    x=find(P==0);
    prob(x)=1-prob(x);
    TH=0.03;
    TP=length(find(A==1 & prob>TH));
    TN=length(find(A==0 & prob<=TH));
    FP=length(find(A==0 & prob>TH));
    FN=length(find(A==1 & prob<=TH));

%    TP=length(find(A==1 & P==1));TN=length(find(A==0 & P==0));
%    FP=length(find(A==0 & P==1));FN=length(find(A==1 & P==0));
    fprintf('%d %d\n',TP,FN);
    fprintf('%d %d\n',FP,TN);
    fprintf('%f\n',(TP+TN)/(TP+TN+FP+FN));
end

function main_monowar_smoking_E3F2_TRAIN_THRESHOLD_ROC()
close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
G=main_monowar_smoking_E0_CONFIG_SVM(G);
%MODEL=G.SVM.RIP_MPUFF_ROC_WRIST_MRP_TIME;

%[FPRR5,TPRR5]=SVM_RBF_train(G,G.SVM.HN_RIP_SELECTED_WRIST_SELECTED.NAME,G.SVM.HN_RIP_SELECTED_WRIST_SELECTED.C,G.SVM.HN_RIP_SELECTED_WRIST_SELECTED.G);

[FPRR4,TPRR4,F]=SVM_RBF_train(G,G.SVM.RIP_MPUFF_ROC_WRIST_MRP_TIME.NAME,G.SVM.RIP_MPUFF_ROC_WRIST_MRP_TIME.C,G.SVM.RIP_MPUFF_ROC_WRIST_MRP_TIME.G);
[FPRR1,TPRR1,F]=SVM_RBF_train(G,G.SVM.RIP_MPUFF_ROC.NAME,G.SVM.RIP_MPUFF_ROC.C,G.SVM.RIP_MPUFF_ROC.G);
[FPRR2,TPRR2,F]=SVM_RBF_train(G,G.SVM.WRIST_MRP.NAME,G.SVM.WRIST_MRP.C,G.SVM.WRIST_MRP.G);
%[FPRR3,TPRR3,F]=SVM_RBF_train(G,G.SVM.H_RIP_SELECTED_WRIST_SELECTED.NAME,G.SVM.H_RIP_SELECTED_WRIST_SELECTED.C,G.SVM.H_RIP_SELECTED_WRIST_SELECTED.G);
figure;hold on;
F=40;
plot(FPRR1/F,TPRR1,'g-','linewidth',2);
plot(FPRR2/F,TPRR2,'b-','linewidth',2);
%plot(FPRR3/F,TPRR3,'k-','linewidth',2);
plot(FPRR4/F,TPRR4,'r-','linewidth',2);
%plot(FPRR5/F,TPRR5,'c-','linewidth',2);

%xlim([0.0 0.3]);
%ylim([0.7 1]);
xlabel('False Positive(per Hour)');
ylabel('True Positive Rate');
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold');
set(gca,'FontSize',16,'fontWeight','bold');
leg={'Respiration','Wrist','Respiration+Wrist'};
legend(leg,'location','southeast');
xlim([0,40]);
disp('abc');
filename=['C:\Users\smh\Desktop\smoking_fig' G.DIR.SEP  'rip_wrist_feature_ROC'];
print('-dpng','-r100',[filename '.png']);
print('-depsc',[filename '.eps']);
end


function [FPRR,TPRR,F]=SVM_RBF_train(G,fname,C,GAMMA)
wekafile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP 'train_' fname '.arff'];
outfile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP 'train_' fname '_output.txt'];
modelfile=[G.DIR.ROOT G.DIR.SEP 'weka' G.DIR.SEP 'train_' fname '_model.model'];
thresholdfile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP 'train_' fname '_threshold.csv'];
weka_train_SMO_smoking(wekafile,modelfile,outfile);
%weka_train_SMO_PARAMETER_smoking(wekafile,modelfile,outfile,C,GAMMA);

id=fopen(thresholdfile,'w');
TestSVM_smoking(modelfile,wekafile,outfile);
%Test_SMO_RBF_smoking(modelfile,wekafile,outfile);
[actual,predict,prob]=TestSVM_parse_results_smoking(outfile);
A=zeros(1,length(actual));P=zeros(1,length(predict));
A(strcmp(actual(:),'puff')==1)=1;
P(strcmp(predict(:),'puff')==1)=1;
F=length(find(A==0));
x=find(P==0);
prob(x)=1-prob(x);
TPRR=[];
FPRR=[];
THH=[];
for TH=0.001:0.001:1
    TP=length(find(A==1 & prob>=TH));
    TN=length(find(A==0 & prob<TH));
    FP=length(find(A==0 & prob>=TH));
    FN=length(find(A==1 & prob<TH));
    ACC=(TP+TN)/(TP+TN+FP+FN);
    TPR=TP/(TP+FN);
    FPR=FP;%FP/(FP+TN);
    PRC=TP/(TP+FP);
    fprintf(id,'%f,%f,%f,%f,%f,%f,%f,%f,%f\n',TH,TP,FN,FP,TN,ACC,TPR,FPR,PRC);
%    fprintf('%f,%f,%f,%f,%f,%f,%f,%f,%f\n',TH,TP,FN,FP,TN,ACC,TPR,FPR,PRC);

    TPRR(end+1)=TPR;
    FPRR(end+1)=FPR;
    THH(end+1)=TH;
end
fclose(id);
%figure;plot(FPRR,TPRR);
%disp('abc');
end

function main_monowar_smoking_MPUFF2_TRAIN_THRESHOLD_ROC()
a=csvread('C:\Users\smh\Desktop\mpuff_66.arff');
figure;hold on;
plot(a(:,6),a(:,7),'k-','linewidth',2);

%xlim([0.0 0.3]);
%ylim([0.7 1]);
xlabel('False Positive Rate');
ylabel('True Positive Rate');
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold');
set(gca,'FontSize',16,'fontWeight','bold');
filename=['C:\Users\smh\Desktop\mpuff_66'];
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

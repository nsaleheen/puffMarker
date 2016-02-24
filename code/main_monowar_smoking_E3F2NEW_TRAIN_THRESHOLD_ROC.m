function main_monowar_smoking_E3F2_TRAIN_THRESHOLD_ROC()
close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
G=main_monowar_smoking_E0_CONFIG_SVM(G);
%MODEL=G.SVM.RIP_MPUFF_ROC_WRIST_MRP_TIME;

%[FPRR5,TPRR5]=SVM_RBF_train(G,G.SVM.HN_RIP_SELECTED_WRIST_SELECTED.NAME,G.SVM.HN_RIP_SELECTED_WRIST_SELECTED.C,G.SVM.HN_RIP_SELECTED_WRIST_SELECTED.G);
load('T.mat'); load('TRIP.mat');
[FPRR4,TPRR4,F]=SVM_RBF_train(G,G.SVM.RIP_MPUFF_ROC_WRIST_MRP_TIME.NAME,G.SVM.RIP_MPUFF_ROC_WRIST_MRP_TIME.C,G.SVM.RIP_MPUFF_ROC_WRIST_MRP_TIME.G,T);
[FPRR2,TPRR2,F]=SVM_RBF_train(G,G.SVM.WRIST_MRP.NAME,G.SVM.WRIST_MRP.C,G.SVM.WRIST_MRP.G,T);
  [FPRR1,TPRR1,F]=SVM_RBF_train(G,G.SVM.RIP_MPUFF_ROC.NAME,G.SVM.RIP_MPUFF_ROC.C,G.SVM.RIP_MPUFF_ROC.G,TRIP);
%[FPRR3,TPRR3,F]=SVM_RBF_train(G,G.SVM.H_RIP_SELECTED_WRIST_SELECTED.NAME,G.SVM.H_RIP_SELECTED_WRIST_SELECTED.C,G.SVM.H_RIP_SELECTED_WRIST_SELECTED.G);
RES.WR.FPRR=FPRR4;
RES.WR.TPRR=TPRR4;
RES.W.FPRR=FPRR2;
RES.W.TPRR=TPRR2;
 RES.R.FPRR=FPRR1;
 RES.R.TPRR=TPRR1;
figure;hold on;
F=1;
% semilogx(FPRR4/F,TPRR4);
% loglog(FPRR4/F,TPRR4,'r-','linewidth',2);
% plot(log10(FPRR1/F),TPRR1,'g-','linewidth',2);
% plot(log10(FPRR2/F),TPRR2,'b-','linewidth',2);
% plot(log10(FPRR4/F),TPRR4,'r-','linewidth',2);

plot(FPRR1/F,TPRR1,'g-','linewidth',2);
plot(FPRR2/F,TPRR2,'b-','linewidth',2);
plot(FPRR4/F,TPRR4,'r-','linewidth',2);
grid on;
% set(gca,'xticklabel','.002|.01|.03|.1|.5|1');
%xlim([0.0 0.3]);
%ylim([0.7 1]);
xlabel('False Positive Rate');
ylabel('True Positive Rate');
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold');

% % set(gca,'XScale','log');
% set(gca,'Xtick',-4:0); %// adjust manually; values in log scale
% set(gca,'Xticklabel',10.^get(gca,'Xtick'));

set(gca,'FontSize',16,'fontWeight','bold');
leg={'Respiration','Wrist','Respiration+Wrist'};
legend(leg,'location','southeast');
 xlim([0,0.15]);
disp('abc');
filename=['D:\smoking_memphis\data\Memphis_Smoking_Lab\smoking_fig' G.DIR.SEP  'roc_15n'];
print('-dpng','-r100',[filename '.png']);
print('-depsc',[filename '.eps']);
 save('RES_POST.mat', 'RES');
end


function [FPRR,TPRR,F]=SVM_RBF_train(G,fname,C,GAMMA,T)
wekafile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP 'train_' fname '.arff'];
outfile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP 'train_' fname '_output.txt'];
modelfile=[G.DIR.ROOT G.DIR.SEP 'weka' G.DIR.SEP 'train_' fname '_model.model'];
thresholdfile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP 'post_train_' fname '_threshold.csv'];
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
T.actual=A;
T.prob=prob;
%T.actual=actual;
%T.prob=prob;
MatlabTime=T.rstime;
fprintf('A:%d, time: %d\n', length(A), length(MatlabTime));
TPRR=[];
FPRR=[];
THH=[];
for TH=0.001:0.001:1
%     TP=length(find(A==1 & prob>=TH));
%     TN=length(find(A==0 & prob<TH));
%     FP=length(find(A==0 & prob>=TH));
%     FN=length(find(A==1 & prob<TH));
    
      TN=0;
    TP=0;
    FN=0;
    FP=0;
     actual=A;
                probability=prob;

                  predict = zeros(1, length(actual));
                   for l=1:length(actual)
                       if probability(l) >= TH
                           predict(l)=1;
                       end
                   end
                   smatlabtimes = MatlabTime;
                   p1pre=length(find(predict==1));
                   
                     predict=post_process(actual, predict, smatlabtimes);
                   
                   a0=length(find(actual==0));
                   p0=length(find(predict==0));
                   a1=length(find(actual==1));
                   p1=length(find(predict==1));
%                     fprintf('%d %d p0=%d p1=%d p1pre=%d\n', a0, a1, p0, p1, p1pre);
                   if a0 >0
                        TN=length(find(actual==0 & predict==0));
                        FP=length(find(actual==0 & predict==1));
                    end
                    if a1>0
                        TP=length(find(actual==1 & predict==1));    
                        FN=length(find(actual==1 & predict==0));
                    end       
    
    ACC=(TP+TN)/(TP+TN+FP+FN);
    TPR=TP/(TP+FN);
    FPR=FP/(FP+TN);
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


function predict=post_process(actual, predict, smatlabtimes)

    inds=find(predict==1);
    len=length(inds);
    dist=240;
    if len>1
        diff=(smatlabtimes(inds(2)) - smatlabtimes(inds(1)))/1000;
        if diff > dist
            predict(inds(1))=0;
        end
    
        diff=(smatlabtimes(inds(len)) - smatlabtimes(inds(len-1)))/1000;
        if diff > dist
            predict(inds(len))=0;
        end
    elseif len>0
            predict(inds(1))=0;
    end
    for j=2:length(inds)-1
        diff1=(smatlabtimes(inds(j)) - smatlabtimes(inds(j-1)))/1000;
        diff2=(smatlabtimes(inds(j+1)) - smatlabtimes(inds(j)))/1000;
        if diff1 > dist & diff2 > dist
            predict(inds(j))=0;
        end
    end

end
close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
%G=config_run_monowar_Memphis_Smoking(G);

G=main_monowar_smoking_E0_CONFIG_SVM(G);
%MODEL=G.SVM.RIP_MPUFF_ROC_WRIST_MRP_TIME;
MODEL=G.SVM.MODEL;
PS_LIST=G.PS_LIST;
SVM_A.actual=[];SVM_A.predict=[];SVM_A.probability=[];
nonepisode_len=0;
episode_len=0;
total_len=0;
for pp=1:size(PS_LIST,1)
    pid=char(PS_LIST{pp,1});
    slist=PS_LIST{pp,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s\n',pid,sid);
        for i=1:2
            SVM{i}.actual=[];
            SVM{i}.predict=[];
            SVM{i}.probability=[];
            SVM{i}.peakind=[];
        end
        
        INDIR='svm_output';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
        
        for i=1:2
            ind=find(P.wrist{i}.gyr.segment.valid_all==0 & P.wrist{i}.gyr.segment.puff==1 & P.wrist{i}.gyr.segment.episode~=0 & P.wrist{i}.gyr.segment.svm_actual==1);
            p_peakind=P.wrist{i}.gyr.segment.peak_ind(ind);
            SVM{i}.actual=[SVM{i}.actual P.wrist{i}.gyr.segment.puff(ind)];
            SVM{i}.predict=[SVM{i}.predict P.wrist{i}.gyr.segment.svm_predict(ind)];
            SVM{i}.probability=[SVM{i}.probability P.wrist{i}.gyr.segment.svm_probability(ind)];
            SVM{i}.peakind=[SVM{i}.peakind ind];
            
            ind=find(P.wrist{i}.gyr.segment.valid_all==0 & P.wrist{i}.gyr.segment.puff==0 & P.wrist{i}.gyr.segment.episode==0);
            np_peakind=P.wrist{i}.gyr.segment.peak_ind(ind);
            SVM{i}.actual=[SVM{i}.actual P.wrist{i}.gyr.segment.puff(ind)];
            SVM{i}.predict=[SVM{i}.predict P.wrist{i}.gyr.segment.svm_predict(ind)];
            SVM{i}.probability=[SVM{i}.probability P.wrist{i}.gyr.segment.svm_probability(ind)];
            SVM{i}.peakind=[SVM{i}.peakind ind];
%            fprintf('%d ',length(SVM{i}.peakind)-length(unique(SVM{i}.peakind)));
        end
        fprintf('%d %d ',length(find(SVM{1}.actual==1)),length(find(SVM{2}.actual==1)));
        [ind,il,ir]=intersect(SVM{1}.peakind,SVM{2}.peakind);
        who{1}=[];who{2}=[];
        for i=1:length(il)
            if SVM{1}.actual(il(i))==1, who{2}=ir(i); elseif SVM{2}.actual(ir(i))==1, who{1}=il(i);
            elseif SVM{1}.probability(il(i))<SVM{2}.probability(ir(i))
                who{1}=il(i);
            else
                who{2}=ir(i);
            end
        end
        SVM{1}.actual(who{1})=[];SVM{1}.predict(who{1})=[];SVM{1}.probability(who{1})=[];SVM{1}.peakind(who{1})=[];
        SVM{2}.actual(who{2})=[];SVM{2}.predict(who{2})=[];SVM{2}.probability(who{2})=[];SVM{2}.peakind(who{2})=[];
        fprintf('%d %d ',length(find(SVM{1}.actual==1)),length(find(SVM{2}.actual==1)));
        SVM_A.actual=[SVM_A.actual SVM{1}.actual, SVM{2}.actual];
        SVM_A.probability=[SVM_A.probability SVM{1}.probability, SVM{2}.probability];
        fprintf('              %d',length(find(SVM_A.actual==1)));
    end
    
end
disp('here');
A=SVM_A.actual;prob=SVM_A.probability;
Total_Len=2433.83;Episode_Len=232.12;
id=fopen([G.DIR.DATA '/weka/' G.SVM.MODEL.NAME '_threshold_new.csv'],'w');
TPRR=[];FPRR=[];THH=[];

for TH=0.001:0.001:1
    TP=length(find(A==1 & prob>=TH));
    TN=length(find(A==0 & prob<TH));
    FP=length(find(A==0 & prob>=TH));
    FN=length(find(A==1 & prob<TH));
    ACC=(TP+TN)/(TP+TN+FP+FN);
    TPR=TP/(TP+FN);
    FPR=FP/((Total_Len-Episode_Len)/60);%FP/(FP+TN);
    PRC=TP/(TP+FP);
    fprintf(id,'%f,%f,%f,%f,%f,%f,%f,%f,%f\n',TH,TP,FN,FP,TN,ACC,TPR,FPR,PRC); 
%    fprintf('%f,%f,%f,%f,%f,%f,%f,%f,%f\n',TH,TP,FN,FP,TN,ACC,TPR,FPR,PRC);

    TPRR(end+1)=TPR;
    FPRR(end+1)=FPR;
    THH(end+1)=TH;
end
fclose(id);
RC.FPRR=FPRR;RC.TPRR=TPRR;
save([G.SVM.MODEL.NAME '.mat'],'RC');
%plot(FPRR,TPRR,'g-','linewidth',2);
return;
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


function main_monowar_smoking_E4_TRAIN_LEAVE_ONE_OUT()
close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
G=main_monowar_smoking_E0_CONFIG_SVM(G);

PS_LIST=G.PS_LIST;
T.feature=[];
T.puff=[];T.missing=[];T.missing_rip=[];T.missing_wrist=[];
T.episode=[];T.pid=[];
for pp=1:size(PS_LIST,1)
    pid=char(PS_LIST{pp,1});
    ppid=str2num(pid(2:end));
    slist=PS_LIST{pp,2};
    all_len(ppid)=0;episode_len(ppid)=0;
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s\n',pid,sid);
        INDIR='basicfeature';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
        max_len=0;
        for ids=[G.SENSOR.R_RIPID,G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_GYRZID,G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_GYRZID]
            len=length(B.sensor{ids}.sample)/G.SENSOR.ID(ids).FREQ;
            if len>max_len, max_len=len;end
        end
        all_len(ppid)=all_len(ppid)+max_len;
        for e=1:length(B.smoking_episode)
            if isfield(B.smoking_episode{e},'puff')==0, continue;end
            if isempty(B.smoking_episode{e}.puff), continue;end;
            episode_len(ppid)=episode_len(ppid)+(B.smoking_episode{e}.endtimestamp-B.smoking_episode{e}.starttimestamp)/1000;
        end
        INDIR='feature';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
        
        for i=1:2
            inde=find(F{i}.puff==1 | (F{i}.episode==0 & F{i}.puff==0));
            T.feature=[T.feature;F{i}.feature(inde,:)];
            T.puff=[T.puff;F{i}.puff(inde)'];
            T.missing=[T.missing;F{i}.missing(inde)'];
            T.missing_rip=[T.missing_rip;F{i}.rip.missing(inde)'];
            T.missing_wrist=[T.missing_wrist;F{i}.wrist.missing(inde)'];
            T.episode=[T.episode;F{i}.episode(inde)'];
            T.pid=[T.pid;ones(length(inde),1)*ppid];
        end
        %        OUTDIR='feature';outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];outfile=[pid '_' sid '_' OUTDIR '.mat'];if isempty(dir(outdir)),   mkdir(outdir);end, save([outdir G.DIR.SEP outfile],'F');
    end
end
for pp=1:size(PS_LIST,1)
    pid=char(PS_LIST{pp,1});
    ppid=str2num(pid(2:end));
    ts_ind=find(T.pid==ppid);
    tr_ind=find(T.pid~=ppid);
    TS.feature=T.feature(ts_ind,:);TR.feature=T.feature(tr_ind,:);
    TS.puff=T.puff(ts_ind,:);TR.puff=T.puff(tr_ind,:);
    TS.missing=T.missing(ts_ind,:);TR.missing=T.missing(tr_ind,:);
    TS.missing_rip=T.missing_rip(ts_ind,:);TR.missing_rip=T.missing_rip(tr_ind,:);
    TS.missing_wrist=T.missing_wrist(ts_ind,:);TR.missing_wrist=T.missing_wrist(tr_ind,:);
    TS.episode=T.episode(ts_ind,:);TR.episode=T.episode(tr_ind,:);
    TS.pid=T.pid(ts_ind,:);TR.pid=T.pid(tr_ind,:);
    fname=[G.SVM.RIP_MPUFF_ROC_WRIST_MRP_TIME.NAME '_' num2str(ppid)];
    [A,P,prob]=train_weka_SVM(G,G.SVM.RIP_MPUFF_ROC_WRIST_MRP_TIME.IND,F,TR,fname);
    TPRR=[];FPRR=[];THH=[];
    for TH=0.001:0.001:1
        TP=length(find(A==1 & prob>=TH));
        TN=length(find(A==0 & prob<TH));
        FP=length(find(A==0 & prob>=TH));
        FN=length(find(A==1 & prob<TH));
        ACC=(TP+TN)/(TP+TN+FP+FN);
        TPR=TP/(TP+FN);
        FPR=FP/(FP+TN);
        PRC=TP/(TP+FP);
        %        fprintf(id,'%f,%f,%f,%f,%f,%f,%f,%f,%f\n',TH,TP,FN,FP,TN,ACC,TPR,FPR,PRC);
        TPRR(end+1)=TPR;
        FPRR(end+1)=FPR;
        THH(end+1)=TH;
    end
    ind=find(TPRR>=0.98);
    [x,y]=min(FPRR(ind));
    TH=THH(ind(y));
    [TPR_final(ppid),FPR_final(ppid)]=test_weka_SVM(G,G.SVM.RIP_MPUFF_ROC_WRIST_MRP_TIME.IND,F,TS,fname,TH,all_len(ppid)-episode_len(ppid));
end
figure;hold on;
bar([TPR_final',FPR_final']);
xlabel('Participant');
%ylabel('True Positive Rate');
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold');
set(gca,'FontSize',16,'fontWeight','bold');
leg={'True Positive Rate','False Positive (per hour)'};
legend(leg);

end

function [TPR,FPR]=test_weka_SVM(G,indf,F,T,fname,TH,nonepisode_len)
wekafile=[G.DIR.DATA G.DIR.SEP 'weka_loo' G.DIR.SEP 'test_' fname '.arff'];
outfile=[G.DIR.DATA G.DIR.SEP 'weka_loo' G.DIR.SEP 'test_' fname '_output.txt'];
modelfile=[G.DIR.DATA G.DIR.SEP 'weka_loo' G.DIR.SEP 'train_' fname '_model.model'];
ind=find(T.missing<=0.33);C=T.feature(ind,indf);C(isnan(C))=0;C(find(C==-Inf))=0;C(find(C==Inf))=0;
feature_names=F{2}.featurename(indf);feature_names=strrep(feature_names,' ','_');feature_names=strrep(feature_names,'(','_');feature_names=strrep(feature_names,')','_');
label_name={'puff','nonpuff'};
pind=find(T.puff(ind)==0);[labels{pind}]=deal('nonpuff');pind=find(T.puff(ind)==1);[labels{pind}]=deal('puff');
write_arff_smoking(wekafile,feature_names,label_name,C,labels);
TestSVM_smoking(modelfile,wekafile,outfile);
[actual,predict,prob]=TestSVM_parse_results_smoking(outfile);
A=zeros(1,length(actual))-1;P=zeros(1,length(predict));
A(strcmp(actual(:),'puff')==1)=1;A(strcmp(actual(:),'nonpuff')==1)=0;
P(strcmp(predict(:),'puff')==1)=1;
x=find(P==0);
prob(x)=1-prob(x);
TP=length(find(A==1 & prob>=TH));
TN=length(find(A==0 & prob<TH));
FP=length(find(A==0 & prob>=TH));
FN=length(find(A==1 & prob<TH));
TPR=TP/(TP+FN);
FPR=FP/(nonepisode_len/(60*60));%(FP+TN);
fprintf('name=%s TPR=%.2f FPR=%.2f\n',fname,TPR,FPR);
end
function [A,P,prob]=train_weka_SVM(G,indf,F,T,fname)
wekafile=[G.DIR.DATA G.DIR.SEP 'weka_loo' G.DIR.SEP 'train_' fname '.arff'];
outfile=[G.DIR.DATA G.DIR.SEP 'weka_loo' G.DIR.SEP 'train_' fname '_output.txt'];
modelfile=[G.DIR.DATA G.DIR.SEP 'weka_loo' G.DIR.SEP 'train_' fname '_model.model'];
ind=find(T.missing<=0.33);C=T.feature(ind,indf);C(isnan(C))=0;C(find(C==-Inf))=0;C(find(C==Inf))=0;

feature_names=F{2}.featurename(indf);feature_names=strrep(feature_names,' ','_');feature_names=strrep(feature_names,'(','_');feature_names=strrep(feature_names,')','_');
label_name={'puff','nonpuff'};
pind=find(T.puff(ind)==0);[labels{pind}]=deal('nonpuff');pind=find(T.puff(ind)==1);[labels{pind}]=deal('puff');
write_arff_smoking(wekafile,feature_names,label_name,C,labels);
weka_train_SMO_smoking(wekafile,modelfile,outfile);
TestSVM_smoking(modelfile,wekafile,outfile);
[actual,predict,prob]=TestSVM_parse_results_smoking(outfile);
A=zeros(1,length(actual))-1;P=zeros(1,length(predict));
A(strcmp(actual(:),'puff')==1)=1;A(strcmp(actual(:),'nonpuff')==1)=0;
P(strcmp(predict(:),'puff')==1)=1;
x=find(P==0);
prob(x)=1-prob(x);
end

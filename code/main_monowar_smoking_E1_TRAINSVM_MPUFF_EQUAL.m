function main_monowar_smoking_E1_TRAINSVM_MPUFF_EQUAL()
close all
clear all
G=config();
G=main_monowar_smoking_E0_CONFIG_SVM(G);
G=config_run_monowar_Memphis_Smoking_Lab(G);

PS_LIST=G.PS_LIST;
T.feature=[];
T.puff=[];T.missing=[];T.missing_rip=[];T.missing_wrist=[];
T.episode=[];
for pp=1:size(PS_LIST,1)
    pid=char(PS_LIST{pp,1});
    slist=PS_LIST{pp,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s\n',pid,sid);
        INDIR='feature';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
        for i=1:2
            inde=find(F{i}.puff==1 | (F{i}.episode==0 & F{i}.puff==0));
            T.feature=[T.feature;F{i}.feature(inde,:)];
            T.puff=[T.puff;F{i}.puff(inde)'];
            T.missing=[T.missing;F{i}.missing(inde)'];
            T.missing_rip=[T.missing_rip;F{i}.rip.missing(inde)'];
            T.missing_wrist=[T.missing_wrist;F{i}.wrist.missing(inde)'];
            T.episode=[T.episode;F{i}.episode(inde)'];
        end
        %        OUTDIR='feature';outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];outfile=[pid '_' sid '_' OUTDIR '.mat'];if isempty(dir(outdir)),   mkdir(outdir);end, save([outdir G.DIR.SEP outfile],'F');
    end
end
%RISP_MPUFF=[1:7, 10:12,14,19:21,23,29,32];
%RISP_MPUFF_ROC=[1:7, 10:12,14,19:21,23,29,32,8,9];
runSVM(G,F,T,'mpuff');
%runSVM(G,RISP_MPUFF_ROC,F,T,'mpuff');
end

function runSVM(G,F,T,fname)
RISP_MPUFF=G.SVM.RIP_MPUFF.IND;%[1:7, 10:12,14,19:21,23,29,32];
RISP_MPUFF_ROC=G.SVM.RIP_MPUFF_ROC.IND;%[1:7, 10:12,14,19:21,23,29,32,8,9];

ind=find(T.missing<=0.33);
C=T.feature(ind,:);
C(isnan(C))=0;
C(find(C==-Inf))=0;
C(find(C==Inf))=0;

feature_names=F{2}.featurename;feature_names=strrep(feature_names,' ','_');feature_names=strrep(feature_names,'(','_');feature_names=strrep(feature_names,')','_');
label_name={'puff','nonpuff'};
for round=1:50
    pind=find(T.puff(ind)==1);N=length(pind);
    CC=C(pind,:);
    clear labels;[labels{1:N}]=deal('puff');
    
    pind=find(T.puff(ind)==0);
    seq=randperm(length(pind));npind=seq(1:N);
    CC=[CC;C(npind,:)];[labels{N+1:N+N}]=deal('nonpuff');
    
    wekafile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP 'train_' fname '.arff'];
    outfile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP 'train_' fname '_output.txt'];
    modelfile=[G.DIR.ROOT G.DIR.SEP 'weka' G.DIR.SEP 'train_' fname '_model.model'];
    
    write_arff_smoking(wekafile,feature_names(RISP_MPUFF),label_name,CC(:,RISP_MPUFF),labels);
%    weka_train_SMO_PARAMETER_smoking(wekafile,modelfile,outfile,4.0,5.6);
    weka_train_SMO_smoking(wekafile,modelfile,outfile);
    [result,acc,kappa,detail,conf]=get_weka_results_smoking_parts(outfile);
    fprintf('%f\n',acc);
    if acc<84, continue;end;
    %result=get_weka_results_smoking(outfile);
    fprintf('----------------hand --------------------\n');
    for r=1:length(result),fprintf('%s\n',result{r});end

    wekafile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP 'train_' fname 'ROC.arff'];
    outfile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP 'train_' fname 'ROC_output.txt'];
    modelfile=[G.DIR.ROOT G.DIR.SEP 'weka' G.DIR.SEP 'train_' fname 'ROC_model.model'];
    
    write_arff_smoking(wekafile,feature_names(RISP_MPUFF_ROC),label_name,CC(:,RISP_MPUFF_ROC),labels);
    weka_train_SMO_smoking(wekafile,modelfile,outfile);
    result=get_weka_results_smoking(outfile);
    fprintf('----------------hand --------------------\n');
    for r=1:length(result),fprintf('%s\n',result{r});end
    
    %    weka_train_SMO_smoking(wekafile,modelfile,outfile);
end
end

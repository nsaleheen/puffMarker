function main_monowar_smoking_E1_TRAINSVM_ONE()
close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
%G=config_run_monowar_Memphis_Smoking(G);
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
% RIP_RAW=1:15;
% RIP_DIST=16:30;
% RIP_RATIO=31:45;
% WRIST=46:70;
% TIME=71:75;
RISP_MPUFF=[1:7, 10:12,14,19:21,23,29,32];
RISP_MPUFF_ROC=[1:7, 10:12,14,19:21,23,29,32,8,9];
RISP_ALL=1:36*3;
RISP_RAW=1:36;
RISP_DISP=36+1:36*2;
RISP_RATIO=36*2+1:36*3;
RISP_SELECTED=[6,8,14,15,23,24,39,42,45,50,51,53,54,60,63,79,100,105,108];
WRIST_ALL=109:133;
WRIST_MRP=109:121;

RIPWRIST_GOOD=[RISP_MPUFF_ROC, WRIST_MRP,134:138];
RIPWRIST_ALL=[RISP_MPUFF_ROC, WRIST_ALL,134:138];

runSVM(G,RISP_MPUFF,F,T,'mpuff');
runSVM(G,RISP_MPUFF_ROC,F,T,'mpuff_roc');
runSVM(G,RISP_ALL,F,T,'risp_all');
runSVM(G,RISP_RAW,F,T,'risp_raw');
runSVM(G,RISP_DISP,F,T,'risp_disp');
runSVM(G,RISP_RATIO,F,T,'risp_ratio');
runSVM(G,RISP_SELECTED,F,T,'risp_selected');
runSVM(G,WRIST_ALL,F,T,'wrist_all');
runSVM(G,WRIST_MRP,F,T,'wrist_mrp');
runSVM(G,RIPWRIST_GOOD,F,T,'ripwrist_final');
runSVM(G,RIPWRIST_GOOD,F,T,'ripwrist_final');
runSVM(G,RIPWRIST_ALL,F,T,'ripwrist_final_1');

end
function runSVM(G,indf,F,T,fname)
ind=find(T.missing<=0.33);
C=T.feature(ind,indf);
C(isnan(C))=0;
C(find(C==-Inf))=0;
C(find(C==Inf))=0;

feature_names=F{2}.featurename(indf);feature_names=strrep(feature_names,' ','_');feature_names=strrep(feature_names,'(','_');feature_names=strrep(feature_names,')','_');
label_name={'puff','nonpuff'};
pind=find(T.puff(ind)==0);[labels{pind}]=deal('nonpuff');pind=find(T.puff(ind)==1);[labels{pind}]=deal('puff');

wekafile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP '_train_' fname '.arff'];
outfile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP '_train_' fname '_output.txt'];
modelfile=[G.DIR.ROOT G.DIR.SEP 'weka' G.DIR.SEP '_train_' fname '_model.model'];

write_arff_smoking(wekafile,feature_names,label_name,C,labels);
weka_train_COST_SMO_smoking(wekafile,modelfile,outfile);
%    weka_train_SMO_smoking(wekafile,modelfile,outfile);

result=get_weka_results_smoking(outfile);
fprintf('----------------hand --------------------\n');
for r=1:length(result),fprintf('%s\n',result{r});end
end

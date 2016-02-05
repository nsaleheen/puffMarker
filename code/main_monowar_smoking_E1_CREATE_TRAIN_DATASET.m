function main_monowar_smoking_E1_CREATE_TRAIN_DATASET()
close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
G=main_monowar_smoking_E0_CONFIG_SVM(G);

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

%create_weka_SVM(G,G.SVM.RIP_MPUFF.IND,F,T,G.SVM.RIP_MPUFF.NAME);
create_weka_SVM(G,G.SVM.RIP_MPUFF_ROC.IND,F,T,G.SVM.RIP_MPUFF_ROC.NAME);
create_weka_SVM(G,G.SVM.RIP_MPUFF_ROC_WRIST_MRP_TIME.IND,F,T,G.SVM.RIP_MPUFF_ROC_WRIST_MRP_TIME.NAME);
create_weka_SVM(G,G.SVM.H_RIP_SELECTED_WRIST_SELECTED.IND,F,T,G.SVM.H_RIP_SELECTED_WRIST_SELECTED.NAME);
create_weka_SVM(G,G.SVM.HN_RIP_SELECTED_WRIST_SELECTED.IND,F,T,G.SVM.HN_RIP_SELECTED_WRIST_SELECTED.NAME);

%create_weka_SVM(G,G.SVM.H_RIP_SELECTED_WRIST_SELECTED.IND,F,T,G.SVM.H_RIP_SELECTED_WRIST_SELECTED.NAME);

%create_weka_SVM(G,RISP_ALL,F,T,'risp_all');
%create_weka_SVM(G,RISP_RAW,F,T,'risp_raw');
%create_weka_SVM(G,RISP_DISP,F,T,'risp_disp');
%create_weka_SVM(G,RISP_RATIO,F,T,'risp_ratio');
%create_weka_SVM(G,RISP_SELECTED,F,T,'risp_selected');
%create_weka_SVM(G,WRIST_ALL,F,T,'wrist_all');
%create_weka_SVM(G,G.SVM.RIP_MPUFF_ROC_WRIST_MRP_TIME.IND,F,T,G.SVM.RIP_MPUFF_ROC_WRIST_MRP_TIME.NAME);
%create_weka_SVM(G,RIP_MPUFF_ROC_WRIST_MRP_TIME,F,T,'rip_mpuff_roc_wrist_mrp_time');
%create_weka_SVM(G,RIPWRIST_ALL,F,T,'ripwrist_final_1');
%create_weka_SVM(G,G.SVM.RIP_ALL_WRIST_ALL.IND,F,T,G.SVM.RIP_ALL_WRIST_ALL.NAME);
%create_weka_SVM(G,G.SVM.RIP_SELECTED_WRIST_SELECTED.IND,F,T,G.SVM.RIP_SELECTED_WRIST_SELECTED.NAME);
%create_weka_SVM(G,G.SVM.H_RIP_SELECTED_WRIST_SELECTED.IND,F,T,G.SVM.H_RIP_SELECTED_WRIST_SELECTED.NAME);

end
function create_weka_SVM(G,indf,F,T,fname)
ind=find(T.missing<=0.33);
C=T.feature(ind,indf);
C(isnan(C))=0;
C(find(C==-Inf))=0;
C(find(C==Inf))=0;

feature_names=F{2}.featurename(indf);feature_names=strrep(feature_names,' ','_');feature_names=strrep(feature_names,'(','_');feature_names=strrep(feature_names,')','_');
label_name={'puff','nonpuff'};
pind=find(T.puff(ind)==0);[labels{pind}]=deal('nonpuff');pind=find(T.puff(ind)==1);[labels{pind}]=deal('puff');

wekafile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP 'train_' fname '.arff'];
write_arff_smoking(wekafile,feature_names,label_name,C,labels);
end

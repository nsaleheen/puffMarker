close all
clear all
G=config();
% G=config_run_monowar_Memphis_Smoking_Lab(G);
% G=config_run_monowar_Memphis_Smoking(G);
if strcmp(G.DATASET_NAME, 'minnesota_lab')==1
    G=config_run_MinnesotaLab(G);
elseif strcmp(G.DATASET_NAME, 'memphis_lab')==1
    G=config_run_monowar_Memphis_Smoking_Lab(G);
elseif strcmp( G.DATASET_NAME, 'memphis_field')==1
    G=config_run_monowar_Memphis_Smoking(G);
end

G=main_monowar_smoking_E0_CONFIG_SVM(G);
MODEL=G.SVM.RIP_MPUFF_ROC_WRIST_MRP_TIME;
%MODEL=G.SVM.MODEL;
%  MODEL=G.SVM.WRIST_MRP;
PS_LIST=G.PS_LIST;
for pp=1:size(PS_LIST,1)
    pid=char(PS_LIST{pp,1});
    slist=PS_LIST{pp,2};
    for s=slist
        sid=char(s);
       
        fprintf('pid=%s sid=%s\n',pid,sid);
        INDIR='feature';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
        for i=1:2
            count=0;
            indf=MODEL.IND;
            feature_names=F{i}.featurename(indf);feature_names=strrep(feature_names,' ','_');feature_names=strrep(feature_names,'(','_');feature_names=strrep(feature_names,')','_');
            categorynames{1}='puff';categorynames{2}='nonpuff';
            
            features=F{i}.feature(:,indf);
            if ~isfield(F{i},'puff') || (length(find(F{i}.puff==0))==0 && length(find(F{i}.puff==1))==0)
                NN=(cellstr(char((zeros(1,size(features,1))+'?')')));
            else
                pind=find(F{i}.puff==0);[NN{pind}]=deal('nonpuff');pind=find(F{i}.puff==1);[NN{pind}]=deal('puff');

            end
            categories=NN;
            fname=MODEL.NAME;
            wekafile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP fname '_' pid '_' sid '_' num2str(i) '.arff'];
            outfile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP fname '_' pid '_' sid '_' num2str(i) '_output.txt'];
            modelfile=[G.DIR.ROOT G.DIR.SEP 'weka' G.DIR.SEP 'train_' fname '_model.model'];            
            write_arff_smoking(wekafile,feature_names,categorynames,features,categories);
            TestSVM_smoking(modelfile,wekafile,outfile);

%            Test_SMO_RBF_smoking(modelfile,wekafile,outfile);
            [actual,predict,prob]=TestSVM_parse_results_smoking(outfile);
            A=zeros(1,length(actual))-1;P=zeros(1,length(predict));
            A(strcmp(actual(:),'puff')==1)=1;
            A(strcmp(actual(:),'nonpuff')==1)=0;
            
            P(strcmp(predict(:),'puff')==1)=1;
            x=find(P==0);
            prob(x)=1-prob(x);
   
            F{i}.result.actual=A;
            F{i}.result.predict=P;
            F{i}.result.probability=prob;
        end
        INDIR='segment_rip';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
        for i=1:2
            P.wrist{i}.gyr.segment.svm_actual=zeros(1,length(P.wrist{i}.gyr.segment.starttimestamp));
            P.wrist{i}.gyr.segment.svm_predict=zeros(1,length(P.wrist{i}.gyr.segment.starttimestamp));
            P.wrist{i}.gyr.segment.svm_probability=zeros(1,length(P.wrist{i}.gyr.segment.starttimestamp));
            
            for k=1:length(F{i}.result.predict)
%                if strcmp(F{i}.result.actual(k),'puff')==1, ares=1;elseif strcmp(F{i}.result.actual(k),'nonpuff')==1, ares=0;else ares=-1;end;
%                if strcmp(F{i}.result.predict(k),'puff')==1, pres=1;elseif strcmp(F{i}.result.predict(k),'nonpuff')==1, pres=0;else pres=-1;end;
                ares=F{i}.result.actual(k);
                pres=F{i}.result.predict(k);
                probability=F{i}.result.probability(k);
%                if probability>=0.05, pres=1;end

                wind=F{i}.wrist_ind(k);
                P.wrist{i}.gyr.segment.svm_actual(wind)=ares;
                P.wrist{i}.gyr.segment.svm_predict(wind)=pres;
                P.wrist{i}.gyr.segment.svm_probability(wind)=probability;
            end
        end
        OUTDIR='svm_output_prequit';outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];outfile=[pid '_' sid '_' OUTDIR '.mat'];if isempty(dir(outdir)),   mkdir(outdir);end, save([outdir G.DIR.SEP outfile],'P');
%        plot_custom(G,pid,sid,'svm_output','plot_svm_output',[],'smokinglabel','gyrmag',[2,1],'segment_gyr','map',[2,1],'selfreport','svm');
    end
end

close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
%G=config_run_monowar_Memphis_Smoking(G);
PS_LIST=G.PS_LIST;
for i=1:2
    T{i}.feature=[];
    T{i}.puff=[];T{i}.missing=[];T{i}.missing_rip=[];T{i}.missing_wrist=[];
    T{i}.episode=[];
end
for pp=1:size(PS_LIST,1)
    pid=char(PS_LIST{pp,1});
    slist=PS_LIST{pp,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s\n',pid,sid);
        INDIR='feature';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
        for i=1:2
            inde=find(F{i}.puff==1 | (F{i}.episode==0 & F{i}.puff==0));
            T{i}.feature=[T{i}.feature;F{i}.feature(inde,:)];
            T{i}.puff=[T{i}.puff;F{i}.puff(inde)'];
            T{i}.missing=[T{i}.missing;F{i}.missing(inde)'];
            T{i}.missing_rip=[T{i}.missing_rip;F{i}.rip.missing(inde)'];
            T{i}.missing_wrist=[T{i}.missing_wrist;F{i}.wrist.missing(inde)'];
            T{i}.episode=[T{i}.episode;F{i}.episode(inde)'];
        end
        %        OUTDIR='feature';outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];outfile=[pid '_' sid '_' OUTDIR '.mat'];if isempty(dir(outdir)),   mkdir(outdir);end, save([outdir G.DIR.SEP outfile],'F');
    end
end
RIP_RAW=1:15;
RIP_DIST=16:30;
RIP_RATIO=31:45;
WRIST=46:70;
TIME=71:75;
for i=1:2
    ind=find(T{i}.missing<=0.33);
    indf=[6,8,9,10,11,16,19,22,24,33,40,43,44,46,50,54,57,58,62,67,69];
%    indf=[6,8,9,12,15,18,25,28,32,34,37,38,43];
%    indf=1:size(T{i}.feature,2);
    C=T{i}.feature(ind,indf);
    C(isnan(C))=0;
    C(find(C==-Inf))=0;
    C(find(C==Inf))=0;
    
    feature_names=F{i}.featurename(indf);feature_names=strrep(feature_names,' ','_');feature_names=strrep(feature_names,'(','_');feature_names=strrep(feature_names,')','_');
    label_name={'puff','nonpuff'};
    pind=find(T{i}.puff(ind)==0);[labels{pind}]=deal('nonpuff');pind=find(T{i}.puff(ind)==1);[labels{pind}]=deal('puff');
    
    wekafile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP '_train_all_' num2str(i) '.arff'];
    outfile=[G.DIR.DATA G.DIR.SEP 'weka' G.DIR.SEP '_train_all_' num2str(i) '_output.txt'];
    modelfile=[G.DIR.ROOT G.DIR.SEP 'weka' G.DIR.SEP '_train_all_' num2str(i) '_model.model'];

    write_arff_smoking(wekafile,feature_names,label_name,C,labels);
    weka_train_SMO_smoking(wekafile,modelfile,outfile);
    result=get_weka_results_smoking(outfile);
    fprintf('----------------hand %d --------------------\n',i);
    for r=1:length(result),fprintf('%s\n',result{r});end
end

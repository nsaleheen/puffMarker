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
LSEG=0;RSEG=0;LSEG_H=0;RSEG_H=0;LSEG_L=0;RSEG_L=0;
PS_LIST=G.PS_LIST;
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s\n',pid,sid);
        INDIR='segment_gyr';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')==2,load([indir G.DIR.SEP infile]);end        
        P=filter_segment_length_gyr(G,P,1000,6000);
        LSEG=LSEG+length(P.wrist{1}.gyr.segment.starttimestamp);
        RSEG=RSEG+length(P.wrist{2}.gyr.segment.starttimestamp);

        LSEG_H=LSEG_H+length(find(P.wrist{1}.gyr.segment.valid_height==0));
        RSEG_H=RSEG_H+length(find(P.wrist{2}.gyr.segment.valid_height==0));
        
        LSEG_L=LSEG_L+length(find(P.wrist{1}.gyr.segment.valid_length==0 & P.wrist{1}.gyr.segment.valid_height==0));
        RSEG_L=RSEG_L+length(find(P.wrist{2}.gyr.segment.valid_length==0 & P.wrist{2}.gyr.segment.valid_height==0));
        OUTDIR='segment_gyr';outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];outfile=[pid '_' sid '_' OUTDIR '.mat'];if isempty(dir(outdir)),   mkdir(outdir);end, save([outdir G.DIR.SEP outfile],'P');
        fprintf('\nLSEG,%d,LSEG_H,%d,LSEG_L,%d,RSEG,%d,RSEG_H,%d,RSEG_L,%d\n',LSEG,LSEG_H,LSEG_L,RSEG,RSEG_H,RSEG_L);
        
    end
end
fprintf(') =>  done\n');

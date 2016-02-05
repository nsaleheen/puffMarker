clear all
close all
G=config();
% G=config_run_monowar_Memphis_Smoking_Lab(G);
%G=config_run_monowar_Memphis_Smoking(G);
% G=config_run_MinnesotaLab(G);
if strcmp(G.DATASET_NAME, 'minnesota_lab')==1
    G=config_run_MinnesotaLab(G);
elseif strcmp(G.DATASET_NAME, 'memphis_lab')==1
    G=config_run_monowar_Memphis_Smoking_Lab(G);
elseif strcmp( G.DATASET_NAME, 'memphis_field')==1
    G=config_run_monowar_Memphis_Smoking(G);
end
PS_LIST=G.PS_LIST;
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s ',pid,sid);
        INDIR='frmtdata';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if isempty([indir G.DIR.SEP infile]),    disp(['FILE NOT FOUND' indir G.DIR.SEP infile]);return;end; load([indir G.DIR.SEP infile]);
        B=D;clear D;B.NAME=['BASICFEATURE[' G.STUDYNAME ' ' pid ' ' sid ']'];
        B=main_basicfeature(G,B);
        B=main_basicfeature_rip_updated(G,B);
        B=detect_peakvalley_v3(G,B);
        
        B=find_smoking_episode_lab(G,B);
       
        %change korte hobe
        %B.selfreport=read_selfreport_smokingposition(G,pid,sid,'raw',B);
        
        OUTDIR='basicfeature';outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];outfile=[pid '_' sid '_' OUTDIR '.mat'];if isempty(dir(outdir)), mkdir(outdir);end; save([outdir G.DIR.SEP outfile],'B');
        
%        plot_custom(G,pid,sid,'basicfeature','b_figure',[G.SENSOR.R_RIPID,G.SENSOR.WR9_ACLYID,G.SENSOR.WL9_ACLYID],'peakvalley','bar',[-700,0,700],'save',[5,5],'smokinglabel');
    end
end

close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
%G=config_run_monowar_Memphis_Smoking(G);
PS_LIST=G.PS_LIST;
LSEG=0;RSEG=0;LSEG_H=0;RSEG_H=0;
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s\n',pid,sid);
        INDIR='segment_acl';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')==2,load([indir G.DIR.SEP infile]);else
        INDIR='preprocess_wrist3';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')==2,load([indir G.DIR.SEP infile]);else continue;end;end
        P=segmentation1_gyr(G,P);
        TH=50;P=filter_segment_height(G,P,TH);

        P=calculate_roll_pitch_segment(G,P);
        P=calculate_missing_handmark_gyr(G,P);
        LSEG=LSEG+length(P.wrist{1}.gyr.segment.starttimestamp);
        RSEG=RSEG+length(P.wrist{2}.gyr.segment.starttimestamp);
        LSEG_H=LSEG_H+length(find(P.wrist{1}.gyr.segment.valid_height==0));
        RSEG_H=RSEG_H+length(find(P.wrist{2}.gyr.segment.valid_height==0));
        fprintf('LSEG,%d,LSEG_H,%d,RSEG,%d,RSEG_H,%d\n',LSEG,LSEG_H,RSEG,RSEG_H);
        OUTDIR='segment_gyr';outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];outfile=[pid '_' sid '_' OUTDIR '.mat'];if isempty(dir(outdir)),   mkdir(outdir);end, save([outdir G.DIR.SEP outfile],'P');
%        plot_custom(G,pid,sid,'segment_gyr','selfreport',[],...
%            'smokinglabel','acl',[2,1],'segment_acl','handmark_acl','gyrmag',[2,1],'handmark_gyr','segment_gyr');

%        plot_custom(G,pid,sid,'segment_gyr','handmark_acl',[G.SENSOR.R_RIPID],...
%            'smokinglabel','acl',[2,1],'segment_acl','handmark_acl','gyrmag',[2,1],'handmark_gyr','segment_gyr');
        fprintf('\n');
    end
end
fprintf(') =>  done\n');

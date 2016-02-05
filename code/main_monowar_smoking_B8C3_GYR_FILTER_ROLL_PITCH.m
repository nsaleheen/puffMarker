close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
%G=config_run_monowar_Memphis_Smoking(G);
LSEG=0;RSEG=0;LSEG_H=0;RSEG_H=0;LSEG_L=0;RSEG_L=0;LSEG_RP=0;RSEG_RP=0;

PS_LIST=G.PS_LIST;
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s\n',pid,sid);
        load('RP.mat');
        INDIR='segment_gyr';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')==2,load([indir G.DIR.SEP infile]);end        
        P=filter_segment_roll_pitch_gyr(G, P,RP);
%        P=filter_segment_roll_pitch_gyr_mhl(G,P,RP);
        P.wrist{1}.gyr.segment.valid_all=P.wrist{1}.gyr.segment.valid_height+P.wrist{1}.gyr.segment.valid_length+P.wrist{1}.gyr.segment.valid_rp;
        P.wrist{2}.gyr.segment.valid_all=P.wrist{2}.gyr.segment.valid_height+P.wrist{2}.gyr.segment.valid_length+P.wrist{2}.gyr.segment.valid_rp;
        
        LSEG=LSEG+length(P.wrist{1}.gyr.segment.starttimestamp);
        RSEG=RSEG+length(P.wrist{2}.gyr.segment.starttimestamp);

        LSEG_H=LSEG_H+length(find(P.wrist{1}.gyr.segment.valid_height==0));
        RSEG_H=RSEG_H+length(find(P.wrist{2}.gyr.segment.valid_height==0));
        
        LSEG_L=LSEG_L+length(find(P.wrist{1}.gyr.segment.valid_length==0 & P.wrist{1}.gyr.segment.valid_height==0));
        RSEG_L=RSEG_L+length(find(P.wrist{2}.gyr.segment.valid_length==0 & P.wrist{2}.gyr.segment.valid_height==0));
        LSEG_RP=LSEG_RP+length(find(P.wrist{1}.gyr.segment.valid_length==0 & P.wrist{1}.gyr.segment.valid_height==0 & P.wrist{1}.gyr.segment.valid_rp==0));
        RSEG_RP=RSEG_RP+length(find(P.wrist{2}.gyr.segment.valid_length==0 & P.wrist{2}.gyr.segment.valid_height==0 & P.wrist{2}.gyr.segment.valid_rp==0));
        
        OUTDIR='segment_gyr';outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];outfile=[pid '_' sid '_' OUTDIR '.mat'];if isempty(dir(outdir)),   mkdir(outdir);end, save([outdir G.DIR.SEP outfile],'P');
        fprintf('\nLSEG,%d,LSEG_H,%d,LSEG_L,%d,LSEG_RP,%d,RSEG,%d,RSEG_H,%d,RSEG_L,%d,RSEG_RP,%d\n',LSEG,LSEG_H,LSEG_L,LSEG_RP,RSEG,RSEG_H,RSEG_L,RSEG_RP);
        
%         plot_custom(G,pid,sid,'segment_gyr','field_selfreport',[G.SENSOR.R_RIPID,G.SENSOR.WR9_ACLYID,G.SENSOR.WL9_ACLYID],...
%                  'smokinglabel','gyrmag',[2,1],'segment_gyr','selfreport','bar',[0,250]);
        disp('abc');
    end
end
fprintf(') =>  done\n');

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

RIP=0;
PS_LIST=G.PS_LIST;
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s\n',pid,sid);
        INDIR='basicfeature';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
        INDIR='segment_gyr';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
        RIP=RIP+(length(B.sensor{1}.peakvalley_new_3.sample)-1)/2;
        fprintf('RIP,%d\n',RIP);
        P.selfreport=B.selfreport;
%        P.sensor{1}=B.sensor{1};
%        clear B;
        P.wrist{1}.gyr.segment.valid_all=P.wrist{1}.gyr.segment.valid_height+P.wrist{1}.gyr.segment.valid_length+P.wrist{1}.gyr.segment.valid_rp+P.wrist{1}.gyr.segment.valid_acl_gyr;
        P.wrist{2}.gyr.segment.valid_all=P.wrist{2}.gyr.segment.valid_height+P.wrist{2}.gyr.segment.valid_length+P.wrist{2}.gyr.segment.valid_rp+P.wrist{2}.gyr.segment.valid_acl_gyr;
a1=length(find(P.wrist{2}.gyr.segment.valid_length==0 & P.wrist{2}.gyr.segment.valid_height==0 & P.wrist{2}.gyr.segment.valid_rp==0& P.wrist{2}.gyr.segment.valid_acl_gyr==0));
a2=length(find(P.wrist{2}.gyr.segment.valid_all==0));
fprintf('a1=%d, a2=%d', a1, a2);
        %        P=detect_peakvalley_v3(G,P);
        P=map_wrist_rip(G,P);
%        P=find_mark_peakvalley(G,P);
        OUTDIR='segment_rip';outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];outfile=[pid '_' sid '_' OUTDIR '.mat'];if isempty(dir(outdir)),   mkdir(outdir);end, save([outdir G.DIR.SEP outfile],'P');
%        plot_custom(G,pid,sid,'segment_rip','plot_rip',[],'smokinglabel','selfreport','gyrmag',[2,1],'segment_gyr','map',[2,1]);
        disp('abc');
%        plot_custom(G,pid,sid,'segment_rip','plot_rip',[],'smokinglabel','acl',[2,1],'segment_acl','handmark_acl','bar',[-600,0,600],'gyrmag',[2,1],'segment_gyr','map',[2,1],'save',[0.5,0.5]);
        
%        plot_custom(G,pid,sid,'segment_rip','plot_rip',[],'peakvalley','smokinglabel','acl',[2,1],'segment_acl','handmark_acl','bar',[-600,0,600],'gyrmag',[2,1],'segment_gyr');
%        plot_custom(G,pid,sid,'segment_rip','field_selfreport',[G.SENSOR.R_RIPID,G.SENSOR.WR9_ACLYID,G.SENSOR.WL9_ACLYID],...
%                 'smokinglabel','gyrmag',[2,1],'segment_gyr','selfreport','save',[10,2],'bar',[0,250]);
    end
end
fprintf(') =>  done\n');

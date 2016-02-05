close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
%G=config_run_monowar_Memphis_Smoking(G);
PS_LIST=G.PS_LIST;
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s\n',pid,sid);
        INDIR='preprocess_wrist';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);        
        P=calculate_interpolate(G,P);        
        P=calculate_roll_pitch(G,P);
        for i=[G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_GYRZID,G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_GYRZID],
            P.sensor{i}=rmfield(P.sensor{i},'sample_interpolate');P.sensor{i}=rmfield(P.sensor{i},'timestamp_interpolate');P.sensor{i}=rmfield(P.sensor{i},'matlabtime_interpolate');            
        end

        OUTDIR='preprocess_wrist3';outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];outfile=[pid '_' sid '_' OUTDIR '.mat'];if isempty(dir(outdir)), mkdir(outdir);end; save([outdir G.DIR.SEP outfile],'P');
    end
end
fprintf(') =>  done\n');

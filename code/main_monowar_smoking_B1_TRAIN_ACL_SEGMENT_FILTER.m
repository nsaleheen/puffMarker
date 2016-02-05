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
        INDIR='preprocess_wrist3';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
        
        P=segmentation_acl(G,P,380);

        P=correct_marktime_manually(G,pid,sid,P);
        P=find_mark_acl(G,P);
        P=correct_handmarktime_manually(G,pid,sid,P);
        P=calculate_missing_handmark(G,P);
        
        OUTDIR='segment_acl';outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];outfile=[pid '_' sid '_' OUTDIR '.mat'];if isempty(dir(outdir)),   mkdir(outdir);end, save([outdir G.DIR.SEP outfile],'P');
    end
    fprintf(') =>  done\n');
end

close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
%G=config_run_monowar_Memphis_Smoking(G);
PS_LIST=G.PS_LIST;
for pp=1:size(PS_LIST,1)
    pid=char(PS_LIST{pp,1});
    slist=PS_LIST{pp,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s\n',pid,sid);
        INDIR='segment_rip';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
%        figure;plot(P.sensor{1}.matlabtime,P.sensor{1}.sample_new,'g-');
%        hold on;plot(P.sensor{1}.peakvalley_new_3.matlabtime(1:2:end),P.sensor{1}.peakvalley_new_3.sample(1:2:end),'g*','markersize',5);
%        hold on;plot(P.sensor{1}.peakvalley_new_3.matlabtime(2:2:end),P.sensor{1}.peakvalley_new_3.sample(2:2:end),'r*','markersize',5);
%        plot(xlim,[0,0],'k-');
%        plot(P.sensor{1}.matlabtime,sample,'m-');

        rip=rip_features(G,P);
        rip=normalize_features(G,rip);
        wrist=wrist_features(G,P);
        F=combine_rip_wrist_feature(G,rip,wrist,P);
        OUTDIR='feature';outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];outfile=[pid '_' sid '_' OUTDIR '.mat'];if isempty(dir(outdir)),   mkdir(outdir);end, save([outdir G.DIR.SEP outfile],'F');
    end
end
disp('abc');

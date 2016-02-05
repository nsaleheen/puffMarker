close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
%find_smoking_episodes(G);

PS_LIST=G.PS_LIST;
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s\n',pid,sid);
        
        INDIR='segment_gyr';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')==2,load([indir G.DIR.SEP infile]);end
        P=find_mark_gyr(G,P);
%        P=find_peak_gyr(G,P);
        OUTDIR='segment_gyr';outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];outfile=[pid '_' sid '_' OUTDIR '.mat'];if isempty(dir(outdir)),    mkdir(outdir);end;save([outdir G.DIR.SEP outfile],'P');
        
        %       plot_custom(G,pid,sid,'segment','handmark_acl',[G.SENSOR.R_RIPID],...
        %            'smokinglabel','acl',[2,1],'segment_acl','handmark_acl','gyrmag',[2,1],'handmark_gyr','segment_gyr');
    end
    %    [tot,miss,valid]=remove_missing_handmark(G,pid,sid,'preprocess');
    %        plot_custom(G,pid,sid,'preprocess','handmark_acl_gyr',[G.SENSOR.R_RIPID],...
    %            'bar',[-600,0,600],'smokinglabel','acl',[2,1],'segment_acl','handmark_acl','gyrmag',[2,1],'segment_acl_gyr');
    
    %        plot_custom(G,pid,sid,'preprocess','gyr_figure',[G.SENSOR.WR9_ACLYID,G.SENSOR.WR9_ACLYID,G.SENSOR.WL9_ACLYID],...
    %            'bar',[-700,0,700],'smokinglabel','gyrmag',[2,1],'handmark_GYR','segment_gyr','save',[0,0]);
    
end


% find_mark_peakvalley(G,pid,sid,'preprocess');
% iplot4_monowar_pv_puff_bar_filter_updown_mark(G,pid,sid,episode,'preprocess',[G.SENSOR.R_RIPID,G.SENSOR.WR9_ACLYID,G.SENSOR.WL9_ACLYID],700);
% pause;
% for i=1:length(cursor_info)
%     fprintf('%f\n',cursor_info(i).Position(1));
% end
%cress.mark{str2num(pid(2:end))}{str2num(sid(2:end))}=cursor_info;
%cress.pos=pos;
%save('cress.mat','cress');
fprintf(') =>  done\n');

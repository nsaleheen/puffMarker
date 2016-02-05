close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
%G=config_run_monowar_Memphis_Smoking(G);
peak_distribution = zeros(1, 4000);
PS_LIST=G.PS_LIST;
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        fprintf('pid=%s sid=%s\n',pid,sid);
%         plot_custom(G,pid,sid,'segment_gyr','handmark_acl',[G.SENSOR.WR9_ACLYID,G.SENSOR.WL9_ACLYID],...
%             'smokinglabel','bar',[-600,0,600]);
%         continue;
        INDIR='basicfeature';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
        
        P=B;P.NAME=[G.STUDYNAME ' ' pid ' ' sid];P=rmfield(P,'sensor');
        for i=[G.SENSOR.R_RIPID,G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_GYRZID,G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_GYRZID], P.sensor{i}=B.sensor{i};end
        P=remove_bias(G,P,pid);
        P=calculate_interpolate(G,P);
%         P=calculate_magnitude(G,P);
        P=calculate_magnitude_nazir(G,P);
        P=calculate_magnitude_peaks_nazir(G,P);
        peak_distribution = peak_distribution +calculate_peak_distribution_nazir(G, P);
%        P=calculate_roll_pitch(G,P);
        for i=[G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_GYRZID,G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_GYRZID],
            P.sensor{i}=rmfield(P.sensor{i},'sample_interpolate');P.sensor{i}=rmfield(P.sensor{i},'timestamp_interpolate');P.sensor{i}=rmfield(P.sensor{i},'matlabtime_interpolate');            
        end
        OUTDIR='preprocess_wrist';outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];outfile=[pid '_' sid '_' OUTDIR '.mat'];if isempty(dir(outdir)), mkdir(outdir);end; save([outdir G.DIR.SEP outfile],'P');
    end
end
plot(1:4000, peak_distribution, 'r+');

fprintf(') =>  done\n');

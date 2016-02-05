function main_formatteddata(G,pid,sid,INDIR,OUTDIR)
%% Load Data (Formatted Raw, Formatted Data)
%fprintf('%-6s %-6s %-20s Task (',pid,sid,'main_formatteddata');
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' G.FILE.FRMTRAW_MATNAME];
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
outfile=[pid '_' sid '_' G.FILE.FRMTDATA_MATNAME];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);
% if isempty(R.adminmark), return;end;
% if isempty(R.adminmark.dose), return;end;

% fprintf('%s,%s',pid,sid);
% for i=1:length(R.adminmark.dose)
%     fprintf(',%d',R.adminmark.dose(i));
% end
% fprintf('\n');
% return;
if isempty(dir([outdir G.DIR.SEP outfile])) || G.RUN.FRMTDATA.LOADDATA==0, D=R;
else load([outdir G.DIR.SEP outfile]);end
%% Metadata
fprintf('metadata');
D.NAME=['FORMATEDDATA[' G.STUDYNAME ' ' pid ' ' sid ']'];


%% Load EMA
if G.RUN.FRMTDATA.EMA, fprintf('...ema');D.ema.data=format_EMA(R.ema.data);end
%% correct timestamp, interpolation
if G.RUN.FRMTDATA.CORRECTTIMESTAMP,
    fprintf('...correct_timestamp');
    for sensorid=G.RUN.FRMTDATA.SENSORLIST_CORRECTTIMESTAMP
        fprintf([G.SENSOR.ID(sensorid).NAME ',']);
        D.sensor{sensorid}.sample=[];D.sensor{sensorid}.timestamp=[];D.sensor{sensorid}.matlabtime=[];
        timestamp=R.sensor{sensorid}.timestamp;
        sample=R.sensor{sensorid}.sample;
        for i=1:G.SAMPLE_TOS-1,        timestamp(i:G.SAMPLE_TOS:end)=0; end;
        segment = split_by_gaps(timestamp);
        if isempty(segment), continue; end
        [D.sensor{sensorid}.sample,D.sensor{sensorid}.timestamp] = correct_timestamps(G,sample,timestamp,segment,G.SENSOR.ID(sensorid).FREQ);
        D.sensor{sensorid}.matlabtime=convert_timestamp_matlabtimestamp(G,D.sensor{sensorid}.timestamp);
    end
end
%fprintf(')');
if G.RUN.FRMTDATA.INTERPOLATE,
    fprintf('...interpolate');
    for sensorid=G.RUN.FRMTDATA.SENSORLIST_INTERPOLATE
        %    fprintf([G.SENSOR.ID(sensorid).NAME ',']);
        
        timestamp=D.sensor{sensorid}.timestamp;
        sample=D.sensor{sensorid}.sample;
        [D.sensor{sensorid}.sample,D.sensor{sensorid}.timestamp] = interpolate_gaps(G,sample,timestamp,G.SENSOR.ID(sensorid).FREQ);
        D.sensor{sensorid}.matlabtime=convert_timestamp_matlabtimestamp(G,D.sensor{sensorid}.timestamp);
    end
end
%% Data quality calculation: valid chunk, band off, band loose chunk
if G.RUN.FRMTDATA.QUALITY,
    for sensorid=G.RUN.FRMTDATA.SENSORLIST_QUALITY
        if sensorid==G.SENSOR.R_RIPID
            D.sensor{sensorid}.quality=calculateDataQuality(G,D.sensor{sensorid}.sample,D.sensor{sensorid}.timestamp,G.SENSOR.R_RIPID,D.starttimestamp,D.endtimestamp);
            D.sensor{sensorid}.sample_all=D.sensor{sensorid}.sample;
            D.sensor{sensorid}.timestamp_all=D.sensor{sensorid}.timestamp;
            D.sensor{sensorid}.matlabtime_all=D.sensor{sensorid}.matlabtime;
            [D.sensor{sensorid}.sample, D.sensor{sensorid}.timestamp,D.sensor{sensorid}.matlabtime]=saveGoodData(G,D.sensor{sensorid}.sample_all,D.sensor{sensorid}.timestamp_all,D.sensor{sensorid}.matlabtime_all,D.sensor{sensorid}.quality);
            [D.sensor{sensorid}.sample, D.sensor{sensorid}.timestamp,D.sensor{sensorid}.matlabtime]=filter_bad_RIP(D.sensor{sensorid}.sample,D.sensor{sensorid}.timestamp,D.sensor{sensorid}.matlabtime);
            fprintf('...dataquality_rip');
        elseif sensorid==G.SENSOR.R_ECGID
            D.sensor{sensorid}.quality=calculateDataQuality(G,D.sensor{sensorid}.sample,D.sensor{sensorid}.timestamp,G.SENSOR.R_ECGID,D.starttimestamp,D.endtimestamp);
            D.sensor{sensorid}.sample_all=D.sensor{sensorid}.sample;
            D.sensor{sensorid}.timestamp_all=D.sensor{sensorid}.timestamp;
            D.sensor{sensorid}.matlabtime_all=D.sensor{sensorid}.matlabtime;
            [D.sensor{sensorid}.sample, D.sensor{sensorid}.timestamp, D.sensor{sensorid}.matlabtime] = saveGoodData(G,D.sensor{sensorid}.sample_all,D.sensor{sensorid}.timestamp_all,D.sensor{sensorid}.matlabtime_all,D.sensor{sensorid}.quality);
            [D.sensor{sensorid}.sample, D.sensor{sensorid}.timestamp,D.sensor{sensorid}.matlabtime]=filter_bad_ecg(D.sensor{sensorid}.sample,D.sensor{sensorid}.timestamp,D.sensor{sensorid}.matlabtime);
            fprintf('...dataquality_ecg');
        elseif sensorid==G.SENSOR.R_ACLXID || sensorid==G.SENSOR.R_ACLYID || sensorid==G.SENSOR.R_ACLZID 
            D.sensor{sensorid}.sample_all=D.sensor{sensorid}.sample;
            if length(D.sensor{sensorid}.sample)>200    %number of samples should be at least 20 seconds
                [ acclMps2, linearAccl, gravityCmp ] = accl_sep_linear_gravity(D.sensor{sensorid}.sample,G.BIAS(sensorid));
                D.sensor{sensorid}.sample=remove_drift_accel(linearAccl(100:end-100)); %ignore first and last 100 samples
                D.sensor{sensorid}.timestamp=D.sensor{sensorid}.timestamp(100:end-100);
            end
            %normalize the raw samples
            D.sensor{sensorid}.sample = (D.sensor{sensorid}.sample-nanmean(D.sensor{sensorid}.sample))/sqrt(nanvar(D.sensor{sensorid}.sample));
            
            D.sensor{sensorid}.timestamp_all=D.sensor{sensorid}.timestamp;
            D.sensor{sensorid}.matlabtime_all=D.sensor{sensorid}.matlabtime;
            fprintf('...dataquality_chest_acl');
        elseif sensorid==G.SENSOR.P_ACLXID || sensorid==G.SENSOR.P_ACLYID || sensorid==G.SENSOR.P_ACLZID
            if isfield(R.sensor{sensorid},'sample')
            D.sensor{sensorid}.sample_all=R.sensor{sensorid}.sample;
            D.sensor{sensorid}.sample=remove_drift_accel(R.sensor{sensorid}.sample);
            D.sensor{sensorid}.sample=R.sensor{sensorid}.sample(100:end-100);
            D.sensor{sensorid}.timestamp=R.sensor{sensorid}.timestamp(100:end-100);
            D.sensor{sensorid}.matlabtime=convert_timestamp_matlabtimestamp(G,R.sensor{sensorid}.timestamp);
            %normalize the raw samples
            D.sensor{sensorid}.sample = (D.sensor{sensorid}.sample-nanmean(D.sensor{sensorid}.sample))/sqrt(nanvar(D.sensor{sensorid}.sample));
            end
            fprintf('...dataquality_phone_acl');
        end
    end
end
%if RUN.FRMTDATA.NIDA_PDA_SELFREPORT, D.nida_pda_selfreport=read_nida_pda_selfreport(pid,sid,D);end;
%if RUN.FRMTDATA.JHU_PDA_LABREPORT,D.jhu_pda_labreport=read_jhu_pda_labreport(pid,D);disp('cocaineentry');end

%% Save Data
if isempty(dir(outdir))
    mkdir(outdir);
end
save([outdir G.DIR.SEP outfile],'D');
fprintf(') =>  done\n');

end

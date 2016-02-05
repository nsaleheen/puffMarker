function smoking_lab_formattedraw( G, pid, sid, INDIR, OUTDIR, starttimestr, endtimestr)

    indir=[G.DIR.DATA G.DIR.SEP INDIR G.DIR.SEP pid];
    outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];

    starttimestamp=convert_time_timestamp(G,starttimestr);
    endtimestamp=convert_time_timestamp(G,endtimestr);
    
    outfile=[pid '_' sid '_' G.FILE.FRMTRAW_MATNAME];
    
    if isempty(dir([outdir G.DIR.SEP outfile])) || G.RUN.FRMTRAW.LOADDATA==0, R=[];
    else load([outdir G.DIR.SEP outfile]);end
    
    fprintf('metadata');
    R.NAME=['FORMATEDRAW[' G.STUDYNAME ' ' pid ' ' sid ']'];
    R.METADATA.SESSION_STARTTIME=starttimestr;
    R.METADATA.SESSION_ENDTIME=endtimestr;
    R.METADATA.SESSION_STARTTIMESTAMP=starttimestamp;
    R.METADATA.SESSION_ENDTIMESTAMP=endtimestamp;
    R.METADATA.SESSION_STARTMATLABTIME=convert_timestamp_matlabtimestamp(G,starttimestamp);
    R.METADATA.SESSION_ENDMATLABTIME=convert_timestamp_matlabtimestamp(G,endtimestamp);
    
    R.METADATA.STUDYNAME=G.STUDYNAME;
    R.METADATA.PID=pid;
    R.METADATA.SID=sid;
    R.starttimestamp=starttimestamp;
    R.endtimestamp=endtimestamp;
    
    R.start_matlabtime=convert_timestamp_matlabtimestamp(G,R.starttimestamp);
    R.end_matlabtime=convert_timestamp_matlabtimestamp(G,R.endtimestamp);
    
    if G.RUN.FRMTRAW.TOS==1,fprintf('...tos');
        sensor=read_tosfiles(G,indir,starttimestamp,endtimestamp);
        [R.sensor{G.RUN.FRMTRAW.SENSORLIST_TOS}]=sensor{G.RUN.FRMTRAW.SENSORLIST_TOS};
    end
    if G.RUN.FRMTRAW.SELFREPORT==1, fprintf('...selfreport');R.selfreport=read_selfreport(G,indir,starttimestamp,endtimestamp);end
    if G.RUN.FRMTRAW.LABSTUDYMARK==1, fprintf('...labstudymark');R.labstudy_mark=read_labstudymark(G,indir,starttimestamp,endtimestamp);end
    if G.RUN.FRMTRAW.LABSTUDYLOG==1, fprintf('...labstudylog');R.labstudy_log=read_labstudy_log(G,indir,starttimestamp,endtimestamp);end
    if G.RUN.FRMTRAW.EMA==1, fprintf('...ema');R.ema=read_ema(G,indir,starttimestamp,endtimestamp);end
    if isfield(G.RUN.FRMTRAW,'CRESS') && G.RUN.FRMTRAW.CRESS==1, fprintf('...cress'); R.cress=read_cress(G,indir,starttimestamp,endtimestamp);end;
%     if G.RUN.FRMTRAW.DATALABEL==1, fprintf('...Data Label'); R.label=read_datalabel(G,indir,starttimestamp,endtimestamp);end;
    
    if G.RUN.FRMTRAW.GPS==1
        fprintf('...gps');
        sensor = read_gpsfiles(G,indir,starttimestamp,endtimestamp);
        [R.sensor{G.RUN.FRMTRAW.SENSORLIST_GPS}]=sensor{G.RUN.FRMTRAW.SENSORLIST_GPS};
    end
    if G.RUN.FRMTRAW.PHONESENSOR==1
        fprintf('...phonesensor');
        sensor=read_sensordb(G,indir,starttimestamp,endtimestamp);
        [R.sensor{G.RUN.FRMTRAW.SENSORLIST_DB}]=sensor{G.RUN.FRMTRAW.SENSORLIST_DB};
    end;
    if isempty(dir(outdir))
        mkdir(outdir);
    end
    
    save([outdir G.DIR.SEP outfile],'R');
    fprintf(') =>  done\n');

end


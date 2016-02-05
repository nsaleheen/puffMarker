function main_formattedraw(G,pid,sid,INDIR,OUTDIR)
indir=[G.DIR.DATA G.DIR.SEP INDIR G.DIR.SEP pid];
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];

session_def_filename=[indir G.DIR.SEP G.FILE.SESSION_DEF];
fid=fopen(session_def_filename,'r');
tline = fgetl(fid);

while ischar(tline)
    parts = textscan(tline,'%s','delimiter',',');
    parts = parts{1};
	if max(strcmp(parts, 'participant')) == 1 %strendswith(session_def_filename, '.txt')==1
		ix = find(strcmp(parts, 'participant'));pid=parts{ix+1};
		ix = find(strcmp(parts, 'sessionname'));sid_now=parts{ix+1};
		ix = find(strcmp(parts, 'start'));starttimestr=parts{ix+1};
		ix = find(strcmp(parts, 'end'));endtimestr=parts{ix+1};
		
		ix = find(strcmp(parts, 'sessiontype'));sessiontype=parts{ix+1};
		if strcmp(sessiontype, 'lab') == 1
			tline = fgetl(fid);
			continue;
		end
	else
		ix = find(strcmp(parts, 'pid'));pid=parts{ix+1};
		ix = find(strcmp(parts, 'sid'));sid_now=parts{ix+1};
		ix = find(strcmp(parts, 'start'));starttimestr=parts{ix+1};
		ix = find(strcmp(parts, 'end'));endtimestr=parts{ix+1};
	end
    tline = fgetl(fid);
    if strcmp(sid_now,sid)~=1, continue;end;
    fprintf('%-6s %-6s %-20s Task (',pid,sid,'main_formattedraw');
    
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
    
    if G.RUN.FRMTRAW.EMA==1
        if isfield(G.RUN, 'EMA_METADATA_TABLE_LIST')
            tableList = G.RUN.EMA_METADATA_TABLE_LIST;
            for i=1:length(tableList)
                fprintf('...ema%d', i);
                R.ema{i}=read_ema2(G,indir,starttimestamp,endtimestamp, tableList{i});
            end
        else
            fprintf('...ema');
            R.ema=read_ema(G,indir,starttimestamp,endtimestamp);
        end
    end
    
    if G.RUN.FRMTRAW.TOS==1,fprintf('...tos');
        sensor=read_tosfiles(G,indir,starttimestamp,endtimestamp);
        [R.sensor{G.RUN.FRMTRAW.SENSORLIST_TOS}]=sensor{G.RUN.FRMTRAW.SENSORLIST_TOS};
    end
    if G.RUN.FRMTRAW.SELFREPORT==1, fprintf('...selfreport');R.selfreport=read_selfreport(G,indir,starttimestamp,endtimestamp);end
    if G.RUN.FRMTRAW.LABSTUDYMARK==1, fprintf('...labstudymark');R.labstudy_mark=read_labstudymark(G,indir,starttimestamp,endtimestamp);end
    if G.RUN.FRMTRAW.LABSTUDYLOG==1, fprintf('...labstudylog');R.labstudy_log=read_labstudy_log(G,indir,starttimestamp,endtimestamp);end
    if isfield(G.RUN.FRMTRAW,'CRESS') && G.RUN.FRMTRAW.CRESS==1, fprintf('...cress'); R.cress=read_cress(G,indir,starttimestamp,endtimestamp);end;
    if G.RUN.FRMTRAW.DATALABEL==1, fprintf('...Data Label'); R.label=read_datalabel(G,indir,starttimestamp,endtimestamp);end;
    
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
fclose(fid);
end

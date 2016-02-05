function pdamark=load_nida_pda_selfreport_formatteddata(G,INDIR,OUTDIR)
indir=[G.DIR.DATA G.DIR.SEP INDIR];
pdamark=[];

files=dir(indir);
for i=3:length(files)
    load([indir G.DIR.SEP files(i).name]);
    pid=R.METADATA.PID;
    k=0;
    pdamark=[];
    for j=1:length(C{1})
        if strcmp(C{1}{j},pid)~=1, continue; end
        tm=convert_time_timestamp(G,datestr(datenum(C{4}{j}),G.TIME.FORMAT));
        if tm~=R.starttimestamp, continue; end
        timestr=[char(C{4}{j}) ' ' char(C{5}{j})];
        timestr=datestr(timestr,G.TIME.FORMAT);
        timestamp=convert_time_timestamp(G,timestr);
        k=k+1;
		pdamark.time{k}=[char(C{4}{j}) ' ' char(C{5}{j})];
        pdamark.timestamp(k)=timestamp;
        pdamark.matlabtime(k)=convert_timestamp_matlabtimestamp(G,timestamp);
        if isempty(C{7}{j}), pdamark.diff_phone(k)=0;else pdamark.diff_phone(k)=str2num(char(C{7}{j}));end;
        pdamark.drugname{k}=char(C{8}{j});
		pdamark.quantity{k}=char(C{9}{j});
		pdamark.actualusage{k}=char(C{10}{j});
		pdamark.route{k}=char(C{11}{j});
    end
    R.pdamark=pdamark;
    save([indir G.DIR.SEP files(i).name],'R');
    if ~isempty(pdamark)
        fprintf ('time=%s\tpid=%s\tsid=%s\t',R.METADATA.SESSION_STARTTIME,R.METADATA.PID ,R.METADATA.SID);
        fprintf('pdamark=%d\t',length(pdamark.matlabtime));
        fprintf('\n');
    end
    
end
end

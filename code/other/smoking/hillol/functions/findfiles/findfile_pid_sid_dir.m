function data=findfile_pid_sid_dir(G,pid,sid,INDIR)

indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' G.FILE.FRMTRAW_MATNAME];

if exist([indir G.DIR.SEP pid '_' sid '_' G.FILE.MODEL_MATNAME],'file')==2
    load([indir G.DIR.SEP pid '_' sid '_' G.FILE.MODEL_MATNAME]);
    data=M;
elseif exist([indir G.DIR.SEP pid '_' sid '_' G.FILE.FEATURE_MATNAME],'file')==2
    load([indir G.DIR.SEP pid '_' sid '_' G.FILE.FEATURE_MATNAME]);
    data=F;
elseif exist([indir G.DIR.SEP pid '_' sid '_' G.FILE.WINDOW_MATNAME],'file')==2
    load([indir G.DIR.SEP pid '_' sid '_' G.FILE.WINDOW_MATNAME]);
    data=W;
elseif exist([indir G.DIR.SEP pid '_' sid '_' G.FILE.BASICFEATURE_MATNAME],'file')==2
    load([indir G.DIR.SEP pid '_' sid '_' G.FILE.BASICFEATURE_MATNAME]);
    data=B;
elseif exist([indir G.DIR.SEP pid '_' sid '_' G.FILE.FRMTDATA_MATNAME],'file')==2
    load([indir G.DIR.SEP pid '_' sid '_' G.FILE.FRMTDATA_MATNAME]);
    data=D;
elseif exist([indir G.DIR.SEP pid '_' sid '_' G.FILE.FRMTRAW_MATNAME],'file')==2
        load([indir G.DIR.SEP infile]);
        data=R;
end
end
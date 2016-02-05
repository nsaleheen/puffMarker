function report_labsessions(G,pid,sid,in)
infile = [ pid '_' sid '_' G.FILE.FRMTDATA_MATNAME];
load ([G.DIR.DATA G.DIR.SEP in G.DIR.SEP infile]);
fid=fopen('C:\DataProcessingFramework\data\nida\report\labCues.csv','a'); 
for r=1:length(D.labstudy_mark.eventname)     % # of data point
    line=[pid ',' sid]; %subject number
    time=convert_timestamp_time(G,D.labstudy_mark.starttimestamp(r));
    [n s]=weekday(time);
    line=[line ',' s, ',' time(1:10) ',' time(12:19) ];    
    time2=convert_timestamp_time(G,D.labstudy_mark.endtimestamp(r));    
    line=[line ',' time(12:19) ',' char(D.labstudy_mark.eventname{r}) ];
    fprintf(fid,'%s\n',line);
end
fclose(fid);
end

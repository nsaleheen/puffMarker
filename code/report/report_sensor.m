function report_sensor(G,pid,sid,INDIR,OUTDIR,list_sensor)

outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
if isempty(dir(outdir))
    mkdir(outdir);
end

outfile=[pid '_' sid];
data=findfile_pid_sid_dir(G,pid,sid,INDIR);
for i=list_sensor
    x=[data.sensor{i}.sample;data.sensor{i}.timestamp]';
    outname=[outdir G.DIR.SEP outfile '_' INDIR '_' data.sensor{i}.NAME '.csv'];
    header={'sample','timestamp'};
    header_text=sprintf('%s,',header{:});
    header_text(end)='';
    dlmwrite(outname,header_text,'');
    dlmwrite(outname,x,'-append','precision','%.0f');    
end

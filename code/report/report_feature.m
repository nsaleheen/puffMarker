function report_feature(G,pid,sid,INDIR,OUTDIR,featureids)

indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[G.RUN.MODEL.STUDYTYPE '_' pid '_' sid '_' G.RUN.MODEL.NAME '_' G.FILE.FEATURE_MATNAME];
load([indir G.DIR.SEP infile]);

outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
if isempty(dir(outdir))
    mkdir(outdir);
end
[header,value,timestamp,matlabtime]=gen_feature_array(G,F,featureids,G.RUN.REPORT.FEATURELIST);
time_string=convert_timestamp_time(G,timestamp);
name=[];
for featureid=featureids
    name=[name '_' F.FEATURE{featureid}.SENSOR];
end
outfile=[G.RUN.MODEL.STUDYTYPE '_' pid '_' sid '_' G.RUN.MODEL.NAME name '_feature.csv'];
header_text=sprintf('%s,',header{:});
header_text=['time,timestamp,' header_text];
header_text(end)='';
fid=fopen([outdir G.DIR.SEP outfile],'w');
fprintf(fid,'%s\n',header_text);
for i=1:size(value,1)
    val=[];
    for j=1:size(value,2)
        val=[val,',',value{i,j}];
    end
    time=sprintf('%s,%s',time_string(i,:),num2str(timestamp(i)));
    val=[time,val];
    fprintf(fid,'%s\n',val);
end
fclose(fid);

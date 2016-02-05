function load_nida_pda_selfreport_new(G,pid,sid)

indir=[G.DIR.DATA G.DIR.SEP 'segment'];infile=[pid '_' sid '_segment.mat'];
if exist([indir G.DIR.SEP infile], 'file') ~= 2
    return;
end
load([indir G.DIR.SEP infile]);

load('nida_pda.mat');

files=dir(indir);
k=0;
pdamark=[];
for i=1:length(pda.ppid)
    if strcmp(pda.pid{i},pid)~=1, continue;end;
    if pda.actual_date_matlab(i)~=P.start_matlabtime, continue;end;
    k=k+1;
    pdamark.time{k}=pda.report_datetime_str{i};
    pdamark.timestamp(k)=convert_time_timestamp(G,pda.report_datetime_str{i});
    pdamark.matlabtime(k)=convert_timestamp_matlabtimestamp(G,pdamark.timestamp(k));
    
    pdamark.drugname{k}='Cocaine';
    pdamark.quantity{k}=pda.drugamount{i};
    pdamark.actualusage{k}=pda.drugactual{i};
    pdamark.route{k}=pda.drugroute{i};
    pdamark.actual_datetime_matlab(k)=pda.actual_datetime_matlab(k);
    pdamark.actual_datetime_str{k}=pda.actual_datetime_str{k};
    fprintf('yes\n');
end
P.pdamark=pdamark;
save([indir G.DIR.SEP infile],'P');

end

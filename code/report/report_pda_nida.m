function pda=report_pda_nida(filename)
pdaid=fopen(filename);
C=textscan(pdaid,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s','delimiter',',');
fclose(pdaid);
pda.pid=[];pda.ppid=[];pda.report_datetime_str=[];pda.actual_datetime_str=[];pda.actual_datetime_matlab=[];
pda.actual_date_matlab=[];pda.drugtype=[];pda.drugamount=[];pda.drugactual=[];pda.drugroute=[];
for i=2:length(C{1})
    i
    pid=C{1}{i};
    dates=C{4}{i};
    pda.pid{end+1}=pid;
    pda.ppid(end+1)=str2num(pid(2:end));
    pda.report_datetime_str{end+1}=datestr([C{4}{i} ' ' C{5}{i}],'mm/dd/yyyy HH:MM:SS');
    
    pda.actual_datetime_str{end+1}=C{7}{i};
    pda.actual_datetime_matlab(end+1)=datenum(C{7}{i});
    pda.actual_date_matlab(end+1)=datenum(C{7}{i},'mm/dd/yyyy');
    pda.drugtype{end+1}=C{8}{i};
    pda.drugamount{end+1}=C{9}{i};
    pda.drugactual{end+1}=C{10}{i};
    pda.drugroute{end+1}=C{11}{i};
end
end

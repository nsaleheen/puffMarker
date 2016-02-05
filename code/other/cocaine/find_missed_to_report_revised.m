function find_missed_to_report_revised(filename)
pdaid=fopen(filename);
C=textscan(pdaid,'%s %s %s %s %s %s','delimiter',',');
fclose(pdaid);
pda.pid=[];pda.ppid=[];pda.sid=[];
pda.urine=[];pda.pda=[];pda.date_matlab=[];
for i=2:length(C{1})
    i
    dates=C{3}{i};
    pda.pid{end+1}=C{1}{i};
    pda.ppid(end+1)=str2num(C{1}{i}(2:end)); 
    pda.sid{end+1}=C{2}{i};
    pda.urine(end+1)=str2num(C{6}{i});
    pda.date_matlab(end+1)=datenum(C{3}{i});
    pda.pda(end+1)=str2num(C{5}{i});
end

ind=find(pda.urine==1);
total=0;
for i=ind
    ppid=pda.ppid(i);
    date_matlab=pda.date_matlab(i);
    count=0;
    for j=0:5
        if i-j<=0, continue;end;
        if pda.ppid(i-j)==ppid && date_matlab-j==pda.date_matlab(i-j) && pda.pda(i-j)==0,
            count=count+1;
        end
    end
    if count==6, 
        fprintf('missed to report pid=%s  sid=%s\n',pda.pid{i}, pda.sid{i});
        total=total+1;
        pda.pda(i)=1;
    end
end
disp(total);
end
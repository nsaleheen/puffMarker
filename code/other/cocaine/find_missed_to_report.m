function find_missed_to_report(urine_pda)
ind=find(urine_pda.urine==1);
total=0;
for i=ind
    ppid=urine_pda.ppid(i);
    date_matlab=urine_pda.date_matlab(i);
    count=0;
    for j=1:4
        if i-j<=0, continue;end;
        if urine_pda.ppid(i-j)==ppid && date_matlab-j==urine_pda.date_matlab(i-j) && urine_pda.pda(i-j)==0,
            count=count+1;
        end
    end
    if count==4, 
        fprintf('missed to report pid=%s  date=%s\n',urine_pda.pid{i}, urine_pda.date_str{i});
        total=total+1;
        urine_pda.pda(i)=1;
    end
end
disp(total);
end
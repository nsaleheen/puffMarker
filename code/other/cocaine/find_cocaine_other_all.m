function res=find_cocaine_other_all(P,c_n,ppid)

res=[];now=0;
for i=1:length(P)
    if P{i}.mark<0, continue;end;
    if c_n=='n', if P{i}.mark==0, now=now+1;res{now}=P{i};res{now}.pid=ppid;end
    else
        if P{i}.mark==20 || P{i}.mark==40,
            flag=0;
            for j=1:i-1,
                if P{i}.mark==P{j}.mark,flag=1;end;
            end
            if flag==0, now=now+1;res{now}=P{i};res{now}.pid=ppid;
            end
        end
    end
end
end
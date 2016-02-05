function urine=report_urine(filename)
urineid=fopen(filename);
C=textscan(urineid,'%s %s %s %s %s %s %s %s %s %s %s %s','delimiter',',');
fclose(urineid);
urine=[];
cocaine=[];
date_str=[];
p=[];
for i=2:length(C{1})
    p(i)=str2num(C{2}{i});
    dates=C{3}{i};
    date_str{i}=datestr(dates,'mm/dd/yyyy');
    date_num(i)=datenum(date_str{i});
    if strcmpi(C{8}{i},'Not detect')==1
        cocaine(i)=-1;
    elseif strcmpi(C{8}{i},'Detected')==1
        cocaine(i)=1;
    else
        disp(['err=' num2str(i)]);
        cocaine(i)=0;
        continue;
    end
    if cocaine(i)==1,
        for j=1:4
            k=get_cocaine(urine,p(i),date_num(i)-j);
            if k==-5 || k==0 || k==1
                urine=set_cocaine(urine,p(i),date_num(i)-j,1);
            else break;
            end
        end
    elseif i>=2 && cocaine(i)==-1 && cocaine(i-1)==-1 && p(i)==p(i-1) && date_num(i)-date_num(i-1)<5
        for j=date_num(i-1):date_num(i)-1
            urine=set_cocaine(urine,p(i),j,-1);
        end
    elseif cocaine(i)==-1
        urine=set_cocaine(urine,p(i),date_num(i)-1,-1);
    else
        urine=set_cocaine(urine,p(i),date_num(i)-1,0);
    end
end
end
function c=get_cocaine(urine,pid,date_num,c)
c=-5;
if isempty(urine), return;end;
ind=find([urine.pid]==pid);
if isempty(ind)
    c=-5;
    return;
end
ind1=find([urine(ind).date]==date_num);
if isempty(ind1)
    c=-5;
else
    x=ind(ind1);
    c=urine(x).cocaine;
end
end
function urine=set_cocaine(urine,pid,date_num,c)
if isempty(urine)
    urine.pid=pid;
    urine.date=date_num;
    urine.cocaine=c;
    return;
end
ind=find([urine.pid]==pid);
if isempty(ind)
    urine(end+1).pid=pid;
    urine(end).date=date_num;
    urine(end).cocaine=c;
    return;
end
ind1=find([urine(ind).date]==date_num);
if isempty(ind1)
    urine(end+1).pid=pid;
    urine(end).date=date_num;
    urine(end).cocaine=c;
else
    x=ind(ind1);
%    if urine(x).cocaine~=c
%        disp([datestr(date_num) ' old=' num2str(urine(x).cocaine) ' now=' num2str(c)]);    
%    end
    urine(x).cocaine=c;
end
end
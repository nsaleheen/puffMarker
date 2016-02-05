function [actual,predict,prob]=TestSVM_parse_results_smoking(fname)
actual=[];predict=[];prob=[];
id=fopen(fname,'r');
now=0;
while 1
    line=fgetl(id);
    if line==-1, break;
    end;
    if isempty(line) continue; end;
    if ~isempty(regexp(line,' inst#'))
        break;
    end;
end;
b=0;s=0;
res=[];
while 1
    line=fgetl(id);
    if line==-1, break;end;
    if isempty(line) continue; end;
    now=now+1;
    [part,line]=strtok(line,' '); % number
    [part,line]=strtok(line,' ');actual{now}=part(3:end); % actual
    [part,line]=strtok(line,' ');predict{now}=part(3:end); % predict
    [part,line]=strtok(line,' '); if strcmp(part,'+')==1, [part,line]=strtok(line,' ');end; % +
    prob(now)=str2double(part); % probability
end;
fclose(id);
end

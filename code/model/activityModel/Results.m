function [b,s,res]=Results(filename,out1,out2)

fname=[filename,'.txt'];

id=fopen(fname,'r');
line=0;
count=0;
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
    if line==-1 break;
    end;
    if isempty(line) continue; end;
    if ~isempty(regexp(line,out1))
        res=[res,'0'];
        b=b+1;
    end
    if ~isempty(regexp(line,out2))
        s=s+1;
        res=[res,'1'];
    end;
end;
fclose(id);

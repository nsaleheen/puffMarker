function result=get_weka_results_smoking(fname)
result=[];


id=fopen(fname,'r');
line=0;
count=0;
while 1
    line=fgetl(id);
    if line==-1 break;
    end;
    if isempty(line) continue; end;
    if ~isempty(regexp(line,'=== Stratified cross-validation ==='))
        break;
    end;
end;
while 1
    line=fgetl(id);
    if line==-1 break;
    end;
    if isempty(line) continue; end;
    if ~isempty(regexp(line,'Correctly Classified Instances'))
        acc=textscan(line,'%s %s %s %d %f');
        %ind=find(line==' ');
        %i1=ind(end-1);
        %i2=ind(end);
        str=sprintf('Accuracy: %f',acc{5});
        result{1}=str;
        %disp(line);
        break;
    end;
end;
while 1
    line=fgetl(id);
    if line==-1 break;
    end;
    if isempty(line) continue; end;
    if ~isempty(regexp(line,'Kappa statistic'))
        %ind=find(line==' ');
        %i=ind(end);
        %str=sprintf('Kappa Value: %s',line(i+1:length(line)));
        acc=textscan(line,'%s %s %f');
        %ind=find(line==' ');
        %i1=ind(end-1);
        %i2=ind(end);
        str=sprintf('Kappa: %f',acc{3});
        result{2}=str;
        %disp(line);
        break;
    end;
end;
while 1
    line=fgetl(id);
    if line==-1 break;
    end;
    if isempty(line) continue; end;
    if ~isempty(regexp(line,'=== Confusion Matrix ==='))
        result{3}=line;
        %disp(line);
        line=fgetl(id);
        line=fgetl(id);
        result{4}=line;
        %disp(line);
        
        line=fgetl(id);
        result{5}=line;
        %disp(line);
        line=fgetl(id);
        result{6}=line;
        %disp(line);
        break;
    end;
end;

%line = fgetl(id)
%line = fgetl(id)
%line = fgetl(id)
%line = fgetl(id)
%{
%if (line==-1) break;
    if isempty(line),line='hello';end;
    if line~=-1
        if ~isempty(regexp(line,'Correctly Classified Instances'))

            ind=find(line==' ');
            i1=ind(end-1);
            i2=ind(end);
            disp(line(i1+1:i2-1));
        end;
    end;
end;
%}
fclose(id);
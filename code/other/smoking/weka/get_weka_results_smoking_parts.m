function [result,ACC,KAPPA,DETAIL,CONF]=get_weka_results_smoking_parts(fname)
result=[];
ACC=[];KAPPA=[];DETAIL=[];CONF=[];
if exist(fname,'file')~=2, return;end;
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
    end
    if ~isempty(regexp(line,'=== Error on test split ==='))
        break;
    end;
end;
while 1
    line=fgetl(id);
    if line==-1 break;
    end;
    if isempty(line) continue; end;
    if ~isempty(regexp(line,'Correctly Classified Instances')), acc=textscan(line,'%s %s %s %d %f');
        ACC=acc{5};str=sprintf('Accuracy: %f',acc{5});result{1}=str;
    end;
    if ~isempty(regexp(line,'Kappa statistic')), acc=textscan(line,'%s %s %f');
        KAPPA=acc{3};str=sprintf('Kappa: %f',acc{3});result{1}=str;
    end;
    if ~isempty(regexp(line,'               TP Rate   FP Rate   Precision   Recall  F-Measure   ROC Area  Class')),
        for ii=1:3
            line=fgetl(id);
            if ii~=3
                acc=textscan(line,'%f %f %f %f %f %f');
                now=1;
            else
                acc=textscan(line,'%s %s %f %f %f %f %f %f');
                now=3;
            end
            DETAIL(ii,1)=acc{now};
            DETAIL(ii,2)=acc{now+1};
            DETAIL(ii,3)=acc{now+2};
            DETAIL(ii,4)=acc{now+3};
            DETAIL(ii,5)=acc{now+4};
            DETAIL(ii,6)=acc{now+5};
        end
    end;
    if ~isempty(regexp(line,'=== Confusion Matrix ===')),
        result{3}=line;        
        line=fgetl(id);
        line=fgetl(id);
        result{4}=line;
        line=fgetl(id);
        acc=textscan(line,'%f %f');CONF(1,1)=acc{1};CONF(1,2)=acc{2};
        result{5}=line;
        line=fgetl(id);
        acc=textscan(line,'%f %f');CONF(2,1)=acc{1};CONF(2,2)=acc{2};
        
        result{6}=line;
        
    end
end;

fclose(id);

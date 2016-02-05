function datalabel=read_datalabel2(G, rawdir) %,starttime,endtime)
filelist=findfiles(rawdir,'ContextDataLabeling');

temp{1}=[];temp{2}=[];
noFile=size(filelist,2);
for i=1:noFile
    fileInfo = dir(filelist{i});
    if fileInfo.bytes==0
        continue;
    end
    fid = fopen(filelist{i});
    C = textscan(fid, '%s %s %s', 'delimiter', ',');
    fclose(fid);
    [row,col]=size(C{1});
    if row==0
        continue;
    end
    temp{1}=[temp{1};C{1}(1:row)];
    %temp{2}=[temp{2};C{3}(1:row)];
    temp{2}=[temp{2};C{2}(1:row)];
end
%remove the dupilcate entries
[t,m,n]=unique(temp{1});
temp{1}=temp{1}(m);
temp{2}=temp{2}(m);

[row,col]=size(temp);
if row==0
    return;
end
label.labelname=temp{2};%char(temp{2});
label.labeltime=str2double(temp{1});
%{
ind=find(label.labeltime>=starttime & label.labeltime<=endtime);
if isempty(ind)
    return;
end
label.labelname=label.labelname(ind,:);
label.labeltime=label.labeltime(ind);
%}
[row,col]=size(label.labelname);
%R.datalabel(.start=[];
%R.datalabel.end=[];
%raw.datalabel.label=[];
labelno=0;
for r=1:row
    ind=findlabelindex(G,label.labelname(r));
    if ind==0
        continue;
    end
    starttime=label.labeltime(r);
    endtime=starttime;
    labeltext=G.LABEL.DATALABEL(ind).LABEL;
    
    endstr=G.LABEL.DATALABEL(ind).END;
    endd=strcmpi(endstr,label.labelname(r+1:row,:));
    ind=find(endd==1);
    if(~isempty(ind))
        endtime=label.labeltime(ind(1)+r);
    end
    labelno=labelno+1;
    datalabel(labelno).starttime=starttime;
    datalabel(labelno).endtime=endtime;
    
    datalabel(labelno).starttimeM=convert_timestamp_matlabtimestamp(G,starttime);
    datalabel(labelno).endtimeM=convert_timestamp_matlabtimestamp(G,endtime);
    
    datalabel(labelno).label=labeltext;
end
end

function ind = findlabelindex(G,labeltext)
labelno=length(G.LABEL.DATALABEL);
ind=0;
for l=1:labelno
    if strcmpi(G.LABEL.DATALABEL(l).START,labeltext)
        ind=l;
        return;
    end
end
end

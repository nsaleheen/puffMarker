function labstudy_mark=read_labstudymark(G,rawdir,starttimestamp,endtimestamp)

labstudy_mark.sessionname=[];
labstudy_mark.eventname=[];
labstudy_mark.starttimestamp=[];
labstudy_mark.endtimestamp=[];
labstudy_mark.start_matlabtime=[];
labstudy_mark.end_matlabtime=[];

filelist=findfiles(rawdir,G.FILE.DBNAME);
noFile=size(filelist,2);
extractdb=ExtractDatabase;
filename=tempname;
[a,filename,c]=fileparts(filename);
if isempty(dir([G.DIR.ROOT G.DIR.SEP 'data' G.DIR.SEP 'temp']))
    mkdir([G.DIR.ROOT G.DIR.SEP 'data' G.DIR.SEP 'temp']);
end

filename=[G.DIR.ROOT G.DIR.SEP 'data' G.DIR.SEP 'temp' G.DIR.SEP filename];

parameter{1}='-i';
parameter{3}='-o';        parameter{4}=filename;
parameter{5}='-s';        parameter{6}=num2str(int64(starttimestamp));
parameter{7}='-e';        parameter{8}=num2str(int64(endtimestamp));
parameter{9}='-t';        parameter{10}=G.LABSTUDY.MARK.DB_TABLE;
if isempty(dir(filename))
else
    delete(filename);
end

all=[];

temp{1}=[];temp{2}=[];temp{3}=[];temp{4}=[];
for i=1:noFile
    fileInfo = dir(filelist{i});
    if fileInfo.bytes==0
        continue;
    end
    parameter{2}=filelist{i};
    try
        extractdb.extractdb(parameter);
    catch err
    end
    if isempty(dir(filename))
        continue;
    end
    fileInfo = dir(filename);
    if fileInfo.bytes==0
        delete(filename);
        continue;
    end
    fid = fopen(filename);
    C = textscan(fid, '%s %s %s %s %s', 'delimiter', ',');
    fclose(fid);
    delete(filename);
    
    [row,col]=size(C{1});
    if row==0
        continue;
    end
    temp{1}=[temp{1};C{2}(2:row)];
    temp{2}=[temp{2};C{3}(2:row)];
    temp{3}=[temp{3};C{4}(2:row)];
    temp{4}=[temp{4};C{5}(2:row)];
end
row=length(temp{1});
if row>0
    labstudy_mark.sessionname=temp{1};
    labstudy_mark.eventname=temp{2};
    labstudy_mark.starttimestamp=str2double(temp{4}(:));
    labstudy_mark.endtimestamp=str2double(temp{4}(:));
end
ind=find(labstudy_mark.starttimestamp>=starttimestamp & labstudy_mark.starttimestamp<=endtimestamp);
labstudy_mark.sessionname=labstudy_mark.sessionname(ind);
labstudy_mark.eventname=labstudy_mark.eventname(ind);
labstudy_mark.starttimestamp=labstudy_mark.starttimestamp(ind);
labstudy_mark.endtimestamp=labstudy_mark.endtimestamp(ind);

ind=find(labstudy_mark.endtimestamp>=starttimestamp & labstudy_mark.endtimestamp<=endtimestamp);
labstudy_mark.sessionname=labstudy_mark.sessionname(ind);
labstudy_mark.eventname=labstudy_mark.eventname(ind);
labstudy_mark.starttimestamp=labstudy_mark.starttimestamp(ind);
labstudy_mark.endtimestamp=labstudy_mark.endtimestamp(ind);
temp_labstudy_mark=labstudy_mark;
labstudy_mark.sessionname=[];labstudy_mark.eventname=[];
labstudy_mark.starttimestamp=[];labstudy_mark.endtimestamp=[];
labstudy_mark.start_matlabtime=[];labstudy_mark.end_matlabtime=[];
count=0;
for r=1:length(temp_labstudy_mark.starttimestamp)
    flag=0;
    for i=1:r-1
        if temp_labstudy_mark.starttimestamp(r)==temp_labstudy_mark.starttimestamp(i) && temp_labstudy_mark.endtimestamp(r)==temp_labstudy_mark.endtimestamp(i)
            flag=1;
            break;
        end
    end
    if flag==0
        count=count+1;
        labstudy_mark.sessionname{count}=temp_labstudy_mark.sessionname{r};
        labstudy_mark.eventname{count}=temp_labstudy_mark.eventname{r};
        labstudy_mark.starttimestamp(count)=temp_labstudy_mark.starttimestamp(r);
        labstudy_mark.endtimestamp(count)=temp_labstudy_mark.endtimestamp(r);
    end
end
labstudy_mark.start_matlabtime=convert_timestamp_matlabtimestamp(G,labstudy_mark.starttimestamp);
labstudy_mark.end_matlabtime=convert_timestamp_matlabtimestamp(G,labstudy_mark.endtimestamp);

end

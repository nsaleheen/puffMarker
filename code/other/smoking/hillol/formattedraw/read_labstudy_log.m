function labstudy_log=read_labstudy_log(G,rawdir,starttimestamp,endtimestamp)

labstudy_log.text=[];
labstudy_log.timestamp=[];
labstudy_log.matlabtime=[];


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
parameter{9}='-t';        parameter{10}=G.LABSTUDY.LOG.DB_TABLE;
if isempty(dir(filename))
else
    delete(filename);
end

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
    C = textscan(fid, '%s %s %s', 'delimiter', ',');
    fclose(fid);
    delete(filename);
    
    row=size(C{1},1);
    if row==0
        continue;
    end
    temp{1}=[temp{1};C{2}(2:row)];
    temp{2}=[temp{2};C{3}(2:row)];
end
row=size(temp,1);
if row>0
    labstudy_log.text=temp{2}';
    labstudy_log.timestamp=str2double(temp{1}(:)');
end
ind=find(labstudy_log.timestamp>=starttimestamp & labstudy_log.timestamp<=endtimestamp);
labstudy_log.text=labstudy_log.text(ind);
labstudy_log.timestamp=labstudy_log.timestamp(ind);
labstudy_log.matlabtime=convert_timestamp_matlabtimestamp(G,labstudy_log.timestamp);
end

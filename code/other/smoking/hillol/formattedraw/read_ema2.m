function ema=read_ema2(G,rawdir,starttimestamp,endtimestamp, metadataTable)

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
parameter{9}='-t';        parameter{10}='ema';
if isempty(dir(filename))
else
    delete(filename);
end
all=[];

for i=1:noFile
    fileInfo = dir(filelist{i});
    if fileInfo.bytes==0
        continue;
    end
    parameter{2}=filelist{i};
    if i==1
        ema=read_ema_metadata2(parameter,extractdb,metadataTable);
        if length(ema.METADATA.VALUE)==0
            continue;
        end
    end
    parameter{10}=ema.METADATA.VALUE{1}{2}; % 'ema'
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
    tline = fgets(fid);
    if i==1
        ema.HEADER=textscan(tline,'%s','delimiter',',');
    end
    tline = fgets(fid);
    while ischar(tline)
        %        disp(tline)
        b=textscan(tline,'%s','delimiter',',');
        %        timestamp=[timestamp;str2num(b{1}{5})];
        all=[all;b{1}'];
        tline = fgets(fid);
    end
    timestamp=str2num(cell2mat(all(:,5)));
    [t1,iall,iorg]=unique(timestamp);
    all=all(iall,:);
    
    if ~isempty(dir(filename))
        fclose(fid);
        delete(filename);
    end
end
if isempty(all)
    ema.data=[];
else
    timestamp=str2num(cell2mat(all(:,5)));
    ind=find(timestamp>=starttimestamp & timestamp<=endtimestamp);
    %all=all(ind,:);
    ema.data=all(ind,:);
end
end

function ema=read_ema_metadata2(parameter,extractdb, tableName)
parameter{10}=tableName;
filename=parameter{4};
try
    extractdb.extractdb(parameter);
catch err
end
if isempty(dir(filename))
    return;
end
fileInfo = dir(filename);
if fileInfo.bytes==0
    delete(filename);
    return;
end
fid = fopen(filename);
tline = fgets(fid);
ema.METADATA.HEADER=textscan(tline,'%s','delimiter',',');
tline = fgetl(fid);
all=[];
while ischar(tline)
    all=[all ' ' tline];
    %        timestamp=[timestamp;str2num(b{1}{5})];
    tline = fgetl(fid);
end
if ~isempty(all)
    ema.METADATA.VALUE=textscan(all,'%s','delimiter',',');
end
fclose(fid);
delete(filename);

end

function ema_count=report_ema_count(G,pid,curdir)
filelist=findfiles(curdir,G.FILE.DBNAME);
noFile=size(filelist,2);
ema_count=[];
extractdb=ExtractDatabase;
filename=tempname;
[a,filename,c]=fileparts(filename);

if isempty(dir([G.DIR.ROOT G.DIR.SEP 'data' G.DIR.SEP 'temp']))
    mkdir([G.DIR.ROOT G.DIR.SEP 'data' G.DIR.SEP 'temp']);
end
filename=[G.DIR.ROOT G.DIR.SEP 'data' G.DIR.SEP 'temp' G.DIR.SEP filename];

for i=1:noFile
    fileInfo = dir(filelist{i});
    if fileInfo.bytes==0
        continue;
    end
    parameter{1}='-i';        parameter{2}=filelist{i};
    parameter{3}='-o';        parameter{4}=filename;
    parameter{5}='-s';        parameter{6}=num2str(0);
    parameter{7}='-e';        parameter{8}=num2str(2999999999999);
    parameter{9}='-t';        parameter{10}='ema_count';
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
    Nrows = numel(textread(filename,'%1c%*[^\n]'));
    a=textread(filename,'%s');
    if Nrows<1, delete(filename);continue,end;
    ema_count.value=csvread(filename,1,0);
    ema_count.META=a{1};
    delete(filename);
    
end
end


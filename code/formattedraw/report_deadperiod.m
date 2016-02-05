function deadperiod=report_deadperiod(G,pid,curdir)
filelist=findfiles(curdir,G.FILE.DBNAME);
noFile=size(filelist,2);
deadperiod.set_timestamp=[];deadperiod.name=[];deadperiod.timestamp=[];
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
    parameter{9}='-t';        parameter{10}='deadperiod';
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
    if Nrows<2, delete(filename);continue,end;
    
    for i=2:Nrows
        remain=a{i};
        [str,remain]=strtok(remain,',');id=str2num(str);
        [str,remain]=strtok(remain,',');set_timestamp=str2num(str);
        [name,remain]=strtok(remain,',');
        [str,remain]=strtok(remain,',');timestamp=str2num(str);
        flag=0;
        d=length(deadperiod.set_timestamp);
        for k=1:d
            if set_timestamp==deadperiod.set_timestamp(k) && strcmp(name,deadperiod.name{k})==1 && timestamp==deadperiod.timestamp(k)
                flag=1;break;
            end
        end
        
        if flag==0, d=d+1;deadperiod.set_timestamp(d)=set_timestamp;deadperiod.name{d}=name;deadperiod.timestamp(d)=timestamp;end;
    end
    
    delete(filename);
    
end
end


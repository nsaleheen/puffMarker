function [labstudy_info]=report_labstudy(G,pid,curdir)

timelog_fid=fopen([curdir G.DIR.SEP G.FILE.REPORT_LABSTUDY],'w');

filelist=findfiles(curdir,G.FILE.DBNAME);
noFile=size(filelist,2);

labstudy_info=[];

temp{1}=[];temp{2}=[];temp{3}=[];temp{4}=[];
symbols = ['a':'z' 'A':'Z' '0':'9'];
nums = randi(numel(symbols),[1 8]);
filename = symbols (nums);

[a,filename,c]=fileparts(filename);
if isempty(dir([G.DIR.ROOT G.DIR.SEP 'data' G.DIR.SEP 'temp']))
    mkdir([G.DIR.ROOT G.DIR.SEP 'data' G.DIR.SEP 'temp']);
end

filename=[G.DIR.ROOT G.DIR.SEP 'data' G.DIR.SEP 'temp' G.DIR.SEP filename];

extractdb=ExtractDatabase;
parameter{1}='-i';
parameter{3}='-o';        parameter{4}=filename;
parameter{5}='-s';        parameter{6}='0';
parameter{7}='-e';        parameter{8}='2000000000000';
parameter{9}='-t';        parameter{10}='labstudy_log';
L=0;
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
    
    [row,col]=size(C{1});
    if row==0
        continue;
    end
    for l=2:row
        if strcmp('Program Starts',C{3}{l})==1
            starttime=C{2}{l};
            L=L+1;
            labstudy_info(L,1)=str2num(starttime);
            labstudy_info(L,2)=str2num(starttime);
        else
            endtime=C{2}{l};
            labstudy_info(L,2)=str2num(endtime);
        end
    end
end
labstudy_info=unique(labstudy_info,'rows');
timelog_fid=fopen([curdir G.DIR.SEP G.FILE.REPORT_LABSTUDY],'w');
[L,c]=size(labstudy_info);
for i=1:L
    start_time=labstudy_info(i,1);
    end_time=labstudy_info(i,2);
    startTimeStr=convert_timestamp_time(G,start_time);
    endTimeStr=convert_timestamp_time(G,end_time);
    
    s=sprintf('lab,start,%s,end,%s,duration(min)=%6.1f',...
    startTimeStr,endTimeStr,(end_time-start_time)/(1000*60));
    fprintf(timelog_fid,'%s\r\n',s);
end
fclose(timelog_fid);
end

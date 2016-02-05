function selfreport=read_selfreport(G,rawdir,starttimestamp,endtimestamp)

filelist=findfiles(rawdir,G.FILE.DBNAME);
filename=tempname;
[a,filename,c]=fileparts(filename);
if isempty(dir([G.DIR.ROOT G.DIR.SEP 'data' G.DIR.SEP 'temp']))
    mkdir([G.DIR.ROOT G.DIR.SEP 'data' G.DIR.SEP 'temp']);
end

filename=[G.DIR.ROOT G.DIR.SEP 'data' G.DIR.SEP 'temp' G.DIR.SEP filename];

noFile=size(filelist,2);
extractdb=ExtractDatabase;
parameter{1}='-i';
parameter{3}='-o';        parameter{4}=filename;
parameter{5}='-s';        parameter{6}=num2str(int64(starttimestamp));
parameter{7}='-e';        parameter{8}=num2str(int64(endtimestamp));
parameter{9}='-t';
for sno=G.RUN.FRMTRAW.SELFREPORTLIST
    parameter{10}=G.SELFREPORT.ID(sno).DB_TABLE;

    selfreport{sno}.NAME=G.SELFREPORT.ID(sno).NAME;
    selfreport{sno}.METADATA=G.SELFREPORT.ID(sno);
    selfreport{sno}.timestamp=[];
    selfreport{sno}.matlabtime=[];
    
    all=[];
    
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
        
        temp=csvread(filename,1,2:2);
        delete(filename);        
        [row,col]=size(temp);
        if row==0
            continue;
        end
        all=[all;temp(:,1:col-1)];
        all=unique(all,'rows');

        all=all(all>=starttimestamp & all<=endtimestamp);
    end
    row=size(all,1);
    if row>0
        selfreport{sno}.timestamp=all(:);
        if issorted(selfreport{sno}.timestamp)==0
            selfreport{sno}.timestamp=sort(selfreport{sno}.timestamp);
        end
        selfreport{sno}.matlabtime=convert_timestamp_matlabtimestamp(G,selfreport{sno}.timestamp);
    end
end
end


function selfreport=read_selfreport_smokingposition(G,pid,sid,rawdir,data)
indir=[G.DIR.DATA G.DIR.SEP rawdir G.DIR.SEP pid];

starttimestamp=data.starttimestamp;endtimestamp=data.endtimestamp;

filelist=findfiles(indir,G.FILE.DBNAME);
filename=sprintf('DPF%i.mat',sum(floor(1000*clock)));
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
    selfreport{sno}.label=[];
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
        all=[all;temp(:,1:col)];
        all=unique(all,'rows');

        all=all(all(:,1)>=starttimestamp & all(:,1)<=endtimestamp,:);
    end
    row=size(all,1);
    if row>0
        selfreport{sno}.timestamp=all(:,1);
        label1=all(:,2);
        label=all(:,2);
        if issorted(selfreport{sno}.timestamp)==0
            [selfreport{sno}.timestamp,I]=sort(selfreport{sno}.timestamp);
            label(I)=label1;
        end
        selfreport{sno}.matlabtime=convert_timestamp_matlabtimestamp(G,selfreport{sno}.timestamp);
        for l=1:length(label)
            if label(l)==1, selfreport{sno}.label{l}='standing';
            elseif label(l)==2, selfreport{sno}.label{l}='walking';
            elseif label(l)==3, selfreport{sno}.label{l}='sitting';
            elseif label(l)==4, selfreport{sno}.label{l}='driving';
            else selfreport{sno}.label{l}='lying';
            end
        end
    end
end
data.selfreport=selfreport;

end


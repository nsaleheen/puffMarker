function sensor=read_sensordb(G,indir,starttimestamp,endtimestamp)%rawdir,starttime,endtime,day,totalDays,R)

filelist=findfiles(indir,G.FILE.DBNAME);
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
parameter{9}='-t';

for sno=G.RUN.FRMTRAW.SENSORLIST_DB
    parameter{10}=G.SENSOR.ID(sno).DB_TABLE;
    sensor{sno}.NAME=G.SENSOR.ID(sno).NAME;
    sensor{sno}.METADATA=G.SENSOR.ID(sno);
    all=[];
    for i=1:noFile
        %for i=actualFiles
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
        %%%%%%%%%%%%%checking whether it has more than one lines
        Nrows = numel(textread(filename,'%1c%*[^\n]'));
       
        if Nrows<2, delete(filename);continue,end;
        temp=csvread(filename,2,0);
        delete(filename);

        temp=sortrows(temp,2);           %to adjust the timestamp misalignment
        [row,col]=size(temp);
        if row==0
            continue;
        end
        all=[all;temp(:,1:col)];
        %all=unique(all,'rows');
        %%%%%%%%remove duplicates%%%%%%%%%%%%%%%%%%
        negetiveInd=find(diff(all(:,2))<0);
        if length(negetiveInd)>0
            duplicate_ind=[];
            for i=1:length(negetiveInd)
                duplicate_ind=[duplicate_ind ;find(all(negetiveInd(i),2)==all(:,2))];
            end
            all=[all(1:duplicate_ind(1),:);all(duplicate_ind(end)+1:end,:)];
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        all=all(find(all(:,2)>=starttimestamp & all(:,2)<=endtimestamp),:);
    end
    [row,col]=size(all);
    
    if row>0
        newSamples=[];
        if row>100000        %break into smaller segment to avoid java heap space overflow.
            nSegment=ceil(row/100000);
            for i=1:nSegment-1
                newSamples=[newSamples;PhoneAccelTimestampCorrection(all((i-1)*100000+1:i*100000,:))];
            end
            newSamples=[newSamples;PhoneAccelTimestampCorrection(all((nSegment-1)*100000+1:end,:))];
        else
            newSamples=[newSamples;PhoneAccelTimestampCorrection(all)];
        end
        sensor{sno}.sample=newSamples(:,1)';
        sensor{sno}.timestamp=newSamples(:,2)';
    end
   
end
end


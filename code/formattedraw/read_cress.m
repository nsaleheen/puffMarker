function cress=read_cress(G,indir,starttimestamp,endtimestamp)

for day=1:10
    fileList = findfiles([indir G.DIR.SEP 'day' int2str(day)],G.FILE.CRESS_FILE_NAME);
    if length(fileList) >0
        dirCresLatestFileList = fileList;
    else
        fprintf('{day%d}',day-1);
        break;
    end
end

startTimeMatlabTime=convert_timestamp_matlabtimestamp(G,starttimestamp);
endTimeMatlabTime=convert_timestamp_matlabtimestamp(G,endtimestamp);

%filelist=findfiles(dirCresLatest,G.FILE.CRESS_FILE_NAME);
filelist=finduniquefiles(dirCresLatestFileList);%finduniquefiles(filelist); % Same file can be multiple times. Only take unique ones
noFile=size(filelist,2);

for i=1:noFile
    fileInfo = dir(filelist{i});
    if fileInfo.bytes==0
        continue;
    end
    fid=fopen(filelist{i});
    tline = fgets(fid); %reading header file
    cress.HEADER=textscan(tline,'%s','delimiter',char(9));  %save header to a structure. header is delimited by tab
    C=textscan(fid,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s','delimiter',char(9)); %read data
    fclose(fid);
    ind=find(datenum(C{12})>=startTimeMatlabTime & datenum(C{13})<=endTimeMatlabTime);
    cress.data=[];
    
    if ~isempty(ind)
        C=[C{1}(ind,:) C{2}(ind,:) C{3}(ind,:) C{4}(ind,:) C{5}(ind,:) C{6}(ind,:) C{7}(ind,:) C{8}(ind,:) C{9}(ind,:) C{10}(ind,:) C{11}(ind,:) C{12}(ind,:) C{13}(ind,:) C{14}(ind,:) C{15}(ind,:) C{16}(ind,:) C{17}(ind,:) C{18}(ind,:) C{19}(ind,:) C{20}(ind,:) C{21}(ind,:) C{22}(ind,:) C{23}(ind,:)];
        cress.data=C(:,1:9); %save cress data to structure
        [r c]=size(C);
        C10_11=[];   %column 10 and 11 are together. we split them into two columns
        for ii=1:r%length(ind)
            text=char(C(ii,10));
            tt=textscan(text,'%s%s','delimiter','T');
            if isempty(tt{2})
                tt=textscan(text,'%s%s','delimiter','F');
                tt{2}=cellstr(['F' char(tt{2})]);
            else
                tt{2}=cellstr(['T' char(tt{2})]);
            end
            C10_11=[C10_11;tt];
        end
        C10=[C10_11{:,1}];
        C11=[C10_11{:,2}];
        cress.data=[cress.data C10' C11' C(:,11:end)];
    end
end




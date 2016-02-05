function adminmark=load_jhu_pda_labreport(G,INDIR)
indir=[G.DIR.DATA G.DIR.SEP INDIR];

adminmark=[];
filename=[G.DIR.DATA G.DIR.SEP 'studyinfo' G.DIR.SEP 'jhu_pda_labreport.csv'];
if exist(filename, 'file') ~= 2, disp('FILE NOT FOUND'), return;end

fileID = fopen(filename);
C = textscan(fileID,'%s %s %s %s %s %s','delimiter',',');
list_pid=C{1,1};
fclose(fileID);

files=dir(indir);
for i=3:length(files)
    data=load([indir G.DIR.SEP files(i).name]);
    varname=fieldnames(data);
    pid=data.(varname{1}).METADATA.PID;
    k=0;
    adminmark=[];
    
    for j=1:length(C{1})
        if strcmp(C{1}{j},pid)~=1, continue; end
        tm=convert_time_timestamp(G,datestr(datenum(C{3}{j}),G.TIME.FORMAT));
        if tm~=data.(varname{1}).starttimestamp, continue; end
        timestr=[char(C{3}{j}) ' ' char(C{4}{j})];
        timestr=datestr(timestr,G.TIME.FORMAT);
        timestamp=convert_time_timestamp(G,timestr);
        k=k+1;
        adminmark.time{k}=timestr;
        adminmark.timestamp(k)=timestamp;
        adminmark.matlabtime(k)=convert_timestamp_matlabtimestamp(G,timestamp);
        adminmark.dose(k)=str2num(C{5}{j});
        adminmark.zonisamide(k)=str2num(C{6}{j});
        adminmark.sessionname{k}=C{2}{j};
    end
    data.(varname{1}).adminmark=adminmark;
    save([indir G.DIR.SEP files(i).name],'-struct', 'data',(varname{1}));
    if ~isempty(data.(varname{1}).adminmark) || ~isempty(data.(varname{1}).labstudy_mark)
        fprintf ('time=%s\tpid=%s\tsid=%s\t',data.(varname{1}).METADATA.SESSION_STARTTIME,data.(varname{1}).METADATA.PID ,data.(varname{1}).METADATA.SID);
        if ~isempty(adminmark)
            fprintf('adminmark=%d\t',length(adminmark.time));
        end
        if ~isempty(data.(varname{1}).labstudy_mark.starttimestamp)
            fprintf('labstudy_mark=%d\t',length(data.(varname{1}).labstudy_mark.starttimestamp));        
        end
        fprintf('\n');
    end
end
end

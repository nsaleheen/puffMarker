function urine_pda=combine_urine_pda(filename,urine,pda)
fileID = fopen(filename,'w');
all=ls('C:\DataProcessingFramework\data\nida\basicfeature');
urine_pda.pid=[];
urine_pda.ppid=[];
urine_pda.sid=[];
urine_pda.date_str=[];
urine_pda.date_matlab=[];
urine_pda.ecg=[];
urine_pda.aclx=[];
urine_pda.rip=[];
urine_pda.pda=[];
urine_pda.urine=[];
plist=[1,3,4,6,8,9,12,14,15,18,19,21,27,28,34,38,39,41,42,44];
for i=3:size(all,1)
    pid=all(i,1:3);
    sid=all(i,5:7);
    disp(all(i,:));
    ppid=str2num(pid(2:end));
    a=find(plist==ppid);if isempty(a), continue;end;
    str=['C:\DataProcessingFramework\data\NIDA\basicfeature\' all(i,:)];
    str=strtrim(str);
    load(str);
    pda_count=0;
    for p=1:length(pda.ppid)
        if pda.ppid(p)==ppid && B.METADATA.SESSION_STARTMATLABTIME==pda.actual_date_matlab(p)
            pda_count=pda_count+1;
        end
    end
    cocaine=0;
    for u=1:length(urine)
        if urine(u).pid==ppid && B.METADATA.SESSION_STARTMATLABTIME==urine(u).date
            cocaine=urine(u).cocaine;
        end
    end
    if ~isempty(B.sensor{2}.sample)
        fprintf(fileID,'%s,%s,%s,%f,%d,%d\n',pid,sid,B.METADATA.SESSION_STARTTIME,length(B.sensor{2}.sample)/(64*60*60),pda_count,cocaine);
    else
        fprintf(fileID,'%s,%s,%s,%f,%d,%d\n',pid,sid,B.METADATA.SESSION_STARTTIME,0,pda_count,cocaine);
    end
    urine_pda.pid{end+1}=pid;
    urine_pda.ppid(end+1)=ppid;
    urine_pda.sid{end+1}=sid;
    urine_pda.date_str{end+1}=datestr(B.METADATA.SESSION_STARTMATLABTIME,'mm/dd/yyyy');
    urine_pda.date_matlab(end+1)=B.METADATA.SESSION_STARTMATLABTIME;    
    urine_pda.ecg(end+1)=length(B.sensor{2}.sample);
    urine_pda.aclx(end+1)=length(B.sensor{4}.sample);
    urine_pda.rip(end+1)=length(B.sensor{1}.sample);
    urine_pda.pda(end+1)=pda_count;
    urine_pda.urine(end+1)=cocaine;
end
fclose(fileID);
end
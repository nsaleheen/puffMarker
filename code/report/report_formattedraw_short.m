function [header,data]=report_formattedraw_short(G,INDIR,OUTDIR,PS_LIST)
data=[];d=0;
header=[];
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
if isempty(dir(outdir))
    mkdir(outdir);
end
fid=fopen([outdir G.DIR.SEP G.STUDYNAME '_report_frmtraw_short.csv'],'w');
header=get_header(G);fprintf(fid,'%s\n',header);
pno=size(PS_LIST);
for p=1:pno
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        line=[];
        fprintf(['report_fortmattedraw_short pid=' pid ' sid=' sid '\n']);
        indir=[G.DIR.DATA G.DIR.SEP INDIR];
        infile=[pid '_' sid '_' G.FILE.FRMTRAW_MATNAME];
        load([indir G.DIR.SEP infile]);
        datee=convert_timestamp_time(G,R.starttimestamp);
        datee=datee(1:10);
        d=d+1;
        if strfind(header,'pid'),data(d).pid=pid;line=pid;end;
        if strfind(header,'sid'),data(d).sid=sid;line=[line ',' sid];end;
        if strfind(header,'date'),data(d).date=datee;line=[line ',' datee];end;
        
        if strfind(header,'EMA'),
            [numberOfEMAtriggered,numberOfEMAanswered]=getEMAcountFromFRMTRAW(R);
            if strfind(header,'triggered'),data(d).ematrig=numberOfEMAtriggered;line=[line ',' num2str(numberOfEMAtriggered)];end;
            if strfind(header,'answered'),data(d).emaans=numberOfEMAanswered;line=[line ',' num2str(numberOfEMAanswered)];end;
        end
        
        for i=1:length(G.SELFREPORT.ID)
            if strfind(header,G.SELFREPORT.ID(i).NAME),
                data(d).selfreport(i)=length(R.selfreport{i}.timestamp);
                line=[line ',' num2str(length(R.selfreport{i}.timestamp))];
            end
        end
        if isfield(G.REPORT.SHORT.FRMTRAW,'SENSOR'),
            for i=1:length(G.REPORT.SHORT.FRMTRAW.SENSOR)
                if isempty(G.REPORT.SHORT.FRMTRAW.SENSOR{i}), continue;end;
                if strfind(G.REPORT.SHORT.FRMTRAW.SENSOR{i},'wear'),
                    weartime=getWearingTimeFromFRMTRAW(R.sensor{i}.timestamp)/60/60;
                    line=[line ',' num2str(weartime)];
                    data(d).sensor(i).wear=weartime;
                end
                if strfind(G.REPORT.SHORT.FRMTRAW.SENSOR{i},'start'),
                    if isempty(R.sensor{i}.timestamp),line=[line ',0'];data(d).sensor(i).starttimestamp=0;
                    else line=[line, ',' convert_timestamp_time(G,R.sensor{i}.timestamp(1))];data(d).sensor(i).starttimestamp=R.sensor{i}.timestamp(1);
                    end
                end
                if strfind(G.REPORT.SHORT.FRMTRAW.SENSOR{i},'end'),
                    if isempty(R.sensor{i}.timestamp),line=[line ',0'];data(d).sensor(i).starttimestamp=0;
                    else line=[line, ',' convert_timestamp_time(G,R.sensor{i}.timestamp(end))];data(d).sensor(i).starttimestamp=R.sensor{i}.timestamp(end);
                    end
                end
                if strfind(G.REPORT.SHORT.FRMTRAW.SENSOR{i},'miss'),
                missingRate=getMissingRateFromFRMTRAW(R.sensor{i}.timestamp,G.SENSOR.ID(i).FREQ);
                line=[line ',' num2str(missingRate)];
                    data(d).sensor(i).miss=missingRate;
                end
            end
        end
        fprintf(fid,'%s\n',line);
    end
end
fclose(fid);
end

function [numberOfEMAtriggered,numberOfEMAanswered]=getEMAcountFromFRMTRAW(R)
numberOfEMAtriggered=0;
numberOfEMAanswered=0;
if ~isfield(R,'ema'), return;end;
if isfield(R.ema,'data') && ~isempty(R.ema.data)
    s=size(R.ema.data);
    numberOfEMAtriggered=s(1);
    lastColumn=R.ema.data(:,length(R.ema.data));  %check whether they replied upto the final question
    for i=1:length(lastColumn)
        if str2num(lastColumn{i})~=-1
            numberOfEMAanswered=numberOfEMAanswered+1;
        end
    end
end
end
function missingRate=getMissingRateFromFRMTRAW(timestamps,samplingRate)
totalDuration=getWearingTimeFromFRMTRAW(timestamps);
expectedSamples=totalDuration*samplingRate;
totalSamples=length(timestamps);
missingRate=100-100*(totalSamples/expectedSamples);
end
function wearingDuration=getWearingTimeFromFRMTRAW(timestamps)
wearingDuration=0;
if ~isempty(timestamps)
    d=diff(timestamps)/1000/60;
    pos=find(d>10);
    for i=1:length(pos)+1
        if isempty(pos)
            wearingDuration=(timestamps(end)-timestamps(1))/1000;
            break;
        end
        
        if i==1
            wearingDuration=wearingDuration+(timestamps(pos(i))-timestamps(1))/1000;
        elseif i==length(pos)+1
            wearingDuration=wearingDuration+(timestamps(end)-timestamps(pos(i-1)+1))/1000;
        else
            wearingDuration=wearingDuration+(timestamps(pos(i))-timestamps(pos(i-1)+1))/1000;
        end
    end
end
end

function header=get_header(G)
header=G.REPORT.SHORT.FRMTRAW.BASIC;

if isfield(G.REPORT.SHORT.FRMTRAW,'EMA'),
    header=[header ',' G.REPORT.SHORT.FRMTRAW.EMA];
end

if isfield(G.REPORT.SHORT.FRMTRAW,'SELFREPORT'),
    header=[header ',' G.REPORT.SHORT.FRMTRAW.SELFREPORT];
end
if isfield(G.REPORT.SHORT.FRMTRAW,'SENSOR'),
    for i=1:length(G.REPORT.SHORT.FRMTRAW.SENSOR)
        if ~isempty(G.REPORT.SHORT.FRMTRAW.SENSOR{i})
            header=[header ',' G.REPORT.SHORT.FRMTRAW.SENSOR{i}];
        end
    end
end    
end

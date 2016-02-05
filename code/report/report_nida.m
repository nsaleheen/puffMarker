function report_nida(G,INDIR,INFODIR,OUTDIR,PS_LIST)

%[header,data]=report_formattedraw_short(G,INDIR,OUTDIR,PS_LIST);
load('data.mat');
data=read_wear_dates(G,INFODIR,data);
data=read_pdadata(G,INFODIR,data);
data=read_urineprofile(G,INFODIR,data);

oid=fopen([G.DIR.DATA G.DIR.SEP OUTDIR G.DIR.SEP 'nida_full.csv'],'w');
for i=1:length(data)
    data(i).timestamp=convert_time_timestamp(G,datestr(data(i).date,G.TIME.FORMAT));
end
dfields = fieldnames(data);
dcell = struct2cell(data);
sz = size(dcell);
dcell = reshape(dcell, sz(1), []);
dcell = dcell';
dcell=sortrows(dcell,[1,16]);
dcell = reshape(dcell', sz);
dsorted = cell2struct(dcell, dfields, 1);
header='Participant,Week,sid,Date,Available Data(RIP),Missing Rate(RIP),EMA(Triggered),EMA(Answered),Report(Smoking),Report(Craving),Drug Usage Time(Start),Drug Usage Time(End),Quantity,Actual Use,Route of Administration,urine_ampecs,urine_barb,urine_benzsc,urine_thc,urine_coc,urine_methadon,urine_cod';
fprintf(oid,'%s\n',header);
for i=1:length(dsorted)
    line=dsorted(i).pid;
    if ~isempty(dsorted(i).wid),line=[line ',' dsorted(i).wid];else line=[line ','];end;
    if ~isempty(dsorted(i).sid),line=[line ',' dsorted(i).sid];else line=[line ','];end;    
    line=[line ',' dsorted(i).date];
    if isfield(dsorted(i).sensor,'wear')==0 || isempty(dsorted(i).sensor(1).wear),line=[line ',']; else line=[line ',' num2str(dsorted(i).sensor(1).wear)];end
    if isfield(dsorted(i).sensor,'miss')==0 || isempty(dsorted(i).sensor(1).miss),line=[line ',']; else line=[line ',' num2str(dsorted(i).sensor(1).miss)];end

    if isempty(dsorted(i).ematrig), line=[line ','];else line=[line ',' num2str(dsorted(i).ematrig)];end
    if isempty(dsorted(i).emaans), line=[line ','];else line=[line ',' num2str(dsorted(i).emaans)];end
    if isempty(dsorted(i).selfreport), line=[line ',,'];else line=[line ',' num2str(dsorted(i).selfreport(G.SELFREPORT.SMKID)),',',num2str(dsorted(i).selfreport(G.SELFREPORT.CRVID))];end;
    if isempty(dsorted(i).drugstarttime), line=[line ','];else line=[line ',' num2str(dsorted(i).drugstarttime)];end
    if isempty(dsorted(i).drugendtime), line=[line ','];else line=[line ',' num2str(dsorted(i).drugendtime)];end
    if isempty(dsorted(i).drugtype), line=[line ','];else line=[line ',' dsorted(i).drugtype];end
    if isempty(dsorted(i).drugamount), line=[line ','];else line=[line ',' dsorted(i).drugamount];end
    if isempty(dsorted(i).drugactual), line=[line ','];else line=[line ',' dsorted(i).drugactual];end
    if isempty(dsorted(i).drugroute), line=[line ','];else line=[line ',' dsorted(i).drugroute];end
    if isempty(dsorted(i).urine), line=[line ','];else line=[line ',' dsorted(i).urine.ampecs];end
    if isempty(dsorted(i).urine), line=[line ','];else line=[line ',' dsorted(i).urine.barb];end
    if isempty(dsorted(i).urine), line=[line ','];else line=[line ',' dsorted(i).urine.benzsc];end
    if isempty(dsorted(i).urine), line=[line ','];else line=[line ',' dsorted(i).urine.thc];end
    if isempty(dsorted(i).urine), line=[line ','];else line=[line ',' dsorted(i).urine.coc];end
    if isempty(dsorted(i).urine), line=[line ','];else line=[line ',' dsorted(i).urine.methadon];end
    if isempty(dsorted(i).urine), line=[line ','];else line=[line ',' dsorted(i).urine.ampecs];end
    fprintf(oid,'%s\n',line);
end
fclose(oid);
end

function data=read_pdadata(G,INFODIR,data)
pdaid=fopen([G.DIR.DATA G.DIR.SEP INFODIR G.DIR.SEP 'nida_pda_selfreport.csv']);
C=textscan(pdaid,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s','delimiter',',');
fclose(pdaid);
for i=2:length(C{1})
    pid=C{1}{i};
    dates=C{4}{i};
    found=0;
    
    for d=1:length(data)
        if strcmpi(data(d).pid,pid)~=1,continue;end;
        if strcmpi(datestr(data(d).date,'mm/dd/yyyy'),datestr(dates,'mm/dd/yyyy'))~=1, continue;end
        found=1;
        if isfield(data(d),'drugtime')==0 || isempty(data(d).drugtime),
            data(d).drugstarttime=C{5}{i};data(d).drugendtime=C{6}{i};
            data(d).drugtype=C{8}{i};data(d).drugamount=C{9}{i};
            data(d).drugactual=C{10}{i};data(d).drugroute=C{11}{i};
        else
            data(d).drugstarttime=[data(d).drugstarttime ';' C{5}{i}];data(d).drugendtime=[data(d).drugendtime, ';' C{6}{i}];
            data(d).drugtype=[data(d).drugtype ';' C{8}{i}];data(d).drugamount=[data(d).drugamount ';' C{9}{i}];
            data(d).drugactual=[data(d).drugactual ';' C{10}{i}];data(d).drugroute=[data(d).drugroute ';' C{11}{i}];
        end
    end
    if found==0,
        data(end+1).pid=pid;
        data(end).date=datestr(dates,'mm/dd/yyyy');
        data(end).drugstarttime=C{5}{i};data(end).drugendtime=C{6}{i};
        data(end).drugtype=C{8}{i};data(end).drugamount=C{9}{i};
        data(end).drugactual=C{10}{i};data(end).drugroute=C{11}{i};
        
    end
end
end

function data=read_wear_dates(G,INFODIR,data)
wearid=fopen([G.DIR.DATA G.DIR.SEP INFODIR G.DIR.SEP 'weardate.csv']);
C=textscan(wearid,'%s %s %s %s %s','delimiter',',');
fclose(wearid);
for i=2:length(C{1})
    pid=sprintf('p%02d',str2num(C{1}{i}));
    
    for w=2:5
        wid=sprintf('w%02d',w-1);
        str=C{w}{i};
        loc=strfind(str,'-');
        startstr=str(1:loc-1);
        endstr=str(loc+1:end);
        start_m=datenum(startstr);
        end_m=datenum(endstr);        
        for j=start_m:+1:end_m
            found=0;
            for d=1:length(data)
                if strcmpi(data(d).pid,pid)~=1,continue;end;
                if strcmpi(datestr(data(d).date,'mm/dd/yyyy'),datestr(j,'mm/dd/yyyy'))~=1, continue;end
                data(d).wid=wid;
                found=1;
            end
            if found==0,
                data(end+1).pid=pid;
                data(end).wid=wid;
                data(end).date=datestr(j,'mm/dd/yyyy');
            end
        end
    end
end
end
function data=read_urineprofile(G,INFODIR,data)
urineid=fopen([G.DIR.DATA G.DIR.SEP INFODIR G.DIR.SEP 'urineprofile.csv']);
C=textscan(urineid,'%s %s %s %s %s %s %s %s %s %s %s %s','delimiter',',');
fclose(urineid);
for i=2:length(C{1})
    pid=sprintf('p%02d',str2num(C{2}{i}));
    dates=C{3}{i};
    
    for d=1:length(data)
        if strcmpi(data(d).pid,pid)~=1,continue;end;
        if strcmpi(datestr(data(d).date,'mm/dd/yyyy'),datestr(dates,'mm/dd/yyyy'))~=1, continue;end
        data(d).urine.ampecs=C{4}{i};
        data(d).urine.barb=C{5}{i};
        data(d).urine.benzsc=C{6}{i};
        data(d).urine.thc=C{7}{i};
        data(d).urine.coc=C{8}{i};
        data(d).urine.methadon=C{9}{i};
        data(d).urine.cod=C{10}{i};
        data(d).urine.pcp=C{11}{i};
    end
end
end


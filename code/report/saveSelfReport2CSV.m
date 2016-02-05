function saveSelfReport2CSV(G,pid,sid,selfReportID)
DST2012start=1331452798000; %should come from config file
infile = [ pid '_' sid '_' G.FILE.FRMTDATA_MATNAME];
load ([G.DIR.DATA G.DIR.SEP 'formatteddata' G.DIR.SEP infile]);
if selfReportID==2
    fid=fopen('C:\Users\mmrahman\Desktop\NIDA\FinalAugust13\NIDA_SmokingSelfReport_p01_21_20130801.csv','a'); %should come from config file
end
if selfReportID==3
    fid=fopen('C:\Users\mmrahman\Desktop\NIDA\FinalAugust13\NIDA_CravingSelfReport_p01_21_20130801.csv','a'); %should come from config file
end
%fprintf(fid,'%s\n','participant,weekday,date,time');

if isfield(D.selfreport{selfReportID},'timestamp')
    for i=1:length(D.selfreport{selfReportID}.timestamp)
        if D.selfreport{selfReportID}.timestamp<DST2012start
            TIME.TIMEZONE = -5;
        else
            TIME.TIMEZONE = -4;
        end
        dateTime=convert_timestamp_time(G, D.selfreport{selfReportID}.timestamp(i));
        [n day]=weekday(dateTime);
        line=[pid ',' day ',' dateTime(1:10) ',' dateTime(12:end)];
        fprintf(fid,'%s\n',line);
    end
end
fclose(fid);
end

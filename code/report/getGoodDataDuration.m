function ValidRipDuration=getGoodDataDuration(G,pid,sid)
% infile = [ G.DIR.SESSIONTYPE_NAME(1) '_' pid '_' sid '_' G.FILE.FRMTDATA_MATNAME];
infile = [pid '_' sid '_' G.FILE.FRMTDATA_MATNAME];
load ([G.DIR.DATA G.DIR.SEP 'formatteddata' G.DIR.SEP infile]);
ValidRipDuration=length(D.sensor{1}.sample)/21.33/60/60;  %duration in hours
ValidEcgDuration=length(D.sensor{2}.sample)/64/60/60;  %duration in hours

if ValidRipDuration<1 && ValidEcgDuration<1
    return
end
%fid=fopen('C:\Users\smhssain\Desktop\JHU_RipEcgValidMinutes.csv','a');
%fid=fopen('C:\Users\mmrahman\Desktop\NIDA_RipEcgValidMinutes_and_EMA.csv','a');
% fid=fopen('C:\Users\mmrahman\Desktop\NIDA\nida_RipEcgValidMinutes_and_EMA_20130629.csv','a');
% fid=fopen('C:\Users\mmrahman\Desktop\NIDA\nida_RipEcgValidMinutes_and_EMA_20130722.csv','a');
% fid=fopen('C:\Users\mmrahman\Desktop\NIDA\FinalAugust13\nida_RipEcgValidMinutes_and_EMA_20130801.csv','a');
fid=fopen('C:\Users\mmrahman\Desktop\NIDA\nida_RipEcgValidMinutes_and_EMA_p99.csv','a');
%dateTime=convert_timestamp_time(D.sensor{1}.timestamp(1));
emaTriggered=length(D.ema.data);
emaResponded=0;
for i=1:emaTriggered
	if D.ema.data(i).status==0
		emaResponded=emaResponded+1;
	end
end
day=[];
date=[];
if ~isempty(D.sensor{1}.timestamp)
    dateTime=convert_timestamp_time(G, D.sensor{1}.timestamp(1));
    [n day]=weekday(dateTime);
    date=dateTime(1:10);
end
        
line=[pid ',' day ',' date ',' num2str(ValidRipDuration) ',' num2str(ValidEcgDuration) ',' num2str(emaTriggered) ',' num2str(emaResponded)];
%line=[pid ',' sid ',' num2str(ValidRipDuration) ',' num2str(ValidEcgDuration)];
fprintf(fid,'%s\n',line);
fclose(fid);
end

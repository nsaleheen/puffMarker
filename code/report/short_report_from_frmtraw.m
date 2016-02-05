function short_report_from_frmtraw(G,indir,outdir,PS_LIST)

dates=datestr(date,'yyyymmddTHHMMSS');

OUTDIR=[G.DIR.DATA G.DIR.SEP outdir];
mkdir(OUTDIR);
fid=fopen([OUTDIR G.DIR.SEP 'short_report_' G.STUDYNAME '_' dates(1:8) '.csv'],'w');
header='subject,session,date,day,wearTime,respMissRate,ecgMissRate,smokingSelfRep,cravingSelfRep,EMAtriggered,EMAanswered';
fprintf(fid,'%s\n',header);

pno=size(PS_LIST);
for p=1:pno
	pid=char(PS_LIST{p,1});
	slist=PS_LIST{p,2};
	for s=slist
		sid=char(s);
        [datee,day,totalWearingTime_hr,rip_missingRate,ecg_missingRate,smokingSelfRep,cravingSelfRep,drinkingSelfRep,numOfEMA_trigger,numOfEMA_answer]=short_report_on_each_day(G,pid,sid,indir);
        line=[pid ',' sid ',' datee ',' day ',' num2str(totalWearingTime_hr) ',' num2str(rip_missingRate) ',' num2str(ecg_missingRate) ',' num2str(smokingSelfRep) ',' num2str(cravingSelfRep) ',' num2str(numOfEMA_trigger) ',' num2str(numOfEMA_answer)];
        fprintf(fid,'%s\n',line);
    end
end
fclose(fid);       

function MemphisEMA=saveEMA2Structure(pid,sid,MemphisEMA)
global DIR FILE
%infile = [ DIR.SESSIONTYPE_NAME(1) '_' pid '_' sid '_' FILE.FRMTDATA_MATNAME];
infile = [ DIR.SESSIONTYPE_NAME(1) '_' pid '_' sid '_' FILE.FRMTRAW_MATNAME];
load ([DIR.FORMATTEDRAW DIR.SEP infile]);

%[row col]=size(D.ema.data);
[row col]=size(R.ema.data);
a=[1,2,4,8,16,32,64,128,256,512,1024,2048];
%fid=fopen(['C:\Users\mmrahman\Desktop\NIDA_Results\EMA\' pid '_' sid '_ema.csv'],'w'); 
%create header of the file
participant=str2num(pid(2:end));
day=str2num(sid(2:end));
%MemphisEMA=[];

for r=1:row  
    questions=1;
    MemphisEMA.participant(participant).session(day).ema(r).triggertype=R.ema.data(r,2);
    MemphisEMA.participant(participant).session(day).ema(r).context=R.ema.data(r,3);
    
    for c=14:2:col
        
        MemphisEMA.participant(participant).session(day).ema(r).question(questions).timestamp=char(R.ema.data(r,c+1));
        MemphisEMA.participant(participant).session(day).ema(r).question(questions).response=[];
        %line=[num2str(r) ','];
        %line=[line num2str(questions) ',' char(R.ema.data(r,c+1))];
        if ~isempty(str2num(char(R.ema.data(r,c))))
            val=str2num(char(R.ema.data(r,c)));
            for i=1:length(a) 
                if val>=a(i)
                    if bitand(a(i),val)
                        %line=[line ',' num2str(i)];
                        MemphisEMA.participant(participant).session(day).ema(r).question(questions).response=[MemphisEMA.participant(participant).session(day).ema(r).question(questions).response i];
                    end
                end
            end
        else
            %line=[line ',' char(R.ema.data(r,c))];
            MemphisEMA.participant(participant).session(day).ema(r).question(questions).response=[MemphisEMA.participant(participant).session(day).ema(r).question(questions).response char(R.ema.data(r,c))];
        end
        %fprintf(fid,'%s\n',line);
        questions=questions+1;
    end
end
%fclose(fid);

end




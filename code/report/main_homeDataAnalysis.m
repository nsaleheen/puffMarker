%calculate home duration
%calculate not home duration
%calculate average disconnection per minute
%perform statistical test, whether the two mean are different
%not home duration = total system on duration - home duration
%total system on duration should come from the formatted raw data.

function [homeData]=main_homeDataAnalysis(G,pid,sid,INDIR,OUTDIR,homeData)
indir=[G.DIR.DATA G.DIR.SEP INDIR G.DIR.SEP pid];
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];

session_def_filename=[indir G.DIR.SEP G.FILE.SESSION_DEF];
fid=fopen(session_def_filename,'r');
tline = fgetl(fid);

while ischar(tline)
    parts = textscan(tline,'%s','delimiter',',');
    parts = parts{1};
    ix = find(strcmp(parts, 'pid'));pid=parts{ix+1};
    ix = find(strcmp(parts, 'sid'));sid_now=parts{ix+1};
    ix = find(strcmp(parts, 'start'));starttimestr=parts{ix+1};
    ix = find(strcmp(parts, 'end'));endtimestr=parts{ix+1};
    tline = fgetl(fid);
    if strcmp(sid_now,sid)~=1, continue;end;
    fprintf('%-6s %-6s %-20s Task (',pid,sid,'main_formattedraw');
    
    starttimestamp=convert_time_timestamp(G,starttimestr);
    endtimestamp=convert_time_timestamp(G,endtimestr);
    
    %outfile=[pid '_' sid '_' G.FILE.FRMTRAW_MATNAME];
    outfile=[pid '_' sid '_home_data_analysis.mat' ];
    
    if isempty(dir([outdir G.DIR.SEP outfile])) || G.RUN.FRMTRAW.LOADDATA==0, R=[];
    else load([outdir G.DIR.SEP outfile]);end
    
    R.NAME=['[' G.STUDYNAME ' ' pid ' ' sid ']'];
    R.METADATA.SESSION_STARTTIME=starttimestr;
    R.METADATA.SESSION_ENDTIME=endtimestr;
    R.METADATA.SESSION_STARTTIMESTAMP=starttimestamp;
    R.METADATA.SESSION_ENDTIMESTAMP=endtimestamp;
    R.METADATA.SESSION_STARTMATLABTIME=convert_timestamp_matlabtimestamp(G,starttimestamp);
    R.METADATA.SESSION_ENDMATLABTIME=convert_timestamp_matlabtimestamp(G,endtimestamp);
    
    R.METADATA.STUDYNAME=G.STUDYNAME;
    R.METADATA.PID=pid;
    R.METADATA.SID=sid;
    R.starttimestamp=starttimestamp;
    R.endtimestamp=endtimestamp;
    
    R.start_matlabtime=convert_timestamp_matlabtimestamp(G,R.starttimestamp);
    R.end_matlabtime=convert_timestamp_matlabtimestamp(G,R.endtimestamp);
        
    homeDur=0; notHomeDur=0; disconnHome=0; disconnNotHome=0;
    
    [homeDur,notHomeDur,disconnHome,disconnNotHome]=getHomeAnalysis(G,pid,sid,indir,starttimestamp,endtimestamp);
    homeData=[homeData; str2num(pid(2:end)) str2num(sid(2:end)) homeDur notHomeDur disconnHome disconnNotHome];   
   end
fclose(fid);
end

function [homeDur notHomeDur disconnHome disconnNotHome]=getHomeAnalysis(G,pid,sid,indir,starttimestamp,endtimestamp)

filelist=findfiles(indir,G.FILE.TOS_NAME);
filelist=finduniquefiles(filelist); % Same file can be multiple times. Only take unique ones
noFile=size(filelist,2);

load(['C:\DataProcessingFramework\data\memphis\formattedraw\' pid '_' sid '_frmtraw.mat']);
timeDiff=diff(R.sensor{1}.timestamp);
chunkInd=find(timeDiff>60*5*1000);  %more than 5 minutes of band off are considered intentional
TotalSystemOnDuration=0;
if ~isempty(chunkInd)
for i=1:length(chunkInd)
    if i==1
        TotalSystemOnDuration=TotalSystemOnDuration+(R.sensor{1}.timestamp(chunkInd(i))-R.sensor{1}.timestamp(1))/1000;
    elseif i==length(chunkInd)
        TotalSystemOnDuration=TotalSystemOnDuration+(R.sensor{1}.timestamp(end)-R.sensor{1}.timestamp(chunkInd(i)))/1000;
    else
        TotalSystemOnDuration=TotalSystemOnDuration+(R.sensor{1}.timestamp(chunkInd(i))- R.sensor{1}.timestamp(chunkInd(i-1)+1))/1000;
    end
end
else
    if(length(R.sensor{1}.timestamp))>0
        TotalSystemOnDuration=(R.sensor{1}.timestamp(end)-R.sensor{1}.timestamp(1))/1000;
    end
end

homeDur=0; notHomeDur=0; 
disconnHome=0; disconnNotHome=0;
Home=csvread('C:\DataProcessingFramework\data\memphis\raw\HomeNotDriving_raw.csv');
indP=find(Home(:,1)==str2num(pid(2:end)));
indPD=find(Home(indP,3)>=starttimestamp & Home(indP,3)<=endtimestamp);
for i=1:length(indPD)
   homeDur=homeDur+(Home(indP(i),4)- Home(indP(i),3))/1000;
end

notHomeDur=TotalSystemOnDuration-homeDur;

for i=1:noFile
    fileTimestamp=str2num(filelist{1}(end-12:end));
    if ~isempty(indPD)
        for j=1:length(indPD)
            ind=find(fileTimestamp>=Home(indP(j),3) & fileTimestamp<=Home(indP(j),4));
            if ~isempty(ind)
                disconnHome=disconnHome+1;
                break;
            end
        end
    else
        disconnNotHome=disconnNotHome+1;
    end
end

end

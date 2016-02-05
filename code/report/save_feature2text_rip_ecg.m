function save_feature2text_rip_ecg(G,pid,sid,INDIR,OUTDIR) 
%create header of the file
%global FILE DIR SENSOR

% infile = [G.DIR.SESSIONTYPE_NAME(1) '_' pid '_' sid '_stress60_' G.FILE.FEATURE_MATNAME];
% load ([G.DIR.FEATURE G.DIR.SEP infile]);

% indir=[G.DIR.DATA G.DIR.SEP INDIR];
indir=INDIR;
% infile=[pid '_' sid '_stress60_' G.FILE.FEATAURE_MATNAME];
% infile=['field_' pid '_' sid '_drug60_feature'];
infile=['field_' pid '_' sid '_stress60_feature'];
% infile=['field_' pid '_' sid '_drug60_feature'];

outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
% outfile=[G.RUN.MODEL.STUDYTYPE '_' pid '_' sid '_' G.RUN.MODEL.NAME '_' G.FILE.WINDOW_MATNAME];
load ([indir G.DIR.SEP infile]);
% header='subject number,Date,Time,Weekday,Activity';
 %nF=length(F.sensor(2).FEATURENAME);
 nF=12;     %number of ECG features
% for i=1:nF
%     header=[header ',' char(F.sensor(2).FEATURENAME(i))];
% end

% filename='ecg_features_20130405'
% filename='rip_20130801_f22_f41';
% filename='ecg_rip_p01_p21_final';
% filename='ecg_rip_memphis_p14_s14';
%filename='ecg_rip_p01_p21_Nov2013';
filename='ecg_rip_p24_3';

% name=['C:\DataProcessingFramework\data\nida\report\features_' filename '.csv'];
name=[outdir  G.DIR.SEP 'features_' filename '.csv'];
fid=fopen(name,'a');
% fprintf(fid,'%s\n',header);
count=0;
for i=1:length(F.window)
    i
    %if isfield(F.window,'starttimestamp')
    noEcgRip=0;
    %defining the output structure
    numberOfColumn=41;  %change it according to the number of column in the report
    for l=1:numberOfColumn
        line{l}='-9999';
    end
    c=1;
    time=convert_timestamp_time(G,F.window(i).starttimestamp);
    line{c}=pid; c=c+1;
    [n s]=weekday(convert_timestamp_matlabtimestamp(G,F.window(i).starttimestamp));
    line{c}=num2str(F.window(i).starttimestamp);c=c+1;line{c}=time(1:10);c=c+1;line{c}=[time(12:17) '00'];c=c+1;line{c}=s;c=c+1;
    
    if F.window(i).feature{G.FEATURE.R_RIPID}.quality==0 || F.window(i).feature{G.FEATURE.R_ECGID}.quality==0
        time=convert_timestamp_time(G,F.window(i).starttimestamp);
        if ~isempty(time)
%             line=[pid ','];
%             line{c}=pid; c=c+1;
            [n s]=weekday(convert_timestamp_matlabtimestamp(G,F.window(i).starttimestamp));
%             line=[line num2str(F.window(i).starttimestamp) ',' time(1:10) ',' time(12:17) '00' ',' s ];
%             line{c}=num2str(F.window(i).starttimestamp);c=c+1;line{c}=time(1:10);c=c+1;line{c}=[time(12:17) '00'];c=c+1;line{c}=s;c=c+1;
            val='';
            if isfield(F.window(i).feature{G.FEATURE.R_ACLID},'value')
%                 if ~isempty(F.window(i).feature{4}.value)
%                     if F.window(i).feature{4}.value{30}>0.21384
%                         val='Yes';
%                     else
%                         val='No';
%                     end
%                 end
                  activity=hasPhysicalActivity(str2num(pid(2:end)),str2num(sid(2:end)),F.window(i).starttimestamp,F.window(i).endtimestamp);
                  if activity==1
                      val='1';
%                   elseif activity==0
%                       val='No';
                  else
                      val='0';
                  end
            end
%             line=[line ',' val];
            line{c}=val;c=c+1;
            %check the self-report within the window time
            val='';
            isSelfReport=isSelfreportInBetween(F,F.window(i).starttimestamp,F.window(i).endtimestamp,G.SELFREPORT.SMKID);  %smoking self-report
            if isSelfReport==1
                val='1';
            else
                val='0';
            end
%             line=[line ',' val];
            line{c}=val;c=c+1;
            
            val='';
            isSelfReport=isSelfreportInBetween(F,F.window(i).starttimestamp,F.window(i).endtimestamp,G.SELFREPORT.CRVID);  %smoking self-report
            if isSelfReport==1
                val='1';
            else
                val='0';
            end
%             line=[line ',' val];
            line{c}=val;c=c+1;
            
            val='';
            countBeforeECG=c;
            if isfield(F.window(i).feature{2},'value') && ~isempty(cell2mat(F.window(i).feature{2}.value))
                flag=0;
%                 line=[line ',' num2str(length(F.window(i).sensor{G.SENSOR.R_ECGID}.rr.timestamp))];
                line{c}=num2str(length(F.window(i).sensor{G.SENSOR.R_ECGID}.rr.timestamp));c=c+1;
                for f=2:nF
                    if ~isempty(F.window(i).feature) && ~isempty(F.window(i).feature{2}.value{1})
                        if F.window(i).feature{2}.value{nF}>500 && flag==0
                            disp('invalid heart rate')
                            flag=1;
                        end
%                         line=[line ',' num2str(F.window(i).feature{2}.value{f})];
                            line{c}=num2str(F.window(i).feature{2}.value{f});c=c+1;
                    end
                end
            else
                noEcgRip=noEcgRip+1;
%                 line=[line ','];
%                 for f=2:nF
                    %line=[line ',' val];
%                     line=[line ',' '-9999'];  %outlier marker
%                 end
            end
            
            val='';
            featureSet=[22:41];  %id of respiration features to consider
            c=countBeforeECG+nF;        %pointer jumps to the RIP feature writing position
            if isfield(F.window(i).feature{G.FEATURE.R_RIPID},'value') && isfield(F.window(i).sensor{G.SENSOR.R_RIPID},'peakvalley')
%                 line=[line ',' num2str(length(F.window(i).sensor{G.SENSOR.R_RIPID}.peakvalley.timestamp))];
                line{c}=num2str(length(F.window(i).sensor{G.SENSOR.R_RIPID}.peakvalley.timestamp));c=c+1;
                for f=featureSet
                    if ~isempty(F.window(i).feature) && ~isempty(F.window(i).feature{G.FEATURE.R_RIPID}.value)
%                         line=[line ',' num2str(F.window(i).feature{G.FEATURE.R_RIPID}.value{f})];
                        line{c}=num2str(F.window(i).feature{G.FEATURE.R_RIPID}.value{f});c=c+1;
                    end
                end
%                 fprintf(fid,'%s\n',line);
            else
                noEcgRip=noEcgRip+1;
%                 line=[line ','];
%                 for k=1:length(featureSet)
                    %line=[line ',' val];
%                     line=[line ',' '-9999'];  %outlier marker
%                 end
            end
%             if noEcgRip~=2
%                 fprintf(fid,'%s\n',line);
%             else
%                 noEcgRip
%             end
        end
     end
     newline=[line{1}];
     for k=2: numberOfColumn
         newline=[newline ',' line{k}];
     end
     fprintf(fid,'%s\n',newline);
end
fclose(fid);
end

function isSelfReport=isSelfreportInBetween(F,starttime,endtime,selfreportId)
    isSelfReport=0;
    if length(F.selfreport{selfreportId}.timestamp)>0
        for j=1:length(F.selfreport{selfreportId}.timestamp)
            if F.selfreport{selfreportId}.timestamp(j)>=starttime && F.selfreport{selfreportId}.timestamp(j)<=endtime
                isSelfReport=1;
                return;
            end
        end
    end
end

function activity=hasPhysicalActivity(pid,sid,starttime,endtime)
    activity=-1;
    physicalActivity=csvread('c:\dataProcessingFramework\data\nida\report\activityEpisodes\activityEpisodes_v2_p24.csv');
    ind=find(physicalActivity(:,1)==pid & physicalActivity(:,2)==sid);
    if isempty(ind)
        return
    end
    activityOfTheDay=physicalActivity(ind);
    ind2=find(physicalActivity(:,3)>=starttime & physicalActivity(:,4)<=endtime);
    
    if isempty(ind2)
        return
    end
    activity=physicalActivity(ind2(end),5);  
end
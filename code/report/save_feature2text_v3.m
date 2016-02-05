function save_feature2text_v3(G,pid,sid,INDIR,OUTDIR) 
%create header of the file
%global FILE DIR SENSOR

% infile = [G.DIR.SESSIONTYPE_NAME(1) '_' pid '_' sid '_stress60_' G.FILE.FEATURE_MATNAME];
% load ([G.DIR.FEATURE G.DIR.SEP infile]);

indir=[G.DIR.DATA G.DIR.SEP INDIR];
%infile=[pid '_' sid '_stress60_' G.FILE.FEATAURE_MATNAME];
infile=['field_' pid '_' sid '_drug60_feature'];
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
% outfile=[G.RUN.MODEL.STUDYTYPE '_' pid '_' sid '_' G.RUN.MODEL.NAME '_' G.FILE.WINDOW_MATNAME];
load ([indir G.DIR.SEP infile]);
% header='subject number,Date,Time,Weekday,Activity';
 %nF=length(F.sensor(2).FEATURENAME);
 nF=12;
% for i=1:nF
%     header=[header ',' char(F.sensor(2).FEATURENAME(i))];
% end

% filename='ecg_features_20130405'
filename='rip_20130801';

% name=['C:\DataProcessingFramework\data\nida\report\features_' filename '.csv'];
name=[outdir  G.DIR.SEP 'features_' filename '.csv'];
fid=fopen(name,'a');
% fprintf(fid,'%s\n',header);
for i=1:length(F.window)
    i
    %if isfield(F.window,'starttimestamp')
     if F.window(i).feature{2}.quality==0
        time=convert_timestamp_time(G,F.window(i).starttimestamp);
        if ~isempty(time)
            line=[pid ','];
            [n s]=weekday(time);
            line=[line time(1:10) ',' time(12:17) '00' ',' s ];
            val='';
            if isfield(F.window(i).feature{4},'value')
                if ~isempty(F.window(i).feature{4}.value)
                    if F.window(i).feature{4}.value{30}>0.21384
                        val='Yes';
                    else
                        val='No';
                    end
                end
            end
            line=[line ',' val];
            if isfield(F.window(i).feature{2},'value')
                for f=2:nF
                    if ~isempty(F.window(i).feature) && ~isempty(F.window(i).feature{2}.value{1})
                        line=[line ',' num2str(F.window(i).feature{2}.value{f})];
                    end
                end
                fprintf(fid,'%s\n',line);
            end
        end
    end
end
fclose(fid);

% count=0;
% for i=1:1440 
%     if isfield(F.window(i).feature{4},'value') && F.window(i).feature{4}.value(27)<.692
%         
%         count=count+1;
%     end
% end;
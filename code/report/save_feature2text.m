function save_feature2text(G,pid,sid,INDIR,OUTDIR) 
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
filename='rip_ecg';

% name=['C:\DataProcessingFramework\data\nida\report\features_' filename '.csv'];
name=[outdir  G.DIR.SEP 'features_' filename '.csv'];
fid=fopen(name,'a');
% fprintf(fid,'%s\n',header);
for i=1:length(F.window)
    i
    %if isfield(F.window,'starttimestamp')
     if F.window(i).feature{G.FEATURE.R_RIPID}.quality==0 || F.window(i).feature{G.FEATURE.R_ECGID}.quality==0
        [smoking craving]=selfReportOrNot(F,F.window(i).starttimestamp,F.window(i).endtimestamp);
        smokingReport='';
        cravingReport='';
        if smoking==1
            smokingReport='Yes';
        else
            smokingReport='No';
        end
         if craving==1
            cravingReport='Yes';
        else
            cravingReport='No';
        end
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
            line=[line ',' val ',' smokingReport ',' cravingReport];
            if isfield(F.window(i).feature{2},'value') || isfield(F.window(i).feature{G.FEATURE.R_RIPID},'value')
                for f=2:nF
                    if ~isempty(F.window(i).feature) && isfield(F.window(i).feature{2},'value') && ~isempty(F.window(i).feature{2}.value{1})
                        line=[line ',' num2str(F.window(i).feature{2}.value{f})];
                    else
                        line=[line ','];
                    end
                    
                end
%                 fprintf(fid,'%s\n',line);
%             end
%             if isfield(F.window(i).feature{G.FEATURE.R_RIPID},'value')
                featureSet=[22:41];  %id of features to consider
                for f=featureSet
                    if ~isempty(F.window(i).feature) && isfield(F.window(i).feature{G.FEATURE.R_RIPID},'value') && ~isempty(F.window(i).feature{G.FEATURE.R_RIPID}.value)
                        line=[line ',' num2str(F.window(i).feature{G.FEATURE.R_RIPID}.value{f})];
                    else
                        line=[line ','];
                    end
                end
                fprintf(fid,'%s\n',line);
            end
        end
    end
end
fclose(fid);

end
function [smoking craving]=selfReportOrNot(F,start,endd)
    smoking=0;craving=0;
    if ~isempty(F.selfreport{3}.timestamp)
        ind=find(F.selfreport{3}.timestamp>=start & F.selfreport{3}.timestamp<=endd);
        if length(ind)>0
            craving=1;
        end
    end
    if ~isempty(F.selfreport{2}.timestamp)
        ind1=find(F.selfreport{2}.timestamp>=start & F.selfreport{2}.timestamp<=endd);
        if length(ind1)>0
            smoking=1;
        end
    end
end
% count=0;
% for i=1:1440 
%     if isfield(F.window(i).feature{4},'value') && F.window(i).feature{4}.value(27)<.692
%         
%         count=count+1;
%     end
% end;
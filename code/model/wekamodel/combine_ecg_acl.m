function combine_ecg_acl(G,pid, sid,INDIR,OUTDIR,MODEL)

fprintf('%-6s %-6s %-20s Task (',pid,sid,'training weka file for human identification\n');
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[MODEL.STUDYTYPE '_' pid '_' sid '_' MODEL.NAME '_' G.FILE.FEATURE_MATNAME];
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
outfile=[pid '_' sid '_' MODEL.NAME '.mat'];

load ([indir G.DIR.SEP infile]);

name=[outdir G.DIR.SEP outfile];
features=[];
for j=1:length(F.window)
    if F.window(j).feature{G.FEATURE.R_ECGID}.quality==G.QUALITY.GOOD && F.window(j).feature{G.FEATURE.R_ACLID}.quality==G.QUALITY.GOOD
        if isfield(F.window(j).feature{G.FEATURE.R_ECGID},'value') && isfield(F.window(j).feature{G.FEATURE.R_ACLID},'value')
            if length(cell2mat(F.window(j).feature{G.FEATURE.R_ECGID}.value))>0 && length(cell2mat(F.window(j).feature{G.FEATURE.R_ACLID}.value))>0
                combineFeat=[F.window(j).feature{G.FEATURE.R_ECGID}.value(2:end) F.window(j).feature{G.FEATURE.R_ACLID}.value(22)];                   
                combineFeat=cell2mat(combineFeat);
                if(sum(isnan(combineFeat))~=0),continue;
                end;
                features=[features; combineFeat];
            end
        end
    end
end
C=features;
save([outdir G.DIR.SEP outfile],'C');
disp('abc');
%{
feature_names={'STRETCHUP','INSPDURMEDIAN','EXPRDURMEDIAN','IERATIOMEDIAN','STRETCHMEDIAN', ...
    'VRVL','LFHF','HRP1','HRP2','HRP3','RRMD','RRCT'};
% features=[];
% labels=[];
% k=1;
% %convert the categories into walking, running,stationary
% for i=1:length(category_label)
%     if isempty(category_label{i})
%         continue;
%     elseif strcmpi(category_label{i},'sitting')
%         labels{k}='stationary';
%         features=[features;feat(i,:)];
%     elseif strcmpi(category_label{i},'standing')
%         labels{k}='stationary';
%         features=[features;feat(i,:)];
%     elseif strcmpi(category_label{i},'lying')
%         labels{k}='stationary';
%         features=[features;feat(i,:)];
%     elseif strcmpi(category_label{i},'driving')
%         labels{k}='driving';
%         features=[features;feat(i,:)];
%     elseif strcmpi(category_label{i},'walking')
%         labels{k}='walking';
%         features=[features;feat(i,:)];
%     elseif strcmpi(category_label{i},'running')
%         labels{k}='running';
%         features=[features;feat(i,:)];
%     end
%     k=k+1;
% end
label_name={pid};


write_arff(name,feature_names,label_name,features,labels);
%write_arff(name,G.FEATURE.R_ACL.NAME,G.LABEL.NAME(G.LABEL.ACTIVITYIND,:,1),F.feature.feature,category_label);
%write_arff(name,G.FEATURE.R_ACL.NAME,LABEL.NAME(LABEL.DRIVINGIND,:,1),F.sensor(FEATURE.CHESTACCELID).feature,category_label);
%write_arff(name,FEATURE.CHESTACCEL.NAME,categories,F.sensor(LABEL.ACTIVITYIND).feature,category_label);
%}
%% weka test file
%[row ~]=size(F.sensor(LABEL.ACTIVITYIND).feature);
%category_label={};
%for i=1:row
%    category_label=[category_label '?'];
%end
%write_arff(name,FEATURE.CHESTACCEL.NAME,LABEL.NAME(LABEL.ACTIVITYIND,:,1),F.sensor(LABEL.ACTIVITYIND).feature,category_label);
%}
end

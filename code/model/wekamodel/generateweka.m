function generateweka(G,pid, sid,INDIR,OUTDIR,MODEL)

indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' MODEL.NAME '.mat'];
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
outfile=[pid '_' sid '_' MODEL.NAME '_weka'];

load ([indir G.DIR.SEP infile]);

name=[outdir G.DIR.SEP outfile];

feature_names=[G.FEATURE.R_ECG.NAME(2:end)];
label_name={pid};

len=size(C,1);
labels=[];
for i=1:len
    labels{i}=pid;
end
write_arff(name,feature_names,label_name,C,labels);

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

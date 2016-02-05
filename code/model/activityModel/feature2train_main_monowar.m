function [features,labels]=feature2train_main_monowar(G,pid, sid,INDIR,OUTDIR,MODEL)
features=[];labels=[];
fprintf('%-6s %-6s %-20s Task (',pid,sid,'training weka file');
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[MODEL.STUDYTYPE '_' pid '_' sid '_' MODEL.NAME '_' G.FILE.FEATURE_MATNAME];
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
outfile=[MODEL.STUDYTYPE '_' pid '_' sid '_' MODEL.NAME '_' 'weka_no_gravity'];

load ([indir G.DIR.SEP infile]);

rawIndir=[G.DIR.DATA G.DIR.SEP 'formattedraw'];
rawInfile=[pid '_' sid '_' G.FILE.FRMTRAW_MATNAME];

load ([rawIndir G.DIR.SEP rawInfile]);

%outdir=[DIR.STUDY DIR.SEP SESSIONTYPE_NAME DIR.SEP DIR.FEATURE];
%outfile=[DIR.STUDYNAME '_' DIR.SESSIONTYPE_NAME(1) '_' pid '_' sid '_' WINDOW.NAME '_' FILE.LIBSVM_NAME];
%outfile=[DIR.STUDYNAME '_' DIR.SESSIONTYPE_NAME(1) '_' pid '_' sid '_' WINDOW.NAME '_phone_' FILE.LIBSVM_NAME];
% outfile=[DIR.STUDYNAME '_' DIR.SESSIONTYPE_NAME(1) '_' pid '_' sid '_' WINDOW.NAME '_' FILE.WEKA];             %for WEKA
% outfile=[DIR.STUDYNAME '_' DIR.SESSIONTYPE_NAME(1) '_' pid '_' sid '_' WINDOW.NAME '_phone_' FILE.WEKA];             %for WEKA
%outfile=[DIR.STUDYNAME '_' DIR.SESSIONTYPE_NAME(1) '_' pid '_' sid '_' WINDOW.NAME '_driving_' FILE.WEKA];  
%% read all files in case of multiple feature.mat files
%name=[WINDOW.TESTDIR DIR.SEP outfile];
% name=[WINDOW.TRAINDIR DIR.SEP outfile];
name=[outdir G.DIR.SEP outfile];



%% for libsvm multiclass file
%write_libsvm_multiclass(name,F.sensor(FEATURE.CHESTACCELID).feature,F.output(:,LABEL.ACTIVITYIND));
%write_libsvm_multiclass(name,F.sensor(FEATURE.PHONEACCELID).feature,F.output(:,LABEL.ACTIVITYIND));
%write_libsvm_multiclass(name,F.sensor(LABEL.ACTIVITYIND).feature,ones(size(F.sensor(LABEL.ACTIVITYIND).feature,1),1));
%createtestparam(pid,sid,WINDOW);

%% for WEKA arff training file
%{
%ind=find(F.output(:,LABEL.ACTIVITYIND) ~= -1); %ignore unlabeled data
%categories=F.output(:,LABEL.ACTIVITYIND);
categories=F.output(:,LABEL.DRIVINGIND);

%initialize of label for each feature row
category_label={};
%for i=1:length(F.output(:,LABEL.ACTIVITYIND))
for i=1:length(F.output(:,LABEL.DRIVINGIND))
    category_label=[category_label '-1']; 
end;
index=find(categories==LABEL.SUREDRIVING);
for i=1:length(index)
    category_label{index(i)}=LABEL.NAME(LABEL.DRIVINGIND,LABEL.SUREDRIVING,1);
end;
index=find(categories==LABEL.NOTDRIVING);
for i=1:length(index)
    category_label{index(i)}=LABEL.NAME(LABEL.DRIVINGIND,LABEL.NOTDRIVING,1);
end;
index=find(categories==LABEL.STOPPAGE);
for i=1:length(index)
    category_label{index(i)}=LABEL.NAME(LABEL.DRIVINGIND,LABEL.STOPPAGE,1);
end;
% index=find(categories==LABEL.WALKING);
% for i=1:length(index)
%     category_label{index(i)}=LABEL.NAME(LABEL.ACTIVITYIND,LABEL.WALKING,1);
% end;
% 
% index=find(categories==LABEL.RUNNING);
% for i=1:length(index)
%     category_label{index(i)}=LABEL.NAME(LABEL.ACTIVITYIND,LABEL.RUNNING,1);
% end;
% 
% index=find(categories==LABEL.SITTING);
% for i=1:length(index)
%     %category_label{index(i)}=LABEL.NAME(LABEL.ACTIVITYIND,LABEL.SITTING,1);
%     category_label{index(i)}='static';
% end;
% 
% index=find(categories==LABEL.STANDING);
% for i=1:length(index)
%     %category_label{index(i)}=LABEL.NAME(LABEL.ACTIVITYIND,LABEL.STANDING,1);
%     category_label{index(i)}='static';
% end;
% 
% index=find(categories==LABEL.LYING);
% for i=1:length(index)
%     %category_label{index(i)}=LABEL.NAME(LABEL.ACTIVITYIND,LABEL.LYING,1);
%     category_label{index(i)}='-1';  %ignore lying
% end;
% 
% index=find(categories==LABEL.DRIVING);
% for i=1:length(index)
%     category_label{index(i)}=LABEL.NAME(LABEL.ACTIVITYIND,LABEL.DRIVING,1);
% end;
%categories{1}='walking';categories{2}='running';categories{3}='static';categories{4}='driving';
%write_arff(name,FEATURE.CHESTACCEL.NAME,LABEL.NAME(LABEL.ACTIVITYIND,:,1),F.sensor(FEATURE.CHESTACCELID).feature,category_label);
% write_arff(name,FEATURE.CHESTACCEL.NAME,LABEL.NAME(LABEL.ACTIVITYIND,:,1),F.sensor(FEATURE.PHONEACCELID).feature,category_label);
%}
if isfield(R,'label')==0, return;end;

[feat,category_label]=getLabelsForEachWindow(G,F,R.label);
features=[];
labels=[];
k=1;
%convert the categories into walking, running,stationary
for i=1:length(category_label)
    if isempty(category_label{i})
        continue;
    elseif strcmpi(category_label{i},'sitting')
        labels(k)=0;
        features=[features;feat(i,:)];
    elseif strcmpi(category_label{i},'standing')
        labels(k)=1;
        features=[features;feat(i,:)];
    elseif strcmpi(category_label{i},'lying')
        labels(k)=2;
        features=[features;feat(i,:)];
    elseif strcmpi(category_label{i},'driving')
        labels(k)=3;
        features=[features;feat(i,:)];
    elseif strcmpi(category_label{i},'walking')
        labels(k)=4;
        features=[features;feat(i,:)];
    elseif strcmpi(category_label{i},'running')
        labels(k)=5;
        features=[features;feat(i,:)];
    end
    k=k+1;
end
label_name={'stationary','walking'};
return;

write_arff(name,G.FEATURE.R_ACL.NAME,label_name,features,labels);
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

end

function [features,labels]=getLabelsForEachWindow(G,F,label)
labels=[];
features=[];
k=1;
for i=1:length(label)
    start=label(i).starttime;endd=label(i).endtime;
    for j=1:length(F.window)
        if F.window(j).starttimestamp>start+30000 & F.window(j).endtimestamp<endd-30000 & F.window(j).sensor{4}.quality~=4
            labels{k}=label(i).label;
            if isfield(F.window(j).feature{4},'value')
                features=[features;cell2mat(F.window(j).feature{4}.value)];
            else
                features=[features;-1*ones(1,G.FEATURE.R_ACL.FEATURENO)];
            end
            k=k+1;
        end
    end
end
end

global DIR FILE FEATURE LABEL

%%%%%%%%%%%%%%%%set in directory%%%%%%%%%%%%%
infile = [ DIR.SESSIONTYPE_NAME(1) '_' pid '_' sid '_' FILE.FEATURE_MATNAME];
load ([DIR.FEATURE DIR.SEP infile]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%merge label and features%%%%%%%
filelist=findfiles(DIR.FEATURE,'feature'); %read feature files
filelist=finduniquefiles(filelist);
noFile=size(filelist,2);
all_features=[];
label=[];
for i=1:noFile
    fileInfo = dir(filelist{i});
    if fileInfo.bytes==0 || length(regexpi(fileInfo.name,'feature'))==0
        continue;
    end
    load(char(filelist(i)));
    %featureWithLabel=[F.output(:,LABEL.ACTIVITYIND) F.sensor(LABEL.ACTIVITYIND).feature(:,:)];
    all_features=[all_features;F.sensor(LABEL.ACTIVITYIND).feature(:,:)];
    label=[label;F.output(:,LABEL.ACTIVITYIND)];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%set out directory%%%%%%%%%%%%
outdir=[DIR.CLASSIFIERDATA];

if isempty(dir(outdir))
    mkdir(outdir);
end
outfile=[DIR.STUDYNAME '_' DIR.SESSIONTYPE_NAME(1) '_' pid '_' sid '_' FILE.LIBSVM_NAME];
write_libsvm_multiclass([outdir DIR.SEP outfile],all_features,label);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
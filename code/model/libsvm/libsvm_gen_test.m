function libsvm_gen_test(G,F)
global DIR FILE FEATURE LABEL

label=G.RUN.MODEL.LABEL;

feature=F.sensor(FEATURE.RIPID).feature(:,FEATURE.RIP.CLASSIFIER);

outdir=[DIR.TESTLIBSVM];
outfile=[DIR.STUDYNAME '_' DIR.SESSIONTYPE_NAME(1) '_' pid '_' sid '_' FILE.LIBSVM_NAME];
libsvm_write([outdir DIR.SEP outfile],feature,label);
end


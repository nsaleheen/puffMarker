function main_curve(G,pid, sid,FRMTDIR,BDIR, WDIR,FDIR,OUTDIR,MODEL)
C=[];

load([G.DIR.DATA G.DIR.SEP FRMTDIR G.DIR.SEP pid '_' sid '_' G.FILE.FRMTDATA_MATNAME]);
load([G.DIR.DATA G.DIR.SEP BDIR G.DIR.SEP pid '_' sid '_' G.FILE.BASICFEATURE_MATNAME]);
load([G.DIR.DATA G.DIR.SEP WDIR G.DIR.SEP MODEL.STUDYTYPE '_' pid '_' sid '_' MODEL.NAME '_' G.FILE.WINDOW_MATNAME]);
load([G.DIR.DATA G.DIR.SEP FDIR G.DIR.SEP MODEL.STUDYTYPE '_' pid '_' sid '_' MODEL.NAME '_' G.FILE.FEATURE_MATNAME]);
seg = MODEL.WINDOW_LEN/1000;
C=find_rr(G,W,C,seg);
%[RR_new, time_new]=preprocess(RR,seg,TIME);
C.Q9 = filter_RR(C.RR_new,seg);


%C=find_quantile(G,W,C);
C=curve_smooth(C);
%C=curve_slope(C);
%C=curve_base(C,D);
C=curve_peak_valley(C,D,F);
%C=curve_feature(C,D);

outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
if isempty(dir(outdir))
    mkdir(outdir);
end
save([G.DIR.DATA G.DIR.SEP OUTDIR G.DIR.SEP MODEL.STUDYTYPE '_' pid '_' sid '_' MODEL.NAME '_smooth.mat'],'C');
%plot_curve(pid,sid,MODEL);
%C=curve_feature(C,D);
%save([DIR.REPORT DIR.SEP DIR.SESSIONTYPE_NAME(1) '_' pid '_' sid '_smooth.mat'],'C');
end

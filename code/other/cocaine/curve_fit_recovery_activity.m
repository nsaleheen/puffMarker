function [b0,b1,tau1,sse,r2]=curve_fit_recovery_activity(G,pid,sid,wlarge,wsmall)
disp(['pid= ' pid 'sid=' sid ' Task=curve fit recovery']);
indir=[G.DIR.DATA G.DIR.SEP 'preprocess'];infile=[pid '_' sid '_preprocess.mat'];
load([indir G.DIR.SEP infile]);
b0=[];b1=[];tau1=[];sse=[];r2=[];
for i=1:length(P.rr.window.p1)
    if P.rr.window.mark(i)==0
    v1=P.rr.window.v1(i);
    p1=P.rr.window.p1(i);
    stime=P.rr.avg.matlabtime(p1);
    etime=P.rr.avg.matlabtime(v1);
    ind=find(P.rr.avg.matlabtime>=stime & P.rr.avg.matlabtime<=etime);
    sample=P.rr.avg.(['t' num2str(wsmall)])(ind); 
    matlabtime=P.rr.avg.matlabtime(ind);
    matlabtime=matlabtime-matlabtime(1);
    sample=sample-min(sample);
    [b,g]=activity_recovery(matlabtime*24*60*60,sample);
    b0(end+1)=b.b0;
    b1(end+1)=b.b1;
    tau1(end+1)=b.tau1;
    sse(end+1)=g.sse;
    r2(end+1)=g.rsquare;
    disp('abc');
    end
end
%{
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
outfile=[pid '_' sid '_activity.mat'];
if isempty(dir(outdir))
    mkdir(outdir);
end
save([outdir G.DIR.SEP outfile],'A');
fprintf(') =>  done\n');
%}
end

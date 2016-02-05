function correct_cress_v5(G,pid,sid,INDIR,OUTDIR)
x=csvread('C:\DataProcessingFramework_COC_M\data\Memphis_Smoking\cress_hand.csv');
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' G.FILE.FRMTDATA_MATNAME];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);
if isempty(D.cress.episode), return;end;
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
outfile=[pid '_' sid '_' G.FILE.BASICFEATURE_MATNAME];
load([outdir G.DIR.SEP outfile]);
B.cress=D.cress;
for i=1:length(x(:,1))
    if str2num(pid(2:end))~=x(i,1), continue;end;
    if str2num(sid(2:end))~=x(i,2), continue;end;
    if x(i,3)<=0, continue;end;
    if x(i,4)<=0, continue;end;
    puff_peak=correct_cress_individual(x(i,3),x(i,4),D,B);
    B.cress.puff_peak{x(i,3)}=puff_peak;
    B.cress.hand{x(i,3)}=x(i,4);
end
save([outdir G.DIR.SEP outfile],'B');
end

function puff_peak=correct_cress_individual(crno,time,D,B)

[m,n]=min(abs(B.sensor{1}.peakvalley.matlabtime-time));
ERR=inf;
for i=1:length(D.cress.episode{crno}.puff)
    d=B.sensor{1}.peakvalley.matlabtime(n)-D.cress.episode{crno}.puff{i}.endmatlabtime;
    errr=[];
    for j=1:length(D.cress.episode{crno}.puff)
        tm=D.cress.episode{crno}.puff{j}.endmatlabtime+d;
        [xx,yy]=min(abs(B.sensor{1}.peakvalley.matlabtime(2:2:end)-tm));
        errr(j)=xx*24*60*60;        
    end
%    errs=sort(errr);err=sum(errs(1:floor(length(errs)/2)));
    err=sum(errr);
    if err<ERR
        ERR=err;
        I=i;
        dd=d;
    end
end
puff_peak=[];
for p=1:length(D.cress.episode{crno}.puff)
    tm=D.cress.episode{crno}.puff{p}.endmatlabtime+dd;
    [mi,mj]=min(abs(B.sensor{1}.peakvalley.matlabtime(2:2:end)-tm));
    puff_peak=[puff_peak,mj*2];
    %        B.cress.puff_peak=puff_peak;
end
end

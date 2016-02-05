function [res,samples,matlabtimes]=curve_fit_activation(G,pid,sid,wlarge,wsmall,type)
samples=[];matlabtimes=[];
disp(['pid= ' pid 'sid=' sid ' Task=curve fit activation type=' num2str(type)]);
indir=[G.DIR.DATA G.DIR.SEP 'preprocess'];infile=[pid '_' sid '_preprocess.mat'];
load([indir G.DIR.SEP infile]);
indir=[G.DIR.DATA G.DIR.SEP 'formattedraw'];
infile=[pid '_' sid '_' G.FILE.FRMTRAW_MATNAME];
load([indir G.DIR.SEP infile]);
now=0;res=[];
for i=1:length(P.rr.window.p1)
    if P.rr.window.mark(i)==type
        v1=P.rr.window.v1(i);
        p1=P.rr.window.p1(i);
        stime=P.rr.avg.matlabtime(p1);
        etime=P.rr.avg.matlabtime(v1);
        if type==1,
            if check_valid_cocaine(R,stime,etime)==0, continue;end;
        elseif type==0,
            if check_valid_noncocaine(R,stime,etime)==0, continue;end;
        end
        ind=find(P.rr.avg.matlabtime>=stime & P.rr.avg.matlabtime<=etime);
        sample=P.rr.avg.(['t' num2str(wsmall)])(ind);
        matlabtime=P.rr.avg.matlabtime(ind);
        [m,n]=max(sample);
        sample(1:n-1)=[];matlabtime(1:n-1)=[];
        [m,n]=min(sample);
        sample(n+1:end)=[];matlabtime(n+1:end)=[];
%        sx=floor(length(sample)/4);sy=ceil(length(sample)*3/4);
%        if sy-sx<10, continue;end
%        sample=sample(sx:sy);
%        matlabtime=matlabtime(sx:sy);

        matlabtime=matlabtime-matlabtime(1);
        sample=sample-min(sample);
        
        if length(sample)<10 , continue;end;
        sample=diff(sample);
        matlabtime(end)=[];
        samples=[samples sample];
        matlabtimes=[matlabtimes matlabtime];
        continue;
        [b,g]=activation(matlabtime*24*60*60,sample,0);
        now=now+1;
        res(now).b=b;
        res(now).g=g;
        res(now).height=max(sample)-min(sample);
        res(now).duration=max(matlabtime)*24*60*60;
%        b0(end+1)=b.b0;
%        b1(end+1)=b.b1;
%        tau1(end+1)=b.tau1;
%        sse(end+1)=g.sse;
%        r2(end+1)=g.rsquare;
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
function valid=check_valid_cocaine(R,stime,etime)
valid=0;
if isfield(R,'adminmark')==0,return;end;
if isfield(R.adminmark,'matlabtime')==0, return;end;
if length(R.adminmark.matlabtime)==0, return;end;
[m,i]=min(abs(R.adminmark.matlabtime-stime));
if R.adminmark.dose(i)==20 || R.adminmark.dose(i)==40
    for j=1:i-1
        if R.adminmark.dose(i)==R.adminmark.dose(j), return; end;
    end
    valid=1;
    return;
end
end
function valid=check_valid_noncocaine(R,stime,etime)
valid=1;
if isfield(R,'adminmark')==0,return;end;
if isfield(R.adminmark,'matlabtime')==0, return;end;
if length(R.adminmark.matlabtime)==0, return;end;
valid=0;
end

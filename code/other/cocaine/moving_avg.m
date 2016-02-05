function moving_avg(G,pid,sid,INDIR,OUTDIR,window)

disp(['pid= ' pid 'sid=' sid ' Task=preprocess']);
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' G.FILE.BASICFEATURE_MATNAME];
load([indir G.DIR.SEP infile]);
ind=find(B.sensor{G.SENSOR.R_ECGID}.rr.quality==G.QUALITY.GOOD);
sample=B.sensor{G.SENSOR.R_ECGID}.rr.sample(ind)*1000;
matlabtime=B.sensor{G.SENSOR.R_ECGID}.rr.matlabtime(ind);
ind=find(sample<1500);
sample=sample(ind);
matlabtime=matlabtime(ind);
P.sensor{G.SENSOR.R_ACLXID}=B.sensor{G.SENSOR.R_ACLXID};

P.rr.sample=sample;
P.rr.matlabtime=matlabtime;
%window=[1*60,5*60,10*60,1*60*60,2*60*60];%, 10,];
for w=window
    [P.rr.(['t' num2str(w)]),P.rr.smoothtime]=compute_moving_avg(sample,matlabtime,w);
end
%%ppid=str2num(pid(2:end));ssid=str2num(sid(2:end));
%{
P.rr.macd.time=P.rr.smoothtime;
for f=10:120
    for s=3:f-1
        for t=2:s+10
            [mv1,mv2]=compute_macd_moving(P.rr.t600{G.AVG},f*60,s*60,t*60);
            val=(mv1-mv2);
            pos=find(val(1:end-1)>=0 & val(2:end)<0);
            P.rr.macd.mavg{f,s,t}=pos;
        end
    end
end
%[P.rr.macd.mavg1,P.rr.macd.mavg2]=compute_macd_moving(P.rr.t600{G.AVG},30*60,6*60,4*60);
%[P.rr.macd.mavg3,P.rr.macd.mavg4]=compute_macd_moving(P.rr.t600{G.AVG},20*60,4*60,2*60);

%[P.rr.macd.mavg1,P.rr.macd.mavg2,P.rr.macd.time]=compute_macd(sample,matlabtime,30,10,8,60);
%}
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
outfile=[pid '_' sid '_preprocess.mat'];
if isempty(dir(outdir))
    mkdir(outdir);
end
save([outdir G.DIR.SEP outfile],'P');
fprintf(') =>  done\n');
end
%{
function [mavg1,mavg2]=compute_macd_moving(sample,p1,p2,p3)
[mavg1,mavg2]=macd(sample',p1,p2,p3);
end

function [mavg1,mavg2,time]=compute_macd(sample,matlabtime,p1,p2,p3,wsize)
out=zeros(1,length(matlabtime(1):(1.0*wsize)/(24*60*60):matlabtime(end)));
time=zeros(1,length(matlabtime(1):(1.0*wsize)/(24*60*60):matlabtime(end)));
now=0;

for i=matlabtime(1):(1.0*wsize)/(24*60*60):matlabtime(end)
    now=now+1;
    ind=find(matlabtime>=i & matlabtime<=i+(wsize)/(24*60*60));
    time(now)=i+(wsize/2)/(24*60*60);
    if isempty(ind), out(now)=out(now-1);
    else out(now)=mean(sample(ind));
    end
end
[mavg1,mavg2]=macd(out',p1,p2,p3);
end

function [out,time]=compute_moving_avg(sample,matlabtime,w)
out=zeros(1,length(matlabtime(1):1.0/(24*60*60):matlabtime(end)));
time=zeros(1,length(matlabtime(1):1.0/(24*60*60):matlabtime(end)));
now=0;
for i=matlabtime(1):1.0/(24*60*60):matlabtime(end) % moving by 1 second
    now=now+1;
    ind=find(matlabtime>=i-(w/2)/(24*60*60) & matlabtime<=i+(w/2)/(24*60*60));
    time(now)=i;
    if isempty(ind), 
        out(now)=out(now-1);
    else
        out(now)=mean(sample(ind));
    end
end
end
%}
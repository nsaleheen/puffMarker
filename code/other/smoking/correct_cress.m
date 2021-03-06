function correct_cress(G,pid,sid,INDIR,OUTDIR,T)
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' G.FILE.FRMTDATA_MATNAME];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);
if isempty(D.cress.episode), return;end;
cress=D.cress;
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
outfile=[pid '_' sid '_' G.FILE.BASICFEATURE_MATNAME];
load([outdir G.DIR.SEP outfile]);

puff_peak=[];
pstart=7;
min_error=inf;
min_drift=inf;
for c=1:length(D.cress.episode)
    [error,drift,x]=find_min_error(G,D,B,T,c,pstart);
    if min_error>error, min_error=error;min_drift=drift;end
    fprintf('pid=%s,sid=%s,episode=%d,error=%f,drift=%s,index=%d\n', pid,sid,c,error,num2str(drift*24*60*60),x);
end
fprintf('*** pid=%s,sid=%s,episode=%d,error=%f,drift=%s ***\n', pid,sid,c,min_error,num2str(min_drift*24*60*60));

for c=1:length(D.cress.episode)
    [error,drift,x]=find_min_error(G,D,B,abs(min_drift*24*60)+10/60,c,pstart);
    fprintf('==> pid=%s,sid=%s,episode=%d,error=%f,drift=%s,index=%d\n', pid,sid,c,error,num2str(drift*24*60*60),x);

    for p=1:length(D.cress.episode{c}.puff)
        [mi,mj]=min(abs(B.sensor{1}.peakvalley.matlabtime(2:2:end)-D.cress.episode{c}.puff{p}.endmatlabtime+drift));
        puff_peak=[puff_peak,mj*2];
%        B.cress.puff_peak=puff_peak;
    end    
end

%{
    %    iplot4_monowar_pv(G,pid,sid, 'basicfeature', [G.SENSOR.R_RIPID,G.SENSOR.WR9_ACLYID,G.SENSOR.WR9_GYRZID,G.SENSOR.WL9_ACLYID,G.SENSOR.WL9_GYRZID], 1, -min_d+(D.cress.episode{c}.puff{1}.endmatlabtime-D.cress.episode{c}.puff{1}.startmatlabtime));
    %    iplot4_monowar_pv_puff_episode(G,pid,sid, 'basicfeature', [G.SENSOR.R_RIPID,G.SENSOR.WR9_ACLYID,G.SENSOR.WL9_ACLYID], 1, c);
    disp('here');
end
%iplot4_monowar_pv_puff(G,pid,sid, 'basicfeature', [G.SENSOR.R_RIPID,G.SENSOR.WR9_ACLYID,G.SENSOR.WL9_ACLYID], 1, -min_d);

%}
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
outfile=[pid '_' sid '_' G.FILE.BASICFEATURE_MATNAME];

if isempty(dir(outdir))
    mkdir(outdir);
end
cress.puff_peak=puff_peak;
B.cress=cress;
save([outdir G.DIR.SEP outfile],'B');
%}
end

function [min_error,min_drift,min_x]=find_min_error(G,D,B,T,c,pstart)
    min_x=inf;
    startmatlabtime=D.cress.episode{c}.puff{pstart}.startmatlabtime-T/(24*60);
    endmatlabtime=D.cress.episode{c}.puff{pstart}.startmatlabtime+T/(24*60);
    ind=find(B.sensor{1}.peakvalley.matlabtime>=startmatlabtime & B.sensor{1}.peakvalley.matlabtime<=endmatlabtime);
    min_error=inf;
    min_drift=inf;
    if isempty(ind), return;end;
    for x=ind
        [error,drift]=find_error_from_peak(G,D,B,x,c,pstart);
        if min_error>error
            min_error=error;
            min_drift=drift;
            min_x=x;
        end
    end
    
end
function [error,drift]=find_error_from_peak(G,D,B,peak_ind,c,pstart)
error=inf;
drift=inf;
if mod(peak_ind,2)==1, return;end;
ptime=B.sensor{1}.peakvalley.matlabtime(peak_ind);
ctime=D.cress.episode{c}.puff{pstart}.endmatlabtime;
drift=ctime-ptime;
error=0;
for p=pstart:length(D.cress.episode{c}.puff)
    new_ctime=D.cress.episode{c}.puff{p}.endmatlabtime-drift;
    [m,n]=min(abs(B.sensor{1}.peakvalley.matlabtime(2:2:end)-new_ctime));
    m=m*24*60*60*1000;
    error=error+m*m;
end
end

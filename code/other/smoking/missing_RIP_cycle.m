function missing_RIP_cycle(G, pid,sid, INDIR)

indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' INDIR '.mat'];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);
lenQ=length(P.sensor{G.SENSOR.R_RIPID}.peakvalley.sample);
P.quality=[];
now=0;
for i=3:2:lenQ
    etime=P.sensor{G.SENSOR.R_RIPID}.peakvalley.timestamp(i);
    stime=P.sensor{G.SENSOR.R_RIPID}.peakvalley.timestamp(i-2);
    e_mtime=P.sensor{G.SENSOR.R_RIPID}.peakvalley.matlabtime(i);
    s_mtime=P.sensor{G.SENSOR.R_RIPID}.peakvalley.matlabtime(i-2);
    
    ind=find(P.sensor{G.SENSOR.R_RIPID}.timestamp>=stime & P.sensor{G.SENSOR.R_RIPID}.timestamp<=etime);
    if length(ind)>0.67*G.SENSOR.ID(G.SENSOR.R_RIPID).FREQ*(etime-stime)/1000
        if now==0,
            now=now+1;
            P.quality{1}.starttimestamp(now)=stime;            P.quality{1}.endtimestamp(now)=etime;
            P.quality{1}.startmatlabtime(now)=s_mtime;            P.quality{1}.endmatlabtime(now)=e_mtime;
        elseif P.quality{1}.endtimestamp(now)==stime
            P.quality{1}.endtimestamp(now)=etime;P.quality{1}.endmatlabtime(now)=e_mtime;
        else
            now=now+1;
            P.quality{1}.starttimestamp(now)=stime;            P.quality{1}.endtimestamp(now)=etime;
            P.quality{1}.startmatlabtime(now)=s_mtime;            P.quality{1}.endmatlabtime(now)=e_mtime;
        end
    end
end
save([indir G.DIR.SEP infile],'P');
end

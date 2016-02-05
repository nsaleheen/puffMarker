function filter_segment_missing_acl(G, pid,sid,INDIR,OUTDIR,ACC)
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' INDIR '.mat'];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);
for i=1:2
    if i==1, IDS=G.SENSOR.WR9_ACLXID:G.SENSOR.WR9_GYRZID;else IDS=G.SENSOR.WL9_ACLXID:G.SENSOR.WL9_GYRZID;end
    P.wrist{i}.acl.segment.missing=zeros(1,length(P.wrist{i}.acl.segment.starttimestamp));
    for s=1:length(P.wrist{i}.acl.segment.starttimestamp)
        stime=P.wrist{i}.acl.segment.starttimestamp(s)-1000;
        etime=P.wrist{i}.acl.segment.endtimestamp(s)+1000;
        for id=IDS
            ind=find(P.sensor{id}.timestamp>=stime & P.sensor{id}.timestamp<=etime);
            if length(ind)<ACC*G.SENSOR.ID(id).FREQ*(etime-stime)/1000
                P.wrist{i}.acl.segment.missing(s)=1;
                break;
            end
        end
    end
end
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
outfile=[pid '_' sid '_' OUTDIR '.mat'];
if isempty(dir(outdir)),    mkdir(outdir);end
save([outdir G.DIR.SEP outfile],'P');
end

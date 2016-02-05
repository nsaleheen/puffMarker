function find_smoking_episodes(G)
for p=1:size(G.PS_LIST,1)
    pid=char(G.PS_LIST{p,1});
    slist=G.PS_LIST{p,2};
    for s=slist
        sid=char(s);
        indir=[G.DIR.DATA G.DIR.SEP 'preprocess'];
        infile=[pid '_' sid '_preprocess.mat'];
        if exist([indir G.DIR.SEP infile],'file')~=2,return;end
        load([indir G.DIR.SEP infile]);
        count=0;
        for i=1:length(P.datalabel)
            if isempty(strfind(P.datalabel(i).label,'Smoking')), continue;end;
            count=count+1;
            stime=P.datalabel(i).starttimestamp;
            etime=P.datalabel(i).endtimestamp;
            puffno=count_puff(P,stime,etime);
            stimestr=convert_timestamp_time(G,stime);
            etimestr=convert_timestamp_time(G,etime);
            fprintf('pid=%s sid=%s episode=%02d puff=%02d starttime=%s endtime=%s length=%f minute\n',pid,sid,count,puffno,stimestr,etimestr,(etime-stime)/(60*1000));
        end
    end
end
end
function puffno=count_puff(P,stime,etime)
puffno=0;
for i=1:length(P.datalabel)
    if P.datalabel(i).starttimestamp>=stime && P.datalabel(i).endtimestamp<=etime
        if ~isempty(strfind(P.datalabel(i).label,'Puff'))
            puffno=puffno+1;
        end
    end
end
end
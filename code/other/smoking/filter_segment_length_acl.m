function filter_segment_length_acl(G, pid,sid, INDIR, OUTDIR,MINLIM,MAXLIM)

indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' INDIR '.mat'];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);

for i=1:2
    P.wrist{i}.acl.segment.valid=filter_length(P.wrist{i},MINLIM,MAXLIM);
end
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
outfile=[pid '_' sid '_' OUTDIR '.mat'];

if isempty(dir(outdir))
    mkdir(outdir);
end
save([outdir G.DIR.SEP outfile],'P');

end

function valid=filter_length(wrist,minlen,maxlen)
valid=zeros(1,length(wrist.acl.segment.starttimestamp));

diff=wrist.acl.segment.endtimestamp-wrist.acl.segment.starttimestamp;
valid(diff<minlen)=1;
valid(diff>maxlen)=2;

% for i=1:length(wrist.acl.segment.starttimestamp)
%     if wrist.acl.segment.endtimestamp(i)-wrist.acl.segment.starttimestamp(i)<minlen
%         valid(i)=1;
%     elseif wrist.acl.segment.endtimestamp(i)-wrist.acl.segment.starttimestamp(i)>maxlen
%         valid(i)=2;
%     end
% end
end

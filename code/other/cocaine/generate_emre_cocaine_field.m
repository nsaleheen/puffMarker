function E=generate_emre_cocaine_field(G,pid,sid)
E=[];
disp([pid ' ' sid]);
indir=[G.DIR.DATA G.DIR.SEP 'preprocess'];infile=[pid '_' sid '_preprocess.mat'];
if exist([indir G.DIR.SEP infile], 'file') ~= 2
    return;
end

load([indir G.DIR.SEP infile]);
ind=find(P.rr.window.mark>0);
E=[];
if length(find(P.rr.window.mark>0))==0, return;end;

threshold=(prctile(P.acl.avg60.value,95)-prctile(P.acl.avg60.value,5))*0.35;

now=0;
for i=1:length(ind)
    v2=P.rr.window.v2(ind(i));
    p2=P.rr.window.p2(ind(i));
    now=now+1;
    E{now}.rr.avg.matlabtime=P.rr.avg.matlabtime(v2:p2)-P.rr.avg.matlabtime(v2);
    E{now}.rr.avg.sample=P.rr.avg.t600(v2:p2);
    st=P.rr.avg.matlabtime(v2);
    et=P.rr.avg.matlabtime(p2);
    
    ind5=find(P.acl.matlabtime>=st & P.acl.matlabtime<=et);
    E{now}.acl.matlabtime=P.acl.matlabtime(ind5)-P.acl.matlabtime(ind5(1));
    E{now}.acl.value=P.acl.value(ind5);
    E{now}.acl.threshold=threshold;
    
end


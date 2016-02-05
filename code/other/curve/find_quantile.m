function C=find_quantile(G,W,C)
i=0;
for now=1:size(W.window,2)
    if isempty(W.window(now).sensor{G.SENSOR.R_ECGID}), continue;end;
    if W.window(now).sensor{G.SENSOR.R_ECGID}.quality~=G.QUALITY.GOOD,continue;end;
    if isempty(W.window(now).sensor{G.SENSOR.R_ECGID}.rr), continue;end;
    ind=find(W.window(now).sensor{G.SENSOR.R_ECGID}.rr.quality==G.QUALITY.GOOD);
    v=W.window(now).sensor{G.SENSOR.R_ECGID}.rr.sample(ind);
    if isempty(v),continue;end
    i=i+1;
%    C.Q95(i)=quantile(v,0.95);
%    v=winsorize(v);
    C.Q9(i)=quantile(v,0.9);
    C.timestamp(i)=W.window(now).endtimestamp;
    C.matlab_timestamp(i)=W.window(now).end_matlabtime;
   
end
end


function C=find_rr(G,W,C,seg)
for now=1:size(W.window,2)
    if isempty(W.window(now).sensor{G.SENSOR.R_ECGID}), continue;end;
    if W.window(now).sensor{G.SENSOR.R_ECGID}.quality~=G.QUALITY.GOOD,continue;end;
    if isempty(W.window(now).sensor{G.SENSOR.R_ECGID}.rr), continue;end;
    ind=find(W.window(now).sensor{G.SENSOR.R_ECGID}.rr.quality==G.QUALITY.GOOD);
    v=W.window(now).sensor{G.SENSOR.R_ECGID}.rr.sample(ind);
    if isempty(v),continue;end
    if length(v)<0.25*seg,continue;end;
    start=now;
    break;
end
for now=size(W.window,2):-1:1
    if isempty(W.window(now).sensor{G.SENSOR.R_ECGID}), continue;end;
    if W.window(now).sensor{G.SENSOR.R_ECGID}.quality~=G.QUALITY.GOOD,continue;end;
    if isempty(W.window(now).sensor{G.SENSOR.R_ECGID}.rr), continue;end;
    ind=find(W.window(now).sensor{G.SENSOR.R_ECGID}.rr.quality==G.QUALITY.GOOD);
    v=W.window(now).sensor{G.SENSOR.R_ECGID}.rr.sample(ind);
    if isempty(v),continue;end
    if length(v)<0.25*seg,continue;end;
    endd=now;
    break;
end
i=0;
for now=start:endd
    i=i+1;
    RR_new1(i)=NaN;
    C.timestamp(i)=W.window(now).endtimestamp;
    C.matlab_timestamp(i)=W.window(now).end_matlabtime;
    
    if isempty(W.window(now).sensor{G.SENSOR.R_ECGID}), continue;end;
    if W.window(now).sensor{G.SENSOR.R_ECGID}.quality~=G.QUALITY.GOOD,continue;end;
    if isempty(W.window(now).sensor{G.SENSOR.R_ECGID}.rr), continue;end;
    ind=find(W.window(now).sensor{G.SENSOR.R_ECGID}.rr.quality==G.QUALITY.GOOD);
    v=W.window(now).sensor{G.SENSOR.R_ECGID}.rr.sample(ind);
    if isempty(v),continue;end
    if length(v)<0.25*seg,continue;end;
    RR_new1(i)=median(v);
end
nan_index = find((isnan(RR_new1)==1));
mn = mean(RR_new1(find(isnan(RR_new1)~=1)));
RR_new1(nan_index) = mn;
RR_new_fil = filter_RR(RR_new1,seg);
C.RR_new = RR_new1;
C.RR_new(nan_index) = RR_new_fil(nan_index);

end


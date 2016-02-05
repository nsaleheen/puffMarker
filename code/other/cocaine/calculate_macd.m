function calculate_macd(G,pid,sid,OUTDIR,wlarge,M,L,R)
disp(['pid=' pid ' sid=' sid ' Task=macd']);
indir=[G.DIR.DATA G.DIR.SEP OUTDIR];infile=[pid '_' sid '_segment'];
load([indir G.DIR.SEP infile]);


% MACD
P.rr.macd.matlabtime=P.rr.avg.matlabtime;
sample=P.rr.avg.(['t' num2str(wlarge)]);
if isempty(sample), return;end;
[mv1,mv2,pos1,pos2]=find_macd_intersect(sample,M.SLOW,M.FAST,M.SIGNAL);
P.rr.macd.M1=mv1;P.rr.macd.M2=mv2;P.rr.macd.MP=pos1;P.rr.macd.MP1=pos2;posM=pos1;
[mv1,mv2,pos1,pos2]=find_macd_intersect(sample,L.SLOW,L.FAST,L.SIGNAL);
P.rr.macd.L1=mv1;P.rr.macd.L2=mv2;P.rr.macd.LP=pos1;P.rr.macd.LP1=pos2;posL=pos1;
[mv1,mv2,pos1,pos2]=find_macd_intersect(sample,R.SLOW,R.FAST,R.SIGNAL);
P.rr.macd.R1=mv1;P.rr.macd.R2=mv2;P.rr.macd.RP=pos1;P.rr.macd.RP1=pos2;posR=pos1;
P.rr.macd.pos=[];
% mark macd point
for i=1:length(posM)
    [res,mpos1]=min(abs(P.rr.macd.matlabtime(posM(i))-P.rr.macd.matlabtime(posL)));
    [res,mpos2]=min(abs(P.rr.macd.matlabtime(posM(i))-P.rr.macd.matlabtime(posR)));
    pos1=posL(mpos1);pos2=posR(mpos2);
    P.rr.macd.pos(end+1)=min(pos1,pos2);    
    P.rr.macd.pos(end+1)=max(pos1,pos2);
end
%find valid window
[P.rr.window.p1,P.rr.window.p2]=find_window_start_end(P);
[P.rr.window.v1,P.rr.window.v2]=find_valley(P,wlarge);


%fprintf('  acltime-rravgtime=%f',max(abs(diff(P.acl.matlabtime-P.rr.avg.matlabtime)))*24*60*60);
outdir=[G.DIR.DATA G.DIR.SEP OUTDIR];
outfile=[pid '_' sid '_segment.mat'];
if isempty(dir(outdir))
    mkdir(outdir);
end
save([outdir G.DIR.SEP outfile],'P');
fprintf(') =>  done\n');
end
function [v1,v2]=find_valley(P,wlarge)
v1=zeros(1,length(P.rr.window.p1));
v2=zeros(1,length(P.rr.window.p1));
for i=1:length(P.rr.window.p1)
    sind=P.rr.window.p1(i);
    eind=P.rr.window.p2(i);
    ind1=find(P.rr.macd.MP1>sind & P.rr.macd.MP1<eind);
    ind2=find(P.rr.macd.MP1>sind & P.rr.macd.MP1<eind);
    fprintf('%d ',length(ind1));
    if ~isempty(ind1) & ~isempty(ind2)
%{
        v11=P.rr.macd.RP1(ind1(1));
        for ii=2:length(ind1)
            if P.rr.macd.matlabtime(ind1(ii))-P.rr.macd.matlabtime(sind)<(60*30)/(24*60*60) & P.rr.avg.(['t' num2str(wlarge)])(v11)> P.rr.avg.(['t' num2str(wlarge)])(ii)
                v11=ind1(ii);
            end
        end
        v22=P.rr.macd.MP1(ind2(end));        
        for ii=length(ind2)-1:-1:1
            if P.rr.macd.matlabtime(eind)-P.rr.macd.matlabtime(ind2(ii))<(60*30)/(24*60*60)  & P.rr.avg.(['t' num2str(wlarge)])(v22)> P.rr.avg.(['t' num2str(wlarge)])(ii)
                v22=ind2(ii);
            end
        end
        %}
        v1(i)=P.rr.macd.MP1(ind1(1));
        v2(i)=P.rr.macd.MP1(ind2(end));
    else
        v1(i)=-1; 
        v2(i)=-1;        
    end
end
fprintf('\n');
end
function [si,ei]=find_window_start_end(P)
si=[];ei=[];
start=P.rr.macd.pos(2:2:end);
endd=P.rr.macd.pos(1:2:end);
now=1;
while now<=length(start)
    while now<=length(start) & P.rr.macd.M1(start(now))<0, now=now+1;end
    if now<=length(start), sind=start(now);end;
    while now+1<=length(start) & P.rr.macd.M1(start(now+1))>0,
        sind=start(now);
        eind=endd(now+1);
        mx=max(P.rr.macd.M1(sind:eind));
        mn=min(P.rr.macd.M1(sind:eind));
        if mx>=0 & mn>=0, now=now+1;sind=start(now); continue;
        else, break;
        end;
    end
%    if now<=length(start), ind(end+1)=sind;end;
    now=now+1;
    while now<=length(start)
        while now<=length(start) & P.rr.macd.M1(endd(now))<0, now=now+1;end
        if now<=length(start),
            eind=endd(now);
            mx=max(P.rr.macd.M1(sind:eind));
            mn=min(P.rr.macd.M1(sind:eind));
            if mx>0 & mn<0, break;end;
            now=now+1;
        end
    end
    if now<=length(start)
        si(end+1)=sind;
        ei(end+1)=eind;
    end
end
end


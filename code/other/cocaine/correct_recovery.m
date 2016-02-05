function correct_recovery(G,pid,sid)
disp(['pid= ' pid 'sid=' sid ' Task=mark cocaine segment']);
indir=[G.DIR.DATA G.DIR.SEP 'segment'];infile=[pid '_' sid '_segment.mat'];
if exist([indir G.DIR.SEP infile], 'file') ~= 2
    return;
end
load([indir G.DIR.SEP infile]);
if ~isfield(P.rr,'window'), return;end;
for i=1:length(P.rr.window.p2)
    P.rr.window.a1(i)=-1;P.rr.window.a2(i)=-1;P.rr.window.c1(i)=-1;P.rr.window.c2(i)=-1;P.r.window.atr1(i)=-1;P.rr.window.atr2(i)=-1;
    if P.rr.window.p1(i)==-1 || P.rr.window.p2(i)==-1, continue; end;
    if P.rr.window.mark(i)<0, continue;end
    [P.rr.window.a1(i),P.rr.window.a2(i)]=correct_activity_recovery_test(P,i);
    [P.rr.window.c1(i),P.rr.window.c2(i)]=correct_cocaine_recovery_test(P,i);
    [P.rr.window.atr1(i),P.rr.window.atr2(i)]=correct_activity_recovery_train(P,i);
    [P.rr.window.ctr1(i),P.rr.window.ctr2(i)]=correct_cocaine_recovery_train(P,i);    
end

outdir=[G.DIR.DATA G.DIR.SEP 'segment'];
outfile=[pid '_' sid '_segment.mat'];
if isempty(dir(outdir))
    mkdir(outdir);
end
save([outdir G.DIR.SEP outfile],'P');
fprintf(') =>  done\n');

end
function [c1,c2]=correct_cocaine_recovery_test(P,i)
sind=max(P.rr.window.p1(i),P.rr.window.v2(i)-10*60); % See (v2-10 minutes) to v2
[x,y]=min(P.rr.avg.t60(sind:P.rr.window.v2(i)));
c1=y+sind;
c2=P.rr.window.p2(i);
end
function [c1,c2]=correct_cocaine_recovery_train(P,i)
sind=max(P.rr.window.p1(i),P.rr.window.v2(i)-10*60); % See (v2-10 minutes) to p2
eind=P.rr.window.p2(i);
[x,y]=min(P.rr.avg.t60(sind:P.rr.window.v2(i)));
c1=y+sind;
c2=P.rr.window.p2(i);
end
function [a1,a2]=correct_activity_recovery_train(P,i)
sind=max(P.rr.window.p1(i),P.rr.window.v2(i)-5*60); % See v2-10 minutes 10 minutes before to P2
eind=P.rr.window.p2(i);
x=find(P.acl.avg.t60(sind:eind)>P.acl.avg.th60);
x=x+sind;
acl=zeros(1,length(P.acl.avg.t60));
acl(x)=1;
for ii=x
    if ii-3*60<sind, continue;end
    if ii+2*60>eind, continue;end;
    lsum=sum(acl(ii-3*60:ii));
    rsum=sum(acl(ii:ii+2*60));
    if lsum<0.80*length(ii-3*60:ii), continue; end;
    if rsum>0.20*length(ii:ii+2*60), continue; end;
    [xx,yy]=min(P.rr.avg.t60(max(1,ii-5*60):ii));
    a1=yy+max(ii-5*60,1);
    [xx,yy]=max(P.rr.avg.t60(ii:min(length(P.rr.avg.t60),ii+5*60)));
    a2=yy+ii;
    return;
end
a1=-1;
a2=-1;
end
function [a1,a2]=correct_activity_recovery_test(P,i)
sind=max(P.rr.window.p1(i),P.rr.window.v2(i)-5*60); % See v2-10 minutes 10 minutes before to P2
eind=min(P.rr.window.p2(i),P.rr.window.v2(i)+5*60);
[x,y]=min(P.rr.avg.t60(sind:eind));
a1=y+sind;
a2=P.rr.window.p2(i);
return;
x=find(P.acl.avg.t60(sind:P.rr.window.p2(i))>P.acl.avg.th60);
if isempty(x),  a1=P.rr.window.p2(i);a2=P.rr.window.p2(i);return;end;
acl=zeros(1,sind-P.rr.window.p2(i)+1);
acl(x)=1;
for ii=length(acl)-60:-1:1
    if sum(acl(ii:ii+60))>0.75
        a1=ii+P.rr.window.v2(i);
        a2=P.rr.window.p2(i);
        return;
    end
end
%{
for j=length(x):-1:1
    aa1=x(j)+P.rr.window.v2(i);aa2=P.rr.window.p2(i);
    aa=find(P.acl.avg.t120(max(1,aa1-60):aa1)>P.acl.avg.th120);
    if length(aa)<20, continue;end;
    [x,y]=min(P.rr.avg.t60(max(1,aa1-300):aa2));
    a1=y+max(1,aa1-300);
    a2=P.rr.window.p2(i);
    return;
%}
a1=P.rr.window.p2(i);a2=P.rr.window.p2(i);
end

%aa1=x(end)+P.rr.window.v2(end);aa2=P.rr.window.p2(end);
%[x,y]=min(P.rr.avg.t60(max(1,aa1-60):aa1));
%a1=P.rr.window.p2(i);%y+max(1,aa1-60);
%a2=P.rr.window.p2(i);
%end

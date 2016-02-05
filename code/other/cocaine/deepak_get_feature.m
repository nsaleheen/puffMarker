function [C,N]=deepak_get_feature(G,pid,sid,INDIR,MODEL)
%% Load Data (Formatted Raw, Formatted Data)
fprintf('%-6s %-6s %-20s Task (',pid,sid,'main_deepak_get_feature');
indir=[G.DIR.DATA G.DIR.SEP 'feature'];infile=[MODEL.STUDYTYPE '_' pid '_' sid '_' MODEL.NAME '_' G.FILE.FEATURE_MATNAME];
load([indir G.DIR.SEP infile]);
[acl.matlabtime,acl.value]=get_activity_featurevalue(F);
clear F;

indir=[G.DIR.DATA G.DIR.SEP INDIR];
load([indir G.DIR.SEP pid '_' sid '.mat']);
load('E.mat');
ppid=str2num(pid(2:end));
C=[];N=[];
for c=1:length(E{ppid}.C)
    if E{ppid}.C{c}.window.mark~=40, continue;end;
    v=abs(E{ppid}.C{c}.window_time(1)-A.feature.matlabtime(1));
    if v>(8*60*60)/(24*60*60),continue;end
    stime=E{ppid}.C{c}.window_time(2)-(2*60)/(24*60*60);
    etime=E{ppid}.C{c}.window_time(2)+(8*60)/(24*60*60);
    ind=find(A.feature.matlabtime>=stime & A.feature.matlabtime<=etime);
    cc=[A.feature.sample(ind,:) A.feature.qt(ind) A.feature.qtc(ind) A.feature.pr(ind) A.feature.qrs(ind) A.feature.th(ind)];
    C=[C ; cc];
end
minn=-1;N=[];
for c=1:length(E{ppid}.C)
    v=abs(E{ppid}.C{c}.window_time(1)-A.feature.matlabtime(1));
    if v>(8*60*60)/(24*60*60),continue;end
    if minn==-1 || v<minn, minn=v;n=c;end;
end
if minn==-1, return;end
stime=E{ppid}.C{n}.window_time(1)-(30*60)/(24*60*60);
etime=E{ppid}.C{n}.window_time(1)- (2*60)/(24*60*60);
th=(max(acl.value)-min(acl.value))/2;
ind=find(acl.matlabtime>=stime & acl.matlabtime<=etime);
acl.value=acl.value(ind);
acl.matlabtime=acl.matlabtime(ind);
if isempty(ind), return;end
ind=find(acl.value<th);
count=1;ss=ind(1);se=ind(1);
for i=2:length(ind)
    if ind(i)==ind(i-1)+1
        count=count+1;
        se=ind(i);
    else
        if count>30
            st=acl.matlabtime(ss+10);
            et=acl.matlabtime(se);
            inds=find(A.feature.matlabtime>=st & A.feature.matlabtime<=et);
            nn=[A.feature.sample(inds,:) A.feature.qt(inds) A.feature.qtc(inds) A.feature.pr(inds) A.feature.qrs(inds) A.feature.th(inds)];
            N=[N ; nn];
            
        end
        count=1;
        ss=ind(i);
        se=ind(i);
    end
end
if count>30
    st=acl.matlabtime(ss+10);
    et=acl.matlabtime(se);
    inds=find(A.feature.matlabtime>=st & A.feature.matlabtime<=et);
    nn=[A.feature.sample(inds,:) A.feature.qt(inds) A.feature.qtc(inds) A.feature.pr(inds) A.feature.qrs(inds) A.feature.th(inds)];
    N=[N ; nn];
    
end

end
function [matlabtime,value]=get_activity_featurevalue(F)
matlabtime=[];
value=[];
for i=1:length(F.window)
    if F.window(i).feature{4}.quality~=0, continue;end;
    matlabtime(end+1)=F.window(i).end_matlabtime-(5/(24*60*60));
    value(end+1)=F.window(i).feature{4}.value{30};
end
k=prctile(value,98);
value(find(value>k))=k;
end

function B=find_smoking_episode_lab(G, B)
fprintf('find_smoking_episode_lab');
B.smoking_episode=[];
count=0;
if ~isfield(B,'datalabel'), return, end;
for i=1:length(B.datalabel)
    if isempty(strfind(B.datalabel(i).label,'Smoking')), continue;end;
    count=count+1;
    B.smoking_episode{count}.starttimestamp=B.datalabel(i).starttimestamp;
    B.smoking_episode{count}.endtimestamp=B.datalabel(i).endtimestamp;
    B.smoking_episode{count}.startmatlabtime=B.datalabel(i).startmatlabtime;
    B.smoking_episode{count}.endmatlabtime=B.datalabel(i).endmatlabtime;
    B.smoking_episode{count}.puff=findpuff(G,B,B.smoking_episode{count}.starttimestamp,B.smoking_episode{count}.endtimestamp);
end
end

function puff=findpuff(G,B,stime,etime)
puffno=0;
puff=[];
for i=1:length(B.datalabel)
    if isempty(strfind(B.datalabel(i).label,'Puff')), continue;end;
    if B.datalabel(i).starttimestamp<stime, continue;end;
    if B.datalabel(i).endtimestamp>etime, continue;end;
    puffno=puffno+1;
    puff.timestamp(puffno)=B.datalabel(i).starttimestamp;
    puff.matlabtime(puffno)=B.datalabel(i).startmatlabtime;   
end
end

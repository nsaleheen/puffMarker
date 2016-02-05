function [Err_p,Err_d]=find_threshold_segmentation_gyr(G, pid,sid, INDIR,TH)
Err_p=zeros(1,TH);
Err_d=zeros(1,TH);
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' INDIR '.mat'];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);
for th=200:TH
    fprintf('th=%d\n',th);
    sample{1}=medfilt1(P.wrist{1}.magnitude.sample,17);timestamp{1}=P.wrist{1}.magnitude.timestamp;
    segment{1}=gyr_segmentation(sample{1},th,4);
    sample{2}=medfilt1(P.wrist{2}.magnitude.sample,17);timestamp{2}=P.wrist{2}.magnitude.timestamp;
    segment{2}=gyr_segmentation(sample{2},th,4);
    sind=segment{1}(1:2:end);eind=segment{1}(2:2:end);starttimestamp{1}=timestamp{1}(sind);endtimestamp{1}=timestamp{1}(eind);
    sind=segment{2}(1:2:end);eind=segment{2}(2:2:end);starttimestamp{2}=timestamp{2}(sind);endtimestamp{2}=timestamp{2}(eind);
    
    for e=1:length(P.smoking_episode)
        if isempty(P.smoking_episode{e}.puff), continue;end;
        i=P.smoking_episode{e}.puff.acl.id;
        sx=find(endtimestamp{i}-starttimestamp{i}>200);
        stime=starttimestamp{i}(sx);
        etime=endtimestamp{i}(sx);
        for p=1:length(P.smoking_episode{e}.puff.acl.starttimestamp)
            if P.smoking_episode{e}.puff.acl.missing(p)==1, continue;end;
            if P.smoking_episode{e}.puff.acl.valid(p)~=0, continue;end;
            pstime=P.smoking_episode{e}.puff.acl.starttimestamp(p)-3000;
            petime=P.smoking_episode{e}.puff.acl.endtimestamp(p)+3000;
            Err=inf;
            x=find(stime>=pstime & etime<=petime);
            if ~isempty(x),
                [a,b]=max(etime(x)-stime(x));
%                sstime=stime(x(b));eetime=etime(x(b));
                Err=(petime-pstime)-a;%(eetime-sstime);
            end
%             for x=1:length(stime)
%                 if stime(x)>=pstime && etime(x)<=petime
%                     err=(petime-pstime)-(etime(x)-stime(x));
%                     if Err>err, Err=err;end;
%                     
% %                 if stime(x)>petime, continue;end;
% %                 if etime(x)<pstime, continue;end;
% %                 if stime(x)<pstime && etime(x)>petime, continue;end;
% %                 if stime(x)>=pstime && etime(x)<=petime,
% %                     err=(petime-pstime)-(etime(x)-stime(x));
% %                 elseif etime(x)<=petime,
% %                     err=(petime-pstime)-(etime(x)-pstime);
% %                 elseif stime(x)>=pstime
% %                     err=(petime-pstime)-(petime-stime(x));
%                 end
%             end
            if Err==inf
                Err_p(th)=Err_p(th)+1;
            else
                Err_d(th)=Err_d(th)+Err*Err;
            end
        end
    end
end

end
function segment=gyr_segmentation(sample,THRESHOLD,NEAR)
segment=[];
ind=find(sample<=THRESHOLD);
if isempty(ind), return;end;
segment(1)=ind(1);
segment(2)=ind(1);
now=2;
for i=2:length(ind)
    if ind(i)<=segment(now)+NEAR, segment(now)=ind(i);
    else now=now+1;segment(now)=ind(i);now=now+1;segment(now)=ind(i);
    end
end
end

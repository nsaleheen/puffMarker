function C=curve_peak_valley(C,D,F)
if isempty(C), return;end;
C.peak_ind_all=peakfinder(C.Q9_smooth,0,[],1);
C.valley_ind_all=peakfinder(C.Q9_smooth,0,[],-1);

C.peak_ind=peakfinder(C.Q9_smooth,0.04,[],1);
C.valley_ind=peakfinder(C.Q9_smooth,0.04,[],-1);
if isempty(C.valley_ind) || isempty(C.peak_ind), C=[];return;end;
if C.valley_ind(1)<C.peak_ind(1)
    C.valley_ind=C.valley_ind(2:end);
end
if isempty(C.valley_ind), C=[];return;end;
if C.valley_ind(end)>C.peak_ind(end)
    C.valley_ind=C.valley_ind(1:end-1);
end
disp([num2str(length(C.peak_ind)) ' ' num2str(length(C.valley_ind))]); 
v=1;
len=length(C.valley_ind);
%{
while v<len-1
    p_ind=C.peak_ind(v+1);
    v_ind=C.valley_ind(v);
    while abs(C.Q9_smooth(p_ind)-C.Q9_smooth(v_ind))/abs(C.base-C.Q9_smooth(v_ind))<0.5
        if C.Q9_smooth(C.valley_ind(v+1)) < C.Q9_smooth(C.valley_ind(v))
            C.valley_ind(v)=C.valley_ind(v+1);
        end
        C.valley_ind(v+1)=[];
        C.peak_ind(v+1)=[];
        p_ind=C.peak_ind(v+1);
        v_ind=C.valley_ind(v);
    end
    len=length(C.valley_ind);
    v=v+1;
end

now=0;
C.admpass=[];
for p=1:length(C.peak_ind)-1
    p1=C.peak_ind(p);
    p2=C.peak_ind(p+1);
    len=length(find(D.sensor{SENSOR.R_ECGID}.timestamp>=C.timestamp(p1) & D.sensor{SENSOR.R_ECGID}.timestamp<=C.timestamp(p2)));
    if len<0.66*((C.timestamp(p2)-C.timestamp(p1))/1000)
        continue;
    end
    now=now+1;
    C.window(now).peak1_ind=p1;
    C.window(now).peak2_ind=p2;
    C.window(now).peak_ind_all=C.peak_ind_all(find(C.peak_ind_all>=p1 & C.peak_ind_all<=p2));
    C.window(now).valley_ind_all=C.valley_ind_all(find(C.valley_ind_all>=p1 & C.valley_ind_all<=p2));
%    C.window(now).adm_control=;
%    [v,ind]=min(C.Q9_smooth(C.window(now).valley_ind_all));
%    C.window(now).valley_ind=C.window(now).valley_ind_all(ind);
    C.window(now).valley_ind=C.valley_ind(p);
    C.window(now).dose=-1;
    sample=C.Q9_smooth(p1:p2-1);
    count=0;total=0;
    for a=max(p1,C.valley_ind(p)-15):C.valley_ind(p)
        if C.adm(a)>5
            count=count+1;
        end
        total=total+1;
    end
    if total*0.5>count
        C.admpass=[C.admpass,0];
    else
        C.admpass=[C.admpass,1];
%    starttimestamp=C.timestamp(p1);
%    midtimestamp=C.timestamp(C.valley_ind(p));
%    endtimestamp=C.timestamp(p2);
%    a=find(F.starttimestamp>=starttimestamp & F.starttimestamp<=midtimestamp);
%    b=find(F.starttimestamp>=midtimestamp & F.starttimestamp<=endtimestamp);
%    sample_l=[];
%    sample_r=[];
%    for i=a(1):a(end)
%        if length(F.sensor(3).window(i).feature)>=30
%            sample_l=[sample_l,F.sensor(3).window(i).feature(30)];
%        end
%    end
%    for i=b(1):b(end)
%        if length(F.sensor{3}.window(i).feature)>=30
%            sample_r=[sample_r,F.sensor{3}.window(i).feature(30)];
%        end
    end
    
%    C.window(now).adm_l=mean(sample_l);
%    C.window(now).adm_r=mean(sample_r);
%    C.adm(p1:C.valley_ind(p)-1)=mean(sample_l);
%    C.adm(C.valley_ind(p):p2-1)=mean(sample_r);
    
%    C.window(now).smooth=smoothn(sample,'robust');

end
if ~isfield(D.labstudy_mark,'timestamp')
    return;
end
for i=1:size(D.labstudy_mark.timestamp,2)
    [x,p1]=min(abs(C.matlab_timestamp(C.peak_ind)-D.labstudy_mark.matlab_timestamp(i)));
    p2=p1+1;
    C.window(p1).dose=D.labstudy_mark.dose(i);
    C.labstudy(i).pvp_ind(1)=C.peak_ind(p1);
    C.labstudy(i).pvp_ind(3)=C.peak_ind(p2);
    C.labstudy(i).pvp_ind(2)=C.valley_ind(p1);
 %   [x,v1]=min(abs(C.matlab_timestamp(C.valley_ind)-D.labstudy_mark.matlab_timestamp(i)));
    
%    C.labstudy(i).pvp_ind(2)=C.valley_ind(v1);
 %   while C.labstudy(i).pvp_ind(1)>C.labstudy(i).pvp_ind(2)
  %      v1=v1+1;
   %     C.labstudy(i).pvp_ind(2)=C.valley_ind(v1);
    %end
%    while C.labstudy(i).pvp_ind(3)<C.labstudy(i).pvp_ind(2)
 %       p2=p2+1;
  %      C.labstudy(i).pvp_ind(3)=C.peak_ind(p2);
   % end
    C.labstudy(i).dose=D.labstudy_mark.dose(i);
    for j=1:now
        if C.window(j).peak1_ind==C.labstudy(i).pvp_ind(1) && C.window(j).peak2_ind==C.labstudy(i).pvp_ind(3)
            C.window(j).dose=C.labstudy(i).dose;
        end
    end
end
%}
end

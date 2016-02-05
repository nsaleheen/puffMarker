function [sind,eind]=calculate_segment_gyr(sample_800,sample_8000)
res=sample_8000-sample_800;
res(isnan(res))=0;
segment=gyr_segmentation(res,0,2);
sind=segment(1:2:end);eind=segment(2:2:end);
end
function segment=gyr_segmentation(sample,THRESHOLD,NEAR)
segment=[];
ind=find(sample>THRESHOLD);
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

function rip=normalize_features(G,rip)
fno=size(rip.feature,1);
for f=1:fno
    ex=medfilt1(rip.feature(f,:),40);
    feature_dist(f,:)=rip.feature(f,:);
    feature_dist(f,:)=rip.feature(f,:)-ex;
    feature_ratio(f,:)=rip.feature(f,:);
    feature_ratio(f,:)=rip.feature(f,:)./ex;

%    ex=exponential_movingavg(rip.feature(f,:),20);
%     rip.feature_dist(f,:)=rip.feature(f,:);
%     rip.feature_dist(f,2:end)=rip.feature(f,2:end)-ex(1:end-1);
%     rip.feature_ratio(f,:)=rip.feature(f,:);
%     rip.feature_ratio(f,2:end)=rip.feature(f,2:end)./ex(1:end-1);
end
featurename=rip.featurename;
rip.feature(fno+1:fno+fno,:)=feature_dist;
x=strcat(featurename(:,:),'_dist');
rip.featurename=[rip.featurename,x];
fno1=size(rip.feature,1);
rip.feature(fno1+1:fno1+fno,:)=feature_ratio;
x=strcat(featurename(:,:),'_ratio');
rip.featurename=[rip.featurename,x];

end

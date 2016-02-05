function f=HeartRatePower34(P,f)

%rr=rrin/64;t=0;
%for i=1:length(rr)-1
%    t(i+1)=t(i)+rr(i);
%end;

%[P,f]=HeartRateLomb(rr,t);
ind=find(f>=0.3&f<=0.4);
f=sum(P(ind));

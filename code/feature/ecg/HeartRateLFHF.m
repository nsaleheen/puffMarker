function f=HeartRateLFHF(P,f)

%rr=rrin/64;t=0;
%for i=1:length(rr)-1
%    t(i+1)=t(i)+rr(i);
%end;

%[P,f]=HeartRateLomb(rr,t);

ind1=find(f<0.09);
ind2=find(f>0.09&f<0.15);
f=sum(P(ind1))/sum(P(ind2));

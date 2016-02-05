function C=curve_base(C,D)
val=winsorize(C.Q9_smooth);
%C.C9_envelope_winsorize=val;
if ~isfield(D.labstudy_mark,'timestamp')
    acl_pass=quantile(C.acl(:,30),0.5);
    ind=find(C.acl(:,30)<=acl_pass);
	C.base=mean(val(ind));
else
	minv=min(D.labstudy_mark.timestamp)-30*60*1000; %30 mins
	maxv=max(D.labstudy_mark.timestamp);
	maxv=maxv+1*60*60*1000;		%1 hour
	ind1=find(C.timestamp<minv | C.timestamp>maxv);
    acl_pass=quantile(C.acl(:,27),0.25);
    ind2=find(C.acl(:,27)<=acl_pass);
    ind=intersect(ind1,ind2);
    C.base=mean(val(ind));
end

end
function ind=pass_admin(C)
    acl_pass=quantile(C.acl(:,30),0.3);
    ind=find(C.acl(:,30)<=acl_pass);
end
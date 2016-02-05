function [sample,timestamp,matlabtime]=saveGoodData(G,sample_all,timestamp_all,matlabtime_all,quality)
sample=[];timestamp=[];matlabtime=[];
ind=find(quality.value==G.QUALITY.GOOD);
for i=ind
    s=quality.starttimestamp(i);
    t=quality.endtimestamp(i);
    ind=find(timestamp_all>=s & timestamp_all<=t);
    sample=[sample sample_all(ind)];
    timestamp=[timestamp timestamp_all(ind)];
	matlabtime=[matlabtime matlabtime_all(ind)];
end
end

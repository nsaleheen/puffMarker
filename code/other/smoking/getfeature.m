function [ insp,expr,height ] = getfeature( G,pid,sid,eno,INDIR )
indir=[G.DIR.DATA G.DIR.SEP INDIR];
infile=[pid '_' sid '_' G.FILE.BASICFEATURE_MATNAME];
if exist([indir G.DIR.SEP infile],'file')~=2,return;end
load([indir G.DIR.SEP infile]);

for ind=2:2:length(B.sensor{1}.peakvalley.timestamp)
    insp_a(ind)=B.sensor{1}.peakvalley.timestamp(ind)-B.sensor{1}.peakvalley.timestamp(ind-1);
    expr_a(ind)=B.sensor{1}.peakvalley.timestamp(ind+1)-B.sensor{1}.peakvalley.timestamp(ind);
    stime=B.sensor{1}.peakvalley.timestamp(ind-1);
    mtime=B.sensor{1}.peakvalley.timestamp(ind);
    etime=B.sensor{1}.peakvalley.timestamp(ind+1);
    x=find(B.sensor{1}.timestamp>=stime & B.sensor{1}.timestamp<=etime);
    sample=B.sensor{1}.sample(x);
    height_a(ind)=max(sample)-min(sample);
    
end
insp_a=insp_a(2:2:end);
expr_a=expr_a(2:2:end);
height_a=height_a(2:2:end);

[insp_m,insp_d]=get_mean_std(insp_a);
[expr_m,expr_d]=get_mean_std(expr_a);
[height_m,height_d]=get_mean_std(height_a);



puff_peak_ind=B.cress.puff_peak{eno};
for p=1:length(puff_peak_ind)
    ind=puff_peak_ind(p);
    insp(p)=B.sensor{1}.peakvalley.timestamp(ind)-B.sensor{1}.peakvalley.timestamp(ind-1);
    expr(p)=B.sensor{1}.peakvalley.timestamp(ind+1)-B.sensor{1}.peakvalley.timestamp(ind);
    stime=B.sensor{1}.peakvalley.timestamp(ind-1);
    mtime=B.sensor{1}.peakvalley.timestamp(ind);
    etime=B.sensor{1}.peakvalley.timestamp(ind+1);
    x=find(B.sensor{1}.timestamp>=stime & B.sensor{1}.timestamp<=etime);
    sample=B.sensor{1}.sample(x);
    height(p)=max(sample)-min(sample);
    %B.sensor{1}.
    
end
insp=(insp-insp_m)./insp_d;
expr=(expr-expr_m)./expr_d;
height=(height-height_m)./height_d;

end

function [mn,sd]=get_mean_std(data)
x=prctile(data,5);
y=prctile(data,95);
data_n=data(find(data>=x & data<=y));
mn=mean(data_n);
sd=std(data_n);

end

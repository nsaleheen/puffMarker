close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
%G=config_run_monowar_Memphis_Smoking(G);

PS_LIST=G.PS_LIST;
Err_p=zeros(1,300);Err_d=zeros(1,300);
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        fprintf('%s %s\n',pid,sid);
        [err_p,err_d]=find_threshold_segmentation_gyr(G,pid,sid,'segment',300);
        Err_p=Err_p+err_p;
        Err_d=Err_d+err_d;
    end
end
ind=200:300;
x=min(Err_p(ind));
y=find(Err_p(ind)==x);
[a,b]=min(Err_d(ind(y)));
fprintf('Puff Error=%d, distance error=%f Threshold=%d\n',x,a/1000,ind(y(b)));
disp('abc');

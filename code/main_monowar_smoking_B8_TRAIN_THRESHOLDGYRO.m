close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
%G=config_run_monowar_Memphis_Smoking(G);
TH=300;
Err_p=zeros(1,TH);Err_d=zeros(1,TH);MinDist=inf;MaxDist=0;
PS_LIST=G.PS_LIST;
for p=1:size(PS_LIST,1)
    pid=char(PS_LIST{p,1});
    slist=PS_LIST{p,2};
    for s=slist
        sid=char(s);
        fprintf('%s %s\n',pid,sid);
        
        INDIR='segment_acl';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];if exist([indir G.DIR.SEP infile],'file')~=2,return;end;load([indir G.DIR.SEP infile]);
        [err_p,err_d,mindist,maxdist]=find_threshold_1_segmentation_gyr(G,P,TH);
        Err_p=Err_p+err_p;
        Err_d=Err_d+err_d;
        if mindist<MinDist, MinDist=mindist;end;
        if maxdist>MaxDist, MaxDist=maxdist;end;
        Err_p(10:10:TH)
        MinDist
        MaxDist
    end
end
x=min(Err_p);
y=find(Err_p==x);
[a,b]=min(Err_d(y));
fprintf('Puff Error=%d, distance error=%f Threshold=%d\n',x,a/1000,y(b));
fprintf('Min Distance=%.2f Max Distance=%.2f\n',MinDist,MaxDist);
disp('abc');

% Puff Error=0, distance error=29.321000 Threshold=59
% Min Distance=375.00 Max Distance=5812.50
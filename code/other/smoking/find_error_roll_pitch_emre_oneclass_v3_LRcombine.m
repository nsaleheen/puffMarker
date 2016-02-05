function A=find_error_roll_pitch_emre_oneclass_v3_LRcombine(R)
A=[];
% 1: roll, 2: pitch, 3: roll+pitch 4: mhl

[A.roll,A.pitch]=find_roll_pitch_sample(R);
A.rp{1}=A.roll;
A.rp{2}=A.pitch;
ind=find(A.roll.puff==1);
rollpitch_puff=[A.roll.sample(ind)',A.pitch.sample(ind)'];
rollpitch_all=[A.roll.sample',A.pitch.sample'];

mhl=mahal(rollpitch_all,rollpitch_puff);

%x(1)=rollpitch_all(1,1);
%x(2)=rollpitch_all(1,2);
%(x-mn)*inv(sigma)*(x-mn)'
for s=1:length(A.rp{1}.sample)
    [A.rp{1}.p_error(s),A.rp{1}.np_error(s)]=find_error(A.rp{1},s);
    [A.rp{2}.p_error(s),A.rp{2}.np_error(s)]=find_error(A.rp{2},s);
    A.puff_nonpuff{1}.error(s)=A.rp{1}.p_error(s);
    A.puff_nonpuff{2}.error(s)=A.rp{2}.p_error(s);
    A.puff_nonpuff{3}.error(s)=(A.rp{1}.p_error(s)+A.rp{2}.p_error(s));
    A.mark(s)=A.rp{1}.puff(s);
    A.puff_nonpuff{4}.error(s)=mhl(s);
    A.puff_nonpuff{4}.SIGMA=cov(rollpitch_puff);
    A.puff_nonpuff{4}.MEAN=mean(rollpitch_puff);
end
A=generate_roc_curve(A);
puff_ind=find(A.mark==1);
nonpuff_ind=find(A.mark==0);
for j=1:4
    FN=length(find(A.puff_nonpuff{j}.error(puff_ind)>A.puff_nonpuff{j}.th_100));
    FP=length(find(A.puff_nonpuff{j}.error(nonpuff_ind)<=A.puff_nonpuff{j}.th_100));
    TP=length(find(A.puff_nonpuff{j}.error(puff_ind)<=A.puff_nonpuff{j}.th_100));
    TN=length(find(A.puff_nonpuff{j}.error(nonpuff_ind)>A.puff_nonpuff{j}.th_100));
    hand='LR';
    if j==1, type='r '; elseif j==2, type=' p'; elseif j==3, type='rp'; else, type='mh'; end;
    fprintf('hand=%s  type=%s   PUFF=%4d (TP=%4d FN=%4d)   NONPUFF=%4d (TN=%4d FP=%4d)   TOT=%4d\n',hand,type,TP+FN, TP,FN,TN+FP,TN,FP,TP+FN+TN+FP);
end
disp('here');
end

function A=generate_roc_curve(A)
h=figure;hold on;
[A.puff_nonpuff{1}.TP,A.puff_nonpuff{1}.FP,A.puff_nonpuff{1}.TH]=roc_curve(A.puff_nonpuff{1}.error,A.mark,'r-');A.puff_nonpuff{1}.th_100=A.puff_nonpuff{1}.TH(min(find(A.puff_nonpuff{1}.TP==1)));
[A.puff_nonpuff{2}.TP,A.puff_nonpuff{2}.FP,A.puff_nonpuff{2}.TH]=roc_curve(A.puff_nonpuff{2}.error,A.mark,'g-');A.puff_nonpuff{2}.th_100=A.puff_nonpuff{2}.TH(min(find(A.puff_nonpuff{2}.TP==1)));
[A.puff_nonpuff{3}.TP,A.puff_nonpuff{3}.FP,A.puff_nonpuff{3}.TH]=roc_curve(A.puff_nonpuff{3}.error,A.mark,'b-');A.puff_nonpuff{3}.th_100=A.puff_nonpuff{3}.TH(min(find(A.puff_nonpuff{3}.TP==1)));
[A.puff_nonpuff{4}.TP,A.puff_nonpuff{4}.FP,A.puff_nonpuff{4}.TH]=roc_curve(A.puff_nonpuff{4}.error,A.mark,'k-');A.puff_nonpuff{4}.th_100=A.puff_nonpuff{4}.TH(min(find(A.puff_nonpuff{4}.TP==1)));

xlabel('False Positive Rate','FontSize',16);ylabel('True Positive Rate','FontSize',20);
title('ROC curve for Puff & NonPuff (Both Hand)','FontSize',16);
%title({['ROC curve for Puff & NonPuff (Right Hand)'];['Threshold for 100% TP: '];['roll=' num2str(th_r_100) ' pitch=' num2str(th_p_100) ' roll+pitch=' num2str(th_pr_100)]},'FontSize',16);
legend('Roll','Pitch','Roll+Pitch','Mahalanobis Distance','Location','SouthEast');
print(h,'-depsc','D:\smoking_memphis\data\Memphis_Smoking_Lab\smoking_fig\segment\ROC_bothhand.eps');
saveas(h,'D:\smoking_memphis\data\Memphis_Smoking_Lab\smoking_fig\segment\ROC_bothhand.png','png');
end
function [TP,FP,th]=roc_curve(error,mark,colorr)
now=0;
for p=0.1:0.1:100
    now=now+1;
    v=prctile(error,p);
    ind=find(mark==1);
    TP(now)=length(find(error(ind)<=v))/(length(ind));
    ind=find(mark==0);
    FP(now)=length(find(error(ind)<=v))/length(ind);
    th(now)=v;
end
plot(FP,TP,colorr,'linewidth',2);
end
function [p_error,np_error]=find_error(data,loc)
sample=data.sample(loc);
p_error=((sample-data.p_mean)*(sample-data.p_mean))/(data.p_std*data.p_std);
np_error=((sample-data.np_mean)*(sample-data.np_mean))/(data.np_std*data.np_std);
end

function [roll,pitch]=find_roll_pitch_sample(R)
p_ind=find(R.puff==1);
v_ind=find(R.valid==0);
npe_ind=find(R.episode==0);np_ind=setdiff(v_ind,p_ind);np_ind=intersect(np_ind,npe_ind);
roll.sample=[R.roll_median(np_ind),R.roll_median(p_ind)];
roll.puff=zeros(1,length(roll.sample));roll.puff(length(R.roll_median(np_ind))+1:end)=1;
pitch.sample=[R.pitch_median(np_ind),R.pitch_median(p_ind)];
pitch.puff=zeros(1,length(pitch.sample));pitch.puff(length(R.pitch_median(np_ind))+1:end)=1;
ind=find(isnan(roll.sample));roll.sample(ind)=[];roll.puff(ind)=[];pitch.sample(ind)=[];pitch.puff(ind)=[];
ind=find(isnan(pitch.sample));roll.sample(ind)=[];roll.puff(ind)=[];pitch.sample(ind)=[];pitch.puff(ind)=[];
ind=find(roll.puff==0);roll.np_mean=mean(roll.sample(ind));roll.np_std=std(roll.sample(ind));
ind=find(roll.puff==1);roll.p_mean=mean(roll.sample(ind));roll.p_std=std(roll.sample(ind));
ind=find(pitch.puff==0);pitch.np_mean=mean(pitch.sample(ind));pitch.np_std=std(pitch.sample(ind));
ind=find(pitch.puff==1);pitch.p_mean=mean(pitch.sample(ind));pitch.p_std=std(pitch.sample(ind));

end

function plot_hist_roll_pitch_emre(R)
plot_scatter_roll_pitch(R);
plot_hist_pitch(R);
plot_hist_roll(R);
end
function plot_scatter_roll_pitch(R)
lp_ind=find(R{1}.puff==1);rp_ind=find(R{2}.puff==1);
lv_ind=find(R{1}.valid==0);rv_ind=find(R{2}.valid==0);
lnpe_ind=find(R{1}.episode==0);lnp_ind=setdiff(lv_ind,lp_ind);lnp_ind=intersect(lnp_ind,lnpe_ind);
rnpe_ind=find(R{2}.episode==0);rnp_ind=setdiff(rv_ind,rp_ind);rnp_ind=intersect(rnp_ind,rnpe_ind);
lnp_roll_median=R{1}.roll_median(lnp_ind);lp_roll_median=R{1}.roll_median(lp_ind);
rnp_roll_median=R{2}.roll_median(rnp_ind);rp_roll_median=R{2}.roll_median(rp_ind);
lnp_pitch_median=R{1}.pitch_median(lnp_ind);lp_pitch_median=R{1}.pitch_median(lp_ind);
rnp_pitch_median=R{2}.pitch_median(rnp_ind);rp_pitch_median=R{2}.pitch_median(rp_ind);

% Scatter Plot (Roll-Pitch)
h=figure;hold on;
scatter(rnp_roll_median,rnp_pitch_median,'b','fill');
scatter(rp_roll_median,rp_pitch_median,'r','fill');
end
function plot_hist_roll(R)
lp_ind=find(R{1}.puff==1);rp_ind=find(R{2}.puff==1);
fprintf('# of puff=%d, # of puff (left hand)=%d, # of puff (right hand)=%d\n',length(lp_ind)+length(rp_ind),length(lp_ind),length(rp_ind));

lv_ind=find(R{1}.valid==0);rv_ind=find(R{2}.valid==0);
fprintf('# of segment(L)=%d, # of valid segment(L)=%d,\n',length(R{1}.valid),length(lv_ind));
fprintf('# of segment(R)=%d, # of valid segment(R)=%d,\n',length(R{2}.valid),length(rv_ind));
lnpe_ind=find(R{1}.episode==0);lnp_ind=setdiff(lv_ind,lp_ind);lnp_ind=intersect(lnp_ind,lnpe_ind);
rnpe_ind=find(R{2}.episode==0);rnp_ind=setdiff(rv_ind,rp_ind);rnp_ind=intersect(rnp_ind,rnpe_ind);
lnp_roll_median=R{1}.roll_median(lnp_ind);lp_roll_median=R{1}.roll_median(lp_ind);
rnp_roll_median=R{2}.roll_median(rnp_ind);rp_roll_median=R{2}.roll_median(rp_ind);
[a,b]=hist(lnp_roll_median,-180:10:180);[c,d]=hist(lp_roll_median,-180:10:180);
[e,f]=hist(rnp_roll_median,-180:10:180);[g,h]=hist(rp_roll_median,-180:10:180);

% roll all
h=figure;bar(b, [a/sum(a)*100; c/sum(c)*100;e/sum(e)*100;g/sum(g)*100]','hist');
legend('Left hand roll(Non puff)','Left hand roll (Puff)','Right hand roll(Non puff)','Right hand roll (Puff)');
xlabel('degree','FontSize',20);ylabel('Percentage','FontSize',20);
title('Median roll (Lefthand,Righthand & Puff,Nonpuff)','FontSize',20);grid;
saveas(h,'C:\Users\smh\Desktop\smoking_fig\emre_roll_pitch_histogram\median_roll_Left_Right_Puff_Nonpuff.png','png');
close(h);
%roll_puff
h=figure;bar(b, [c/sum(c)*100;g/sum(g)*100]','hist');
legend('Left hand roll (Puff)','Right hand roll (Puff)');
xlabel('degree','FontSize',20);ylabel('Percentage','FontSize',20);
title('Median roll (Lefthand,Righthand & Puff)','FontSize',20);grid;
saveas(h,'C:\Users\smh\Desktop\smoking_fig\emre_roll_pitch_histogram\median_roll_Left_Right_Puff.png','png');
close(h);
%roll_lefthand
h=figure;bar(b, [c/sum(c)*100;a/sum(a)*100]','hist');
legend('Left hand roll (Puff)','left hand roll (NonPuff)');
xlabel('degree','FontSize',20);ylabel('Percentage','FontSize',20);
title('Median roll (Lefthand & Puff,Nonpuff)','FontSize',20);grid;
saveas(h,'C:\Users\smh\Desktop\smoking_fig\emre_roll_pitch_histogram\median_roll_Left_Puff_Nonpuff.png','png');
close(h);
%roll_righthand
h=figure;bar(b, [g/sum(g)*100;e/sum(e)*100]','hist');
legend('Right hand roll (Puff)','Right hand roll (NonPuff)');
xlabel('degree','FontSize',20);ylabel('Percentage','FontSize',20);
title('Median roll (Righthand & Puff,Nonpuff)','FontSize',20);grid;
saveas(h,'C:\Users\smh\Desktop\smoking_fig\emre_roll_pitch_histogram\median_roll_Right_Puff_Nonpuff.png','png');
close(h);
end

function plot_hist_pitch(R)
lp_ind=find(R{1}.puff==1);rp_ind=find(R{2}.puff==1);
fprintf('# of puff=%d, # of puff (left hand)=%d, # of puff (right hand)=%d\n',length(lp_ind)+length(rp_ind),length(lp_ind),length(rp_ind));

lv_ind=find(R{1}.valid==0);rv_ind=find(R{2}.valid==0);
fprintf('# of segment(L)=%d, # of valid segment(L)=%d,\n',length(R{1}.valid),length(lv_ind));
fprintf('# of segment(R)=%d, # of valid segment(R)=%d,\n',length(R{2}.valid),length(rv_ind));
lnpe_ind=find(R{1}.episode==0);lnp_ind=setdiff(lv_ind,lp_ind);lnp_ind=intersect(lnp_ind,lnpe_ind);
rnpe_ind=find(R{2}.episode==0);rnp_ind=setdiff(rv_ind,rp_ind);rnp_ind=intersect(rnp_ind,rnpe_ind);
lnp_pitch_median=R{1}.pitch_median(lnp_ind);lp_pitch_median=R{1}.pitch_median(lp_ind);
rnp_pitch_median=R{2}.pitch_median(rnp_ind);rp_pitch_median=R{2}.pitch_median(rp_ind);


[a,b]=hist(lnp_pitch_median,-90:10:90);[c,d]=hist(lp_pitch_median,-90:10:90);
[e,f]=hist(rnp_pitch_median,-90:10:90);[g,h]=hist(rp_pitch_median,-90:10:90);

% pitch all
h=figure;bar(b, [a/sum(a)*100; c/sum(c)*100;e/sum(e)*100;g/sum(g)*100]','hist');
legend('Left hand Pitch(Non puff)','Left hand Pitch (Puff)','Right hand Pitch(Non puff)','Right hand Pitch (Puff)');
xlabel('degree','FontSize',20);ylabel('Percentage','FontSize',20);
title('Median Pitch (Lefthand,Righthand & Puff,Nonpuff)','FontSize',20);grid;
saveas(h,'C:\Users\smh\Desktop\smoking_fig\emre_roll_pitch_histogram\median_pitch_Left_Right_Puff_Nonpuff.png','png');
close(h);
%pitch_puff
h=figure;bar(b, [c/sum(c)*100;g/sum(g)*100]','hist');
legend('Left hand Pitch (Puff)','Right hand Pitch (Puff)');
xlabel('degree','FontSize',20);ylabel('Percentage','FontSize',20);
title('Median Pitch (Lefthand,Righthand & Puff)','FontSize',20);grid;
saveas(h,'C:\Users\smh\Desktop\smoking_fig\emre_roll_pitch_histogram\median_pitch_Left_Right_Puff.png','png');
close(h);
%pitch_lefthand
h=figure;bar(b, [c/sum(c)*100;a/sum(a)*100]','hist');
legend('Left hand Pitch (Puff)','left hand Pitch (NonPuff)');
xlabel('degree','FontSize',20);ylabel('Percentage','FontSize',20);
title('Median Pitch (Lefthand & Puff,Nonpuff)','FontSize',20);grid;
saveas(h,'C:\Users\smh\Desktop\smoking_fig\emre_roll_pitch_histogram\median_pitch_Left_Puff_Nonpuff.png','png');
close(h);
%pitch_righthand
h=figure;bar(b, [g/sum(g)*100;e/sum(e)*100]','hist');
legend('Right hand Pitch (Puff)','Right hand Pitch (NonPuff)');
xlabel('degree','FontSize',20);ylabel('Percentage','FontSize',20);
title('Median Pitch (Righthand & Puff,Nonpuff)','FontSize',20);grid;
saveas(h,'C:\Users\smh\Desktop\smoking_fig\emre_roll_pitch_histogram\median_pitch_Right_Puff_Nonpuff.png','png');
close(h);
end

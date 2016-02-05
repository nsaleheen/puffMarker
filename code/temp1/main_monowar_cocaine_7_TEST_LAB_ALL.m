function main_monowar_cocaine_7_TEST_LAB_ALL()
clear all
fig=0;
G=config();
G=config_run_monowar_jhu(G);
%DOSE=40;
%tau2=0.0196;
[TOT,C_PASS,A_PASS,C_FAIL,A_FAIL,MA,MC,D,O]=main_monowar_cocaine_7_TEST_LAB(G,fig);
%[TOT,C_PASS,A_PASS,C_FAIL,A_FAIL,MA,MC,D,O]=main_monowar_cocaine_7_TEST_LAB_DOSE(G,fig,DOSE,tau2);

G=config();
G=config_run_monowar_NIDAc(G);
[tot,c_pass,a_pass,c_fail,a_fail,ma,mc,d,o]=main_monowar_cocaine_7_TEST_LAB(G,fig);
%[tot,c_pass,a_pass,c_fail,a_fail,ma,mc,d,o]=main_monowar_cocaine_7_TEST_LAB_DOSE(G,fig,DOSE,tau2);
TOT=TOT+tot;C_PASS=C_PASS+c_pass;A_PASS=A_PASS+a_pass;C_FAIL=C_FAIL+c_fail;A_FAIL=A_FAIL+a_fail;MA=[MA ma];MC=[MC mc];D=[D d];O=[O o];

ACC=0;
MCA=MC./MA;
%TOT=TOT-length(C)-length(N);
k=0;TP=[];FP=[];
fid1=fopen('lab_test_all_roc_mse.txt','w');

for i=min(MCA)-0.01:0.001:max(MCA)+0.01
    v=i;
    indc=find(O>0);
    no_c=length(find(O>0));
    inda=find(O==0);
    no_a=length(O)-no_c;
    c_c=length(find(MCA(indc)<=v));
    c_i=length(find(MCA(indc)>v))+C_FAIL;
    a_c=length(find(MCA(inda)>v))+A_FAIL;
    a_i=length(find(MCA(inda)<=v));
    acc=(c_c+a_c)/(c_c+c_i+a_c+a_i);
    fprintf(fid1,'th=%f,acc=%f,c_c=%d,c_i=%d,a_c=%d,a_i=%d,TPR=%f,FPR=%f,PPV=%f,NPV=%f\n',i,acc*100,c_c, c_i, a_c, a_i,100*c_c/(c_c+c_i),100*a_i/(a_c+a_i),100*c_c/(c_c+a_i),100*a_c/(a_c+c_i));
         fprintf('th=%f acc=%f c_c=%d c_i=%d a_c=%d a_i=%d TPR=%f FPR=%f PPV=%f NPV=%f\n',i,acc,c_c, c_i, a_c, a_i,c_c/(c_c+c_i),a_i/(a_c+a_i),c_c/(c_c+a_i),a_c/(a_c+c_i));
    
    if acc>ACC,ACC=acc;OC_C=c_c;OA_C=a_c;OC_I=c_i; OA_I=a_i;end;
    k=k+1;
    TP(k)=c_c/(c_c+c_i);
    FP(k)=a_i/(a_c+a_i);
end
fclose(fid1);
LROC.TP=TP;
LROC.FP=FP;
save('LROC.mat','LROC');
return;
h=figure; plot(FP,TP,'r-','linewidth',2);
xlabel('False Positive Rate', 'FontSize', 22,'FontName','Times New Roman');
ylabel('True Positive Rate', 'FontSize', 22,'FontName','Times New Roman');

set(0,'DefaultAxesFontSize', 22);
set(0,'DefaultTextFontSize', 22);

set(gca,'FontSize',22,'FontName','Times New Roman');
set(findall(gcf,'type','text'),'FontSize',22,'FontName','Times New Roman')

xlim([0,0.4]);
ylim([0,1]);
print('ROC_LAB', '-dpng', '-r300');
print('ROC_LAB', '-depsc', '-r300');
print('ROC_LAB', '-dtiff', '-r300');
TP=[];FP=[];k=0;
end


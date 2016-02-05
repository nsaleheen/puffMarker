function main_monowar_cocaine_7_TEST_FIELD_ALL()
clear all
G=config();
G=config_run_monowar_nida(G);
PS_LIST=G.PS_LIST;
%main_monowar_cocaine_5_TEST_PREP(G,PS_LIST);
%return;
%load([G.STUDYNAME '_test.mat']);
%load('nida_train.mat');
%load('nida_tau.mat');
%MA=[];MC=[];TOT=0;D=[];O=[];
%C_C=0;C_I=0;A_C=0;A_I=0;
fig=0;
[TOT,C_PASS,A_PASS,C_FAIL,A_FAIL,MA,MC,D,O]=main_monowar_cocaine_7_TEST_LAB(G,fig);

ACC=0;
MCA=MC./MA;
%TOT=TOT-length(C)-length(N);
k=0;TP=[];FP=[];
fid1=fopen([G.STUDYNAME '_all_roc_mse.txt'],'w');

for i=min(MCA)-0.01:0.001:max(MCA)+0.01
    v=i;
    ind=find(O>0);
    ind1=find(O==0);
    %no_a=length(O)-no_c;
    c_c=length(find(MCA(ind)<=v));
    c_i=length(find(MCA(ind)>v))+C_FAIL;
    a_c=length(find(MCA(ind1)>v))+A_FAIL;
    a_i=length(find(MCA(ind1)<=v));
    acc=(c_c+a_c)/(c_c+c_i+a_c+a_i);
    fprintf(fid1,'th=%f,acc=%f,c_c=%d,c_i=%d,a_c=%d,a_i=%d,TPR=%f,FPR=%f,PPV=%f,NPV=%f\n',i,acc*100,c_c, c_i, a_c, a_i,100*c_c/(c_c+c_i),100*a_i/(a_c+a_i),100*c_c/(c_c+a_i),100*a_c/(a_c+c_i));
         fprintf('th=%f acc=%f c_c=%d c_i=%d a_c=%d a_i=%d TPR=%f FPR=%f PPV=%f NPV=%f\n',i,acc,c_c, c_i, a_c, a_i,c_c/(c_c+c_i),a_i/(a_c+a_i),c_c/(c_c+a_i),a_c/(a_c+c_i));
    
    if acc>ACC,ACC=acc;OC_C=c_c;OA_C=a_c;OC_I=c_i; OA_I=a_i;end;
    k=k+1;
    TP(k)=c_c/(c_c+c_i);
    FP(k)=a_i/(a_c+a_i);
end
fclose(fid1);
FROC.TP=TP;
FROC.FP=FP;
save('FROC.mat','FROC');
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

print([G.STUDYNAME '_ROC'], '-dpng', '-r300');
print([G.STUDYNAME '_ROC'], '-depsc', '-r300');
print([G.STUDYNAME '_ROC'], '-dtiff', '-r300');
TP=[];FP=[];k=0;
end


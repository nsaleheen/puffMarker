close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
%G=config_run_monowar_Memphis_Smoking(G);

G=main_monowar_smoking_E0_CONFIG_SVM(G);
%MODEL=G.SVM.RIP_MPUFF_ROC_WRIST_MRP_TIME;
figure;hold on;
load(G.SVM.WRIST_MRP.NAME);plot(RC.FPRR,RC.TPRR,'b-','linewidth',2);
load(G.SVM.RIP_MPUFF_ROC.NAME);plot(RC.FPRR,RC.TPRR,'g-','linewidth',2);
load(G.SVM.RIP_MPUFF_ROC_WRIST_MRP_TIME.NAME);plot(RC.FPRR,RC.TPRR,'r-','linewidth',2);

xlabel('False Positive (per hour)');
ylabel('True Positive Rate');
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold');
set(gca,'FontSize',16,'fontWeight','bold');
leg={'Respiration Features','Hand Gesture Features','Respiration + Hand Gesture Features'};
legend(leg,'location','southeast');
xlim([0,40]);
%yticklabel([0.0:0.1:1.0]);
disp('abc');
filename=['C:\Users\smh\Desktop\smoking_fig' G.DIR.SEP  'rip_wrist_feature_ROC'];
print('-dpng','-r100',[filename '.png']);
print('-depsc',[filename '.eps']);


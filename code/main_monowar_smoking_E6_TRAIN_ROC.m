function main_monowar_smoking_E6_TRAIN_ROC()
close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking_Lab(G);
TIME=36.7;
[FPRR1,TPRR1]=read_roc_weka([G.DIR.DATA '/weka/1.arff']);
[FPRR2,TPRR2]=read_roc_weka([G.DIR.DATA '/weka/2.arff']);
[FPRR3,TPRR3]=read_roc_weka([G.DIR.DATA '/weka/3.arff']);
figure;hold on;
plot(FPRR1/TIME,TPRR1,'g-','linewidth',2);
plot(FPRR2/TIME,TPRR2,'b-','linewidth',2);
plot(FPRR3/TIME,TPRR3,'r-','linewidth',2);

xlabel('False Positive (per hour)');
ylabel('True Positive Rate');
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold');
set(gca,'FontSize',16,'fontWeight','bold');
leg={'Respiration Features','Hand Gesture Features','Respiration + Hand Gesture Features'};
legend(leg,'location','southeast');
xlim([0,60]);
%yticklabel([0.0:0.1:1.0]);
disp('abc');
filename=['C:\Users\smh\Desktop\smoking_fig' G.DIR.SEP  'rip_wrist_feature_ROC'];
print('-dpng','-r100',[filename '.png']);
print('-depsc',[filename '.eps']);
end
function [FPRR,TPRR]=read_roc_weka(filename)
values=csvread(filename);
FPRR=values(:,4);
TPRR=values(:,7);
end

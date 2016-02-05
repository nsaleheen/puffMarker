function main_monowar_smoking_Z1_EMRE_EPISODE()
close all
clear all
G=config();
%G=config_run_monowar_Memphis_Smoking_Lab(G);
G=config_run_monowar_Memphis_Smoking(G);
%pid='p10';sid='s02';
pid='p11';sid='s01';
INDIR='svm_output';indir=[G.DIR.DATA G.DIR.SEP INDIR];infile=[pid '_' sid '_' INDIR '.mat'];load([indir G.DIR.SEP infile]);
x=find(P.wrist{1}.gyr.segment.svm_predict==1);
S.wrist{1}.puff_time=P.wrist{1}.gyr.segment.endtimestamp(x);
x=find(P.wrist{2}.gyr.segment.svm_predict==1);
S.wrist{2}.puff_time=P.wrist{2}.gyr.segment.endtimestamp(x);
S.selfreport= P.selfreport{2}.timestamp(3:end);
save(['C:\Users\smh\Desktop\smoking_fig\emre_data\' pid '_' sid '.mat'],'S');

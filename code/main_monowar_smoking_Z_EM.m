% Both for NIDA and JHU
% Operation: RR interval, Activity feature Standard Daviation of magnitude
close all
clear all
G=config();
G=config_run_monowar_Memphis_Smoking(G);
load('matx.mat');
X=matx(:,1:3);
[m,n]=size(X);
R=ones(m,1);
K=3;
max_iter=25;
[theta, mu, sigma, pz]=mogEMFull(X,R,K,max_iter);
disp('abc');
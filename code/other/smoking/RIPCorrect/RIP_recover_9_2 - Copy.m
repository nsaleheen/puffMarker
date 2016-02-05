% close all;
clear all;
clc;
load('p01_s04_frmtdata.mat');
RIP = D.sensor{1}.sample_all;
RIP = RIP-mean(RIP);
% figure;
% plot(RIP);

%% Linear Interpolation
T_RIP = diff(D.sensor{1,1}.timestamp_all);
[RIP_new, interp_idx] = Linear_interpolate_autosense(RIP,T_RIP);


%% Passing through the system

input = RIP_new; % For linear interp input RIP_new, HP interp input RIP_new1
Fs = 64/3;
output = recover_RIP_auto(input,Fs);
% t = 0:1/Fs:(length(output)-1)/Fs;
t = 0:length(output)-1;
% figure;
% h1 = plot(input,'color',[0 0 0]);
% hold on;
% plot(t(interp_idx), input(interp_idx),'r.');
% hold on;
% h2 = plot(output,'color',[0 0 1]);
% legend([h1,h2],'Original RIP','Recovered RIP');
% % title('tf([1,2],[1,0.1])');
% xlabel('Samples');
% ylabel('Amplitude');

D = moving_avg(output,Fs,15);
output_SubD = output'-D;
figure;
h5 = plot(input,'color',[0 0 0]);
hold on;
h6 = plot(output,'color',[0 0 1]);
% hold on;
% plot(t(interp_idx), input(interp_idx),'r.');
hold on;
h7 = plot(output_SubD,'r');
hold on;
h8 = plot(D,'m');
legend([h5,h6,h7,h8],'Original RIP','Recoveryed RIP','Recovered RIP Drift Subtracted','Drift');
xlabel('Samples');
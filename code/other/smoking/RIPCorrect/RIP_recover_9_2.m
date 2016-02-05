% close all;
function newsample=RIP_recover(sample,timestamp)
%clear all;
%clc;
%load('p03_s03_frmtdata.mat');
%DD=D;
%RIP=D.sensor{1}.sample;
%RIPT=D.sensor{1}.timestamp;
RIP=sample;
RIPT=timestamp;

RIP = RIP-mean(RIP);
% figure;
% plot(RIP);

%% Linear Interpolation
%T_RIP = diff(D.sensor{1,1}.timestamp);
%[RIP_new, interp_idx] = Linear_interpolate_autosense(RIP,T_RIP);
RIP_new=RIP;

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

D = moving_avg_rip(output,Fs,15);
output_SubD = output'-D;
%figure;
%h5 = plot(RIPT,input,'color',[0 0 0]);
%hold on;
%h6 = plot(RIPT,output,'color',[0 0 1]);
% hold on;
% plot(t(interp_idx), input(interp_idx),'r.');
%hold on;
%h7 = plot(RIPT,output_SubD,'r');
%hold on;
%h8 = plot(RIPT,D,'m');
%legend([h5,h6,h7,h8],'Original RIP','Recoveryed RIP','Recovered RIP Drift Subtracted','Drift');
%xlabel('Samples');
newsample=output_SubD;
end
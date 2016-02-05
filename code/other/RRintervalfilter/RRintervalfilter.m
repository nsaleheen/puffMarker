clear;
clc;
close all;
load('p01_s01_basicfeature.mat');
RR = B.sensor{1,2}.rr.sample;
seg = 15;
[RR_new, time_new]=preprocess(RR,seg);
figure;
plot(time_new,RR_new)
xlabel('time/sec');
ylabel('RRinterval/sec');
title('before filtering');
RR_fil = filter_RR(RR_new,seg);
% figure
% spectrogram(RR_fil,64);
figure;
plot(time_new,RR_fil);
xlabel('time/sec');
ylabel('RRinterval/sec');
title('after filtering');
    
    
    
    
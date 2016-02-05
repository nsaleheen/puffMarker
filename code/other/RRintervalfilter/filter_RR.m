function RR_fil = filter_RR(RR_new,seg)
fs = 1/seg;
f = [0 1/120*2/fs 1/110*2/fs 1]; 
% f = [0 0.1 0.15 1];
a = [1 1 0 0];
delp=0.02;
dels1=0.02;
w=[1/delp 10/dels1];
b = firls(32,f,a,w);
% figure;
% freqz(b,1,512); 
% figure;
% plot(b);
RR_fil = conv(RR_new,b,'same');
% RR_fil = RR_fil(floor(length(b)/2):end-floor(length(b)/2));
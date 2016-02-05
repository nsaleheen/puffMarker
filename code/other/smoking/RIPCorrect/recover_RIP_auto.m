function Recovered_Y = recover_RIP_auto(Y,Fs)
sys = tf([1,2],[1,0.1]);
t = 0:1/Fs:(length(Y)-1)/Fs;
Recovered_Y = lsim(sys,Y,t);
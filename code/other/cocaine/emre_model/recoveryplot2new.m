function [ mse] = recoveryplot(x, data )
B=x(1)*1000;
tau=x(2);
V=x(3:end)*1000;

mse=0;

figure(11);clf;
N=length(data);
for i=1:N
    plot(data{i}.time,data{i}.samples);
    hold on;
    plot(data{i}.time,B-V(i)*exp(-tau *data{i}.time),'r')
    

end

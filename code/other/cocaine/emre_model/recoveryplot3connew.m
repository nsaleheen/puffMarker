function [ mse] = recoveryplot3con(x, data )
B=x(1)*1000;
tau1=x(2);
tau2=x(3);



f0=x(4:4+length(data)-1)*1000;
c=x(4+length(data):end)*1000;
mse=0;

V1=f0-c./(tau1-tau2);
V2=c./(tau1-tau2);


figure(13);clf;
N=length(data);
for i=1:N
    plot(data{i}.time,data{i}.samples);
    hold on;
    plot(data{i}.time,B-V1(i)*exp(-tau1 *data{i}.time)-V2(i)*exp(-tau2 *data{i}.time),'r')
    

end

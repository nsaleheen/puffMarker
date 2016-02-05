function [ mse] = recovery3con(x, data )
B=x(1)*1000;
tau1=x(2); 

tau2=x(3);
f0=x(4:4+length(data)-1)*1000;
c=x(4+length(data):end)*1000;
mse=0;numvar=0;

V1=f0-c./(tau1-tau2);
V2=c./(tau1-tau2);

N=length(data);
for i=1:N
    
mse=mse+ norm(B-data{i}.samples-(V1(i)*exp(-tau1 *data{i}.time)+V2(i)*exp(-tau2 *data{i}.time)))^2;
numvar=numvar+length(data{i}.samples);
end
mse=mse/numvar;

% Derivation s f- f(0)=-af+c/(s+b)
% 
% (s+a) = f(0)+ c/(s+b)
% f= f(0)/(s+a)+ c/(s+a)(s+b)
% 
% -e/(s+a) + e/(s+b)
% 
% 
% 
% ea-eb=c
% e=c/(a-b)
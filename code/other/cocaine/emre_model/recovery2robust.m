function [ mse] = recovery2(x, data,sigma )
B=x(1)*1000;
tau=x(2);
V=x(3:end)*1000;

mse=0;numvar=0;

N=length(data);

k=1.345*sigma;

for i=1:N

    r=B-data{i}.samples-V(i)*exp(-tau *data{i}.time);
    error=0.5*(k> abs(r)).*(r.^2)+ (k <= abs(r)).*(k*abs(r)-0.5*k^2);
    
    
mse=mse+ sum(error);
numvar=numvar+length(data{i}.samples);
%mse=mse+ norm(log(data{i}.samples-B)-log(V(i)*exp(-tau *data{i}.time)))^2;
%mse=mse+ norm(-data{i}.samples-V(i)*exp(-tau *data{i}.time)+B)^2;
end
mse=mse/numvar;


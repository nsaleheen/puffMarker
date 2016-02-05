
%Example script to fit to datatest{1}.samples, datatest{1}.time for subject s=1
%fits are stored in Basesol tau1sol tau2sol

%activity fit fn  is recovery2
function [valid,mse_activity,mse_cocaine,dose_estimate,x]=test_emre(CN,Basesol,tau1sol,tau2sol)
Basesol=Basesol/1000;
valid=1;mse_activity=-1;mse_cocaine=-1;dose_estimate=0; % initialize

ind= find((CN.rr.timestamp> CN.window_time(3))& ( CN.rr.sample<Basesol*1000) );
datatest{1}.time=(CN.rr.timestamp(ind)-min(CN.rr.timestamp(ind)))/60000; %minutes
datatest{1}.samples=CN.rr.t60(ind);

if length(datatest{1}.time)<4,
    valid=0;
    return;
end
x=fminunc(@(x) recovery2new([Basesol tau1sol x(3)], datatest),[Basesol tau1sol  datatest{1}.time(1)]);

mse_activity=recovery2new(x,datatest);

%recoveryplot2(x,datatest);


%drug fit fn is recovery3

x=fmincon(@(x) recovery3connew([Basesol tau1sol tau2sol x(4:5)] ,datatest),[Basesol tau1sol tau2sol datatest{1}.time(1) 1],...
[],[],[],[],zeros(5,1),[],[]);

%mse_activity=recovery3con(x,datatest);
mse_cocaine=recovery3connew(x,datatest);

dose_estimate=x(5);

%recoveryplot3con(x,datatest);
end
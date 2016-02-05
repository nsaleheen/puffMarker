close all
clear all
G=config();
G=config_run_jhu(G);

s=2; %subject 
load ('A.mat');
load ('E.mat');
Base=1.02*1.1;

%figure(1);
for i=1:length(E{s}.C),
    ind= E{s}.C{i}.rr.avg.matlabtime> E{s}.C{i}.window_time(4);
%    plot(E{s}.C{i}.rr.avg.sample(ind))
%    hold on
end
clear datac;
for i=1:length(E{s}.C),
    ind= find(E{s}.C{i}.rr.avg.matlabtime> E{s}.C{i}.window_time(4));
    
    datac{i}.time=E{s}.C{i}.rr.avg.matlabtime(ind)-min(E{s}.C{i}.rr.avg.matlabtime(ind));
    datac{i}.samples=E{s}.C{i}.rr.avg.sample(ind);
%    hold on;
    
   
  % pause
 
   
   
    
end

%figure(2);
clear data;ii=0;
for i=1:length(A{s}.N),
   

 %   plot(A{s}.N{i}.rr.avg.sample,'r');
    data{i}.time=A{s}.N{i}.rr.avg.matlabtime-min(A{s}.N{i}.rr.avg.matlabtime);
    data{i}.samples=A{s}.N{i}.rr.avg.sample;
 %   hold on;
    
    
  % pause
   
   
    
end



%%%%
%%%%Calculate rough slope estimates for recovery and drug
%%%%

clear slope slopec ;
fastind=[];
%figure(3);

for ii=1:length(data),
coeff=regress(log(Base*1000-data{ii}.samples).',[ones(length(data{ii}.time),1) data{ii}.time.']);
slope(ii)=coeff(2);
if slope(ii)<median(slope)
%    plot(data{ii}.time,data{ii}.samples);
    fastind=[fastind ii];
%    hold on
end

end
fprintf('activity slope= %f\n',mean(slope))
tau1est=-median(slope)/10; fprintf('tau1est=%f\n',tau1est);

for ii=1:length(datac),
coeff=regress(log(Base*1000-datac{ii}.samples).',[ones(length(datac{ii}.time),1) datac{ii}.time.']);
slopec(ii)=coeff(2);
end
fprintf('drug slope= %f\n',mean(slopec))
tau2est=-median(slopec)/10; fprintf('tau2est=%f\n',tau2est);
clear datax;%figure(4);
for jj=1:length(fastind)
datax{jj}=data{fastind(jj)};
end


clear f0;
for ii=1:length(datax);
    f0(ii)=(Base*1000-datax{ii}.samples(1))/1000;
end

    
x=fminunc(@(x) recovery2([Base x(2:end)], datax),[Base tau1est f0  ]); %0.1*ones(1,length(datax))
xold=x;

tau1=x(2);
options=optimset('MaxFunEvals',5000);
x=fmincon(@(x) recovery3con([Base tau1 x(3:end)] ,datac),[Base tau1 tau2est 0.25*ones(1,length(datac)) 1*ones(1,length(datac))],...
[],[],[],[],[0 0 1 zeros(1,length(datac)) zeros(1,length(datac))],[],[],options);
x

Basesol{s}=Base;
tau1sol{s}=tau1;
tau2sol{s}=x(3);
tau2=x(3);
fprintf('tau1=%f\n',tau1sol{s});
fprintf('tau2=%f\n',tau2sol{s});

recoveryplot3_sandiago(x,datac);
recoveryplot_sandiago(G,xold,datac);
text(5.5,125,'\tau_R=9.223\n\tau_D=4.369');

datatest{1}=datax{1};
x=test_emre_sandiago(s,datatest,Base,tau1,tau2);

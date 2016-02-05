close all
s=1; %subject 
Base=E{s}.rr.prctile_95/1000;

figure(1);
for i=1:length(E{s}.C),
    ind= E{s}.C{i}.rr.avg.timestamp> E{s}.C{i}.window_time(3);
    plot(E{s}.C{i}.rr.avg.t60(ind))
    hold on
end
clear datac;
for i=1:length(E{s}.C),
    ind= find((E{s}.C{i}.rr.avg.timestamp> E{s}.C{i}.window_time(3))& ( E{s}.C{i}.rr.avg.t60<Base*1000) );
    
    datac{i}.time=(E{s}.C{i}.rr.avg.timestamp(ind)-min(E{s}.C{i}.rr.avg.timestamp(ind)))/60000; %minutes
    datac{i}.samples=E{s}.C{i}.rr.avg.t60(ind);
    
    hold on;
    
   
  % pause
 
   
   
    
end

figure(2);
clear data;ii=0;
for i=1:length(E{s}.N),
   ind= find((E{s}.N{i}.rr.avg.timestamp> E{s}.N{i}.window_time(3))& ( E{s}.N{i}.rr.avg.t60< Base*1000) );

    plot(E{s}.N{i}.rr.avg.t60,'r');
    data{i}.time=(E{s}.N{i}.rr.avg.timestamp(ind)-min(E{s}.N{i}.rr.avg.timestamp(ind)))/60000; %minutes
    data{i}.samples=E{s}.N{i}.rr.avg.t60(ind);
    
    indx=data{i}.time>3;
    data{i}.time(indx)=[];
    data{i}.samples(indx)=[];
    
    hold on;
    
    
  % pause
   
   
    
end



%%%%
%%%%Calculate rough slope estimates for recovery and drug
%%%%

clear slope slopec ;
fastind=[];
figure(3);

for ii=1:length(data),
coeff=regress(log(Base*1000-data{ii}.samples).',[ones(length(data{ii}.time),1) data{ii}.time.']);
slope(ii)=-coeff(2);
if slope(ii)>0.5*median(slope)
    plot(data{ii}.time,data{ii}.samples);
    fastind=[fastind ii];
    hold on
end

end
fprintf('activity slope= %f\n',mean(slope))
tau1est=median(slope);

for ii=1:length(datac),
coeff=regress(log(Base*1000-datac{ii}.samples).',[ones(length(datac{ii}.time),1) datac{ii}.time.']);
slopec(ii)=-coeff(2);
end
fprintf('drug slope= %f\n',mean(slopec))
tau2est=median(slopec);

clear datax;figure(4);
for jj=1:length(fastind)
datax{jj}=data{fastind(jj)};
end

%datax=data;


clear f0;
for ii=1:length(datax);
    f0(ii)=(Base*1000-datax{ii}.samples(1))/1000;
end

    
x=fminunc(@(x) recovery2new([Base x(2:end)], datax),[Base tau1est f0  ]); %0.1*ones(1,length(datax))
recoveryplot2new(x,datax);
xold=x;
tau1=x(2);

options=optimset('MaxFunEvals',5000);
x=fmincon(@(x) recovery3connew([Base tau1 x(3:end)] ,datac),[Base tau1 tau2est 0.25*ones(1,length(datac)) .1*ones(1,length(datac))],...
[],[],[],[],[0 0 .01 zeros(1,length(datac)) zeros(1,length(datac))],[],[],options);

recoveryplot3connew(x,datac);

Basesol{s}=Base;
tau1sol{s}=tau1;
tau2sol{s}=x(3);
mse1{s}=recovery2new(xold,datax)
mse2{s}=recovery3connew(x,datac)


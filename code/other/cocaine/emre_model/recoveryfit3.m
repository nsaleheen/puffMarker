function [tau1sol,tau2sol,mse1,mse2]=recoveryfit3(E,cocaine,s)
%close all
tau1sol=[];tau2sol=[];mse1=[];mse2=[];
%s=1; %subject
%load('newE.mat');
Base=0.9*E{s}.rr.prctile_95/1000;
%{
figure(1);
for i=1:length(E{s}.C),
    if cocaine==-1 || E{s}.C{i}.window.mark==cocaine
        ind= E{s}.C{i}.rr.avg.timestamp> E{s}.C{i}.window_time(3);
        plot(E{s}.C{i}.rr.avg.t60(ind))
        hold on
    end
    
end
clear datac;
%}
datac=[];
j=0;
cc=0;
for i=1:length(E{s}.C),
    if cocaine==-1 || E{s}.C{i}.window.mark==cocaine
%        if E{s}.C{i}.window.mark==20, continue;end;
        %cc=cc+1;if cc~=3, continue;end
        
        j=j+1;
        ind= find((E{s}.C{i}.rr.avg.timestamp> E{s}.C{i}.window_time(3))& ( E{s}.C{i}.rr.avg.t60<Base*1000) );
        
        datac{j}.time=(E{s}.C{i}.rr.avg.timestamp(ind)-min(E{s}.C{i}.rr.avg.timestamp(ind)))/60000; %minutes
        datac{j}.samples=E{s}.C{i}.rr.avg.t60(ind);
        
%        hold on;
    end
    
    % pause
    
    
    
    
end
%if isempty(datac), return;end;
%figure(2);
clear data;ii=0;
for i=1:length(E{s}.N),
   ind= find((E{s}.N{i}.rr.avg.timestamp> E{s}.N{i}.window_time(3))& ( E{s}.N{i}.rr.avg.t60< Base*1000) );

%    plot(E{s}.N{i}.rr.avg.t60,'r');
    data{i}.time=(E{s}.N{i}.rr.avg.timestamp(ind)-min(E{s}.N{i}.rr.avg.timestamp(ind)))/60000; %minutes
    data{i}.samples=E{s}.N{i}.rr.avg.t60(ind);
    
    indx=data{i}.time>3;
    data{i}.time(indx)=[];
    data{i}.samples(indx)=[];
    
%    hold on;
    
    
    % pause
    
    
    
end



%%%%
%%%%Calculate rough slope estimates for recovery and drug
%%%%

clear slope slopec ;
fastind=[];
%figure(3);

for ii=1:length(data),
if length(data{ii}.samples)==0, continue;end;
coeff=regress(log(Base*1000-data{ii}.samples).',[ones(length(data{ii}.time),1) data{ii}.time.']);
slope(ii)=-coeff(2);
if slope(ii)>0.5*median(slope)
%        plot(data{ii}.time,data{ii}.samples);
        fastind=[fastind ii];
%        hold on
    end
    
end
fprintf('activity slope= %f\n',mean(slope))
tau1est=median(slope);
if ~isempty(datac)
for ii=1:length(datac),
coeff=regress(log(Base*1000-datac{ii}.samples).',[ones(length(datac{ii}.time),1) datac{ii}.time.']);
slopec(ii)=-coeff(2);
end
fprintf('drug slope= %f\n',mean(slopec))
tau2est=median(slopec);
end
clear datax;%figure(4);
for jj=1:length(fastind)
datax{jj}=data{fastind(jj)};
end

%datax=data;

if ~isempty(datax)
clear f0;
for ii=1:length(datax);
    f0(ii)=(Base*1000-datax{ii}.samples(1))/1000;
end


x=fminunc(@(x) recovery2new([Base x(2:end)], datax),[Base tau1est f0  ]); %0.1*ones(1,length(datax))
recoveryplot2new(x,datax);
xold=x;
tau1=x(2);
end
if ~isempty(datac)
options=optimset('MaxFunEvals',5000);
x=fmincon(@(x) recovery3connew([Base tau1 x(3:end)] ,datac),[Base tau1 tau2est 0.25*ones(1,length(datac)) .1*ones(1,length(datac))],...
[],[],[],[],[0 0 .01 zeros(1,length(datac)) zeros(1,length(datac))],[],[],options);

recoveryplot3connew(x,datac);
end
Basesol{s}=Base;
tau1sol{s}=tau1;
mse1{s}=recovery2new(xold,datax);

if ~isempty(datac)

    tau2sol{s}=x(3);
mse2{s}=recovery3connew(x,datac);
end

end

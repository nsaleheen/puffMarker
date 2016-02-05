function features=accelerometerfeature_extraction_new(G,segX,segY,segZ,samplingFreq)
FR = G.FEATURE.R_ACL;

%features = -1*ones(1,FR.FEATURENO);
features=[];

%check if anyone of the segment is very short or zero length
% neededSample=(WINDOW.ACTIVITY.WINDOW_LEN*samplingFreq*0.66)/1000;   %if 66% of data is missing, discard the window
% if length(segX.sample)<neededSample||length(segY.sample)<neededSample||length(segZ.sample)<neededSample
%     return;
% end;

%remove baseline. % it is done in drift removal code
%X=segX.sample-mean(segX.sample);
%Y=segY.sample-mean(segY.sample);
%Z=segZ.sample-mean(segZ.sample);

%remove outliers. use it for only chest accelerometer. Otherwise, comment
%it out

% X=removeOutlier(X);
% Y=removeOutlier(Y);
% Z=removeOutlier(Z);

X=segX.sample;Y=segY.sample;Z=segZ.sample;

minX=min(X);
maxX=max(X);
rangeX=maxX-minX;

minY=min(Y);
maxY=max(Y);
rangeY=maxY-minY;

minZ=min(Z);
maxZ=max(Z);
rangeZ=maxZ-minZ;

%%%new features, seems more robust
minOFmin=min([minX,minY,minZ]);
maxOFmax=max([maxX,maxY,maxZ]);
maxOFmin=max([minX,minY,minZ]);
minOFmax=min([maxX,maxY,maxZ]);
maxRange=max([rangeX,rangeY,rangeZ]);
minRange=min([rangeX,rangeY,rangeZ]);

%{
meanX=mean(X);
meanY=mean(Y);
meanZ=mean(Z);
%}

meanX=mean(X);
meanY=mean(Y);
meanZ=mean(Z);

%%%new features, seems more robust
maxOFmean=max([meanX,meanY,meanZ]);
minOFmean=min([meanX,meanY,meanZ]);
meanOFmean=mean([meanX,meanY,meanZ]);

stdevX=std(X);
stdevY=std(Y);
stdevZ=std(Z);

%%%new features, seems more robust
maxOFstd=max([stdevX,stdevY,stdevZ]);
minOFstd=min([stdevX,stdevY,stdevZ]);
meanOFstd=mean([stdevX,stdevY,stdevZ]);

varX=var(X);
varY=var(Y);
varZ=var(Z);

%%%new features, seems more robust
maxVar=max([varX,varY,varZ]);
minVar=min([varX,varY,varZ]);
meanVar=mean([varX,varY,varZ]);
medianVar=median([varX,varY,varZ]);

maxVmin=maxVar/minVar;
maxVmean=maxVar/meanVar;
maxVmedian=maxVar/medianVar;



medX=median(X);
medY=median(Y);
medZ=median(Z);

%new features
minOFmed=min([medX,medY,medZ]);
maxOFmed=max([medX,medY,medZ]);
medOFmed=median([medX,medY,medZ]);

fdX=median(abs(diff(X)));         %to capture the quick change during fast movement
fdY=median(abs(diff(Y)));
fdZ=median(abs(diff(Z)));

%%new features
maxFD=max([fdX,fdY,fdZ]);
minFD=min([fdX,fdY,fdZ]);
meanFD=mean([fdX,fdY,fdZ]);

ratioXY=[];
diffXY=[];
if length(X)<length(Y)
    for i=1:length(X)
        diffXY=[diffXY abs(X(i)-Y(i))];
        if segY.sample(i)~= 0
            ratioXY=[ratioXY abs(X(i)/Y(i))];
        end; 
    end;
else
    for i=1:length(Y)
        diffXY=[diffXY abs(X(i)-Y(i))];
        if segY.sample(i)~= 0
            ratioXY=[ratioXY abs(X(i)/Y(i))];
        end; 
    end;
end;
avgDiffXY=median(diffXY);
avgRatioXY=median(ratioXY);

ratioYZ=[];
diffYZ=[];
if length(Y)<length(Z)
    for i=1:length(Y)
        diffYZ=[diffYZ abs(Y(i)-Z(i))];
        if segZ.sample(i)~= 0
            ratioYZ=[ratioYZ abs(Y(i)/Z(i))];
        end; 
    end;
else
    for i=1:length(Z)
        diffYZ=[diffYZ abs(Y(i)-Z(i))];
        if segZ.sample(i)~= 0
            ratioYZ=[ratioYZ abs(Y(i)/Z(i))];
        end; 
    end;
end;
avgDiffYZ=median(diffYZ);
avgRatioYZ=median(ratioYZ);

ratioZX=[];
diffZX=[];
if length(Z)<length(X)
    for i=1:length(Z)
        diffZX=[diffZX abs(Z(i)-X(i))];
        if segX.sample(i)~= 0
            ratioZX=[ratioZX abs(Z(i)/X(i))];
        end;   
    end;
else
    for i=1:length(X)
        diffZX=[diffZX abs(Z(i)-X(i))];
        if segX.sample(i)~= 0
            ratioZX=[ratioZX abs(Z(i)/X(i))];
        end;   
    end;
end;
avgDiffZX=median(diffZX);
avgRatioZX=median(ratioZX);

%calculation of mean crossings
%t = 1:length(segX);
[crossingX,t1,t1]=crossing(segX.sample,segX.timestamp,mean(segX.sample));
[crossingY,t1,t1]=crossing(segY.sample,segY.timestamp,mean(segY.sample));
[crossingZ,t1,t1]=crossing(segZ.sample,segZ.timestamp,mean(segZ.sample));

maxOfCrossings=max([length(crossingX),length(crossingY),length(crossingZ)]);
minOfCrossings=min([length(crossingX),length(crossingY),length(crossingZ)]);
meanOfCrossings=median([length(crossingX),length(crossingY),length(crossingZ)]);

%avgDiffXY=mean(abs(segX-segY));
%avgDiffYZ=mean(abs(segY-segZ));
%avgDiffZX=mean(abs(segZ-segX));

len=min([length(X) length(Y) length(Z)]);
magnitude=zeros(len,1);
for k=1:len
    magnitude(k)=sqrt(X(k)^2+Y(k)^2+Z(k)^2);
end
avgMagnitude=median(magnitude);
stdMagnitude=std(magnitude);

sum_fft_hf=0;
sum_fft_lf=0;

NFFT = 2^nextpow2(len);
fftMag=abs(fft(magnitude,NFFT))/NFFT;
fftMag=fftMag(5:end);  %ignore first few samples, since after FFT, first few values are very large due to noise or dc offset
if len>=16
    mid=floor(length(fftMag)/4);    %FFT gives a mirror of two signal. 1/2 part is real. therefore, first band is (1/2)/2=1/4 and rest is the higher part
    sum_fft_lf=sum(fftMag(2:mid));
    sum_fft_hf=sum(fftMag(mid:2*mid));
end

sum_fftmag_onehz=0;
sum_fftmag_twohz=0;
sum_fftmag_3hz=0;
sum_fftmag_4hz=0;
sum_fftmag_5hz=0;

f=(samplingFreq/NFFT)*(0:NFFT/2);
sum_fftmag_onehz=sum(fftMag(find(f>0 & f<=1)));
sum_fftmag_twohz=sum(fftMag(find(f>1 & f<=2)));
sum_fftmag_threehz=sum(fftMag(find(f>2 & f<=3)));
sum_fftmag_fourhz=sum(fftMag(find(f>3 & f<=4)));
sum_fftmag_fivehz=sum(fftMag(find(f>4 & f<=5)));

fftCompX=fft(X)/length(X);
fftCompY=fft(Y)/length(Y);
fftCompZ=fft(Z)/length(Z);

avgEnergy=median([sum(abs(fftCompX(5:end))'.^2),sum(abs(fftCompY(5:end))'.^2),sum(abs(fftCompZ(5:end))'.^2)]);

%entropyX=entropy2(segX.sample);
%entropyY=entropy2(segY.sample);
%entropyZ=entropy2(segZ.sample);

energyX=sum(abs(fftCompX(5:end))'.^2);
energyY=sum(abs(fftCompY(5:end))'.^2);
energyZ=sum(abs(fftCompZ(5:end))'.^2);

totalEnergy=energyX+energyY+energyZ;

increment=len/10;
inc=floor(increment);
energyX=zeros(10,1);
for k=1:inc
    if k*inc<len
        segment_fft=fft(X((k-1)*inc+1:k*inc))/inc;
        energyX(k)=sum(abs(segment_fft(2:end))'.^2);
    end
end
%totalEnergy=totalEnergy+sum(energyX);
medianEnergyX=median(energyX);
stdEnergyX=std(energyX);

energyY=zeros(10,1);
for k=1:inc
    if k*inc<len
        segment_fft=fft(Y((k-1)*inc+1:k*inc))/inc;
        energyY(k)=sum(abs(segment_fft(2:end))'.^2);
    end
end
%totalEnergy=totalEnergy+sum(energyY);
medianEnergyY=median(energyY);
stdEnergyY=std(energyY);

energyZ=zeros(10,1);
for k=1:inc
    if k*inc<len
        segment_fft=fft(Z((k-1)*inc+1:k*inc))/inc;
        energyZ(k)=sum(abs(segment_fft(2:end))'.^2);
    end
end
%totalEnergy=totalEnergy+sum(energyZ);
medianEnergyZ=median(energyZ);
stdEnergyZ=std(energyZ);

%new features
maxStdEnergy=max([stdEnergyX,stdEnergyY,stdEnergyZ]);
meanStdEnergy=median([stdEnergyX,stdEnergyY,stdEnergyZ]);
minStdEnergy=min([stdEnergyX,stdEnergyY,stdEnergyZ]);

maxOfmedianEnergy=max([medianEnergyX,medianEnergyY,medianEnergyZ]);
minOfmedianEnergy=min([medianEnergyX,medianEnergyY,medianEnergyZ]);
meanOfmedianEnergy=median([medianEnergyX,medianEnergyY,medianEnergyZ]);

sumEnergyHFX=0;
sumEnergyHFY=0;
sumEnergyHFZ=0;
sumEnergyLFX=0;
sumEnergyLFY=0;
sumEnergyLFZ=0;

if length(X)>=16
    fftx=abs(fft(X));
    midx=floor(length(fftx)/4);    %FFT gives a mirror of two signal. 1/2 part is real. therefore, first band is (1/2)/2=1/4 and rest is the higher part
    sumEnergyLFX=sum(fftx(2:midx));
    sumEnergyHFX=sum(fftx(midx:2*midx));
end

if length(Y)>=16
    ffty=abs(fft(Y));
    midy=floor(length(ffty)/4);
    sumEnergyLFY=sum(ffty(2:midy));
    sumEnergyHFY=sum(ffty(midy:2*midy));
end

if length(Z)>=16
    fftz=abs(fft(Z));
    midz=floor(length(fftz)/4);
    sumEnergyLFZ=sum(fftz(2:midz));
    sumEnergyHFZ=sum(fftz(midz:2*midz));
end

%new features. seems to be more robust
maxEnergyLF=max([sumEnergyLFX,sumEnergyLFY,sumEnergyLFZ]);
minEnergyLF=min([sumEnergyLFX,sumEnergyLFY,sumEnergyLFZ]);
medianEnergyLF=median([sumEnergyLFX,sumEnergyLFY,sumEnergyLFZ]);

maxEnergyHF=max([sumEnergyHFX,sumEnergyHFY,sumEnergyHFZ]);
minEnergyHF=min([sumEnergyHFX,sumEnergyHFY,sumEnergyHFZ]);
medianEnergyHF=median([sumEnergyHFX,sumEnergyHFY,sumEnergyHFZ]);
totalLFenergy=sum([sumEnergyLFX,sumEnergyLFY,sumEnergyLFZ]);
totalHFenergy=sum([sumEnergyHFX,sumEnergyHFY,sumEnergyHFZ]);


features{FR.MAXOFMEAN}=double(maxOFmean);
features{FR.MEANOFMEAN}=double(meanOFmean);
features{FR.MINOFMEAN}=double(minOFmean); 

features{FR.MAXOFMIN}=double(maxOFmin);
features{FR.MINOFMIN}=double(minOFmin);
features{FR.MAXOFMAX}=double(maxOFmax);
features{FR.MINOFMAX}=double(minOFmax);

features{FR.MAXOFRANGE}=double(maxRange);
features{FR.MINOFRANGE}=double(minRange);

features{FR.MAXOFSTD}=double(maxOFstd);
features{FR.MINOFSTD}=double(minOFstd);
features{FR.MEANOFSTD}=double(meanOFstd);

features{FR.MAXVAR}=double(maxVar);
features{FR.MINVAR}=double(minVar);
features{FR.MEANVAR}=double(meanVar);

features{FR.MAXOFMED}=double(maxOFmed);
features{FR.MINOFMED}=double(minOFmed);
features{FR.MEDOFMED}=double(medOFmed);

features{FR.MAXFD}=double(maxFD);
features{FR.MINFD}=double(minFD);
features{FR.MEANFD}=double(meanFD);

features{FR.MAXCROSSING}=double(maxOfCrossings);
features{FR.MEANCROSSING}=double(meanOfCrossings);
features{FR.MINCROSSING}=double(minOfCrossings);

features{FR.TOTALENERGY}=double(totalEnergy);

features{FR.MAXSTDENERGY}=double(maxStdEnergy);
features{FR.MEANSTDENERGY}=double(meanStdEnergy);

features{FR.MINSTDENERGY}=double(minStdEnergy);
features{FR.MAXENERGYLF}=double(maxEnergyLF);
features{FR.MINENERGYLF}=double(minEnergyLF);
features{FR.MEDIANENERGYLF}=double(medianEnergyLF);

features{FR.MAXENERGYHF}=double(maxEnergyHF);
features{FR.MINENERGYHF}=double(minEnergyHF);
features{FR.MEDIANENERGYHF}=double(medianEnergyHF);

features{FR.TOTALENERGYLF}=double(totalLFenergy);
features{FR.TOTALENERGYHF}=double(totalHFenergy);

features{FR.AVGENERGY}=double(avgEnergy);
features{FR.AVGMAGNITUDE}=double(avgMagnitude);

features{FR.STDEVMAGNITUDE}=double(stdMagnitude);

features{FR.MAGNITUDEFFTONEHZ}=double(sum_fftmag_onehz);
features{FR.MAGNITUDEFFTTWOHZ}=double(sum_fftmag_twohz);
features{FR.MAGNITUDEFFTTHREEHZ}=double(sum_fftmag_threehz);
features{FR.MAGNITUDEFFTFOURHZ}=double(sum_fftmag_fourhz);
features{FR.MAGNITUDEFFTFIVEHZ}=double(sum_fftmag_fivehz);

features{FR.MAGNITUDEFFTHF}=double(sum_fft_hf);
features{FR.MAGNITUDEFFTLF}=double(sum_fft_lf);

features{FR.MAXMINVARRATIO}=double(maxVmin);
features{FR.MAXMEANVARRATIO}=double(maxVmean);
features{FR.MAXMEDIANVARRATIO}=double(maxVmedian);

features{FR.MAXOFMEDIANENERGY}=double(maxOfmedianEnergy);
features{FR.MINOFMEDIANENERGY}=double(minOfmedianEnergy);
features{FR.MEANOFMEDIANENERGY}=double(meanOfmedianEnergy);

end

function y=entropy2(x)
    ent = 0.0;
    m = mean(x);
    for i=1:length(x)
    quo = abs(x(i) - m);
    ent = ent + (quo * log10(quo));
    end
    y = -ent;
end

function x=removeOutlier(samples)
    u=median(samples)+3.32*iqr(samples);
    l=median(samples)-3.32*iqr(samples);
    ind=(find(samples>l & samples<u));
    x=samples(ind);
end

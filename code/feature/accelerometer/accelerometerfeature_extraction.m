function features=accelerometerfeature_extraction(G,segX,segY,segZ)

FR = G.FEATURE.R_ACL;

feature=[];
%check if anyone of the segment is very short or zero length
if isempty(segX.sample)||isempty(segY.sample)||isempty(segZ.sample)
    return;
end;

minX=min(segX.sample);maxX=max(segX.sample);rangeX=maxX-minX;

minY=min(segY.sample);maxY=max(segY.sample);rangeY=maxY-minY;

minZ=min(segZ.sample);maxZ=max(segZ.sample);rangeZ=maxZ-minZ;

meanX=mean(segX.sample);meanY=mean(segY.sample);meanZ=mean(segZ.sample);

stdevX=std(segX.sample);stdevY=std(segY.sample);stdevZ=std(segZ.sample);

varX=var(segX.sample);varY=var(segY.sample);varZ=var(segZ.sample);

medX=median(segX.sample);medY=median(segY.sample);medZ=median(segZ.sample);

fdX=mean(diff(segX.sample));fdY=mean(diff(segY.sample));fdZ=mean(diff(segZ.sample));

ratioXY=[];
diffXY=[];
if length(segX.sample)<length(segY.sample)
    for i=1:length(segX.sample)
        diffXY=[diffXY segX.sample(i)-segY.sample(i)];
        if segY.sample(i)~= 0
            ratioXY=[ratioXY segX.sample(i)/segY.sample(i)];
        end; 
    end;
else
    for i=1:length(segY.sample)
        diffXY=[diffXY segX.sample(i)-segY.sample(i)];
        if segY.sample(i)~= 0
            ratioXY=[ratioXY segX.sample(i)/segY.sample(i)];
        end; 
    end;
end;
avgDiffXY=mean(diffXY);
avgRatioXY=mean(ratioXY);

ratioYZ=[];
diffYZ=[];
if length(segY.sample)<length(segZ.sample)
    for i=1:length(segY.sample)
        diffYZ=[diffYZ segY.sample(i)-segZ.sample(i)];
        if segZ.sample(i)~= 0
            ratioYZ=[ratioYZ segY.sample(i)/segZ.sample(i)];
        end; 
    end;
else
    for i=1:length(segZ.sample)
        diffYZ=[diffYZ segY.sample(i)-segZ.sample(i)];
        if segZ.sample(i)~= 0
            ratioYZ=[ratioYZ segY.sample(i)/segZ.sample(i)];
        end; 
    end;
end;
avgDiffYZ=mean(diffYZ);
avgRatioYZ=mean(ratioYZ);

ratioZX=[];
diffZX=[];
if length(segZ.sample)<length(segX.sample)
    for i=1:length(segZ.sample)
        diffZX=[diffZX segZ.sample(i)-segX.sample(i)];
        if segX.sample(i)~= 0
            ratioZX=[ratioZX segZ.sample(i)/segX.sample(i)];
        end;   
    end;
else
    for i=1:length(segX.sample)
        diffZX=[diffZX segZ.sample(i)-segX.sample(i)];
        if segX.sample(i)~= 0
            ratioZX=[ratioZX segZ.sample(i)/segX.sample(i)];
        end;   
    end;
end;
avgDiffZX=mean(diffZX);
avgRatioZX=mean(ratioZX);

%calculation of mean crossings
%t = 1:length(segX);
[crossingX,t1,t1]=crossing(segX.sample,segX.timestamp,meanX);
[crossingY,t1,t1]=crossing(segY.sample,segY.timestamp,meanY);
[crossingZ,t1,t1]=crossing(segZ.sample,segZ.timestamp,meanZ);

%avgDiffXY=mean(abs(segX-segY));
%avgDiffYZ=mean(abs(segY-segZ));
%avgDiffZX=mean(abs(segZ-segX));

len=min([length(segX.sample) length(segY.sample) length(segZ.sample)]);


Energy = segX.sample(1:len).^2+segY.sample(1:len).^2+segZ.sample(1:len).^2;
avgEnergy = mean(Energy);
medianEnergy = median(Energy);
varEnergy = var(Energy);
stddevEnergy = std(Energy);
fdEnergy=mean(diff(Energy));
rangeEnergy=max(Energy)-min(Energy);
[crossingsEnergy,t1,t1] = crossing(Energy,segX.timestamp(1:len),avgEnergy);




features{FR.MEANX} = double(meanX);
features{FR.MEDIANX} = double(medX);
features{FR.VARIANCEX} = double(varX);
features{FR.STDDEVX} = double(stdevX);
features{FR.AVGFDX} = double(fdX);

features{FR.MEANY} = double(meanY);
features{FR.MEDIANY} = double(medY);
features{FR.VARIANCEY} = double(varY);
features{FR.STDDEVY} = double(stdevY);
features{FR.AVGFDY} = double(fdY);

features{FR.MEANZ} = double(meanZ);
features{FR.MEDIANZ} = double(medZ);
features{FR.VARIANCEZ} = double(varZ);
features{FR.STDDEVZ} = double(stdevZ);
features{FR.AVGFDZ} = double(fdZ);

features{FR.AVGDIFFXY} = double(avgDiffXY);
features{FR.AVGDIFFYZ} = double(avgDiffYZ);
features{FR.AVGDIFFZX} = double(avgDiffZX);

features{FR.AVGRATIOXY} = double(avgRatioXY);
features{FR.AVGRATIOYZ} = double(avgRatioYZ);
features{FR.AVGRATIOZX} = double(avgRatioZX);

features{FR.RANGEX} = double(rangeX);
features{FR.RANGEY} = double(rangeY);
features{FR.RANGEZ} = double(rangeZ);

features{FR.MEANCROSSINGX} = double(length(crossingX));
features{FR.MEANCROSSINGY} = double(length(crossingY));
features{FR.MEANCROSSINGZ} = double(length(crossingZ));

features{FR.AVGENERGY}=double(avgEnergy);
features{FR.MEDIANENERGY}=double(medianEnergy);
features{FR.VARIANCEENERGY}=double(varEnergy);
features{FR.STDDEVENERGY}=double(stddevEnergy);
features{FR.AVGFDENERGY}=double(fdEnergy);
features{FR.RANGEENERGY}=double(rangeEnergy);
features{FR.MEANCROSSINGENERGY}=double(length(crossingsEnergy));

end

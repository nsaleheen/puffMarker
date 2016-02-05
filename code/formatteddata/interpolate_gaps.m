function [newsample,newtimestamp] = interpolate_gaps(G,sample,timestamp,freq)

newsample=[];newtimestamp=[];
if isempty(sample), return;end;
GAP.MAX_INTERPOLATION_GAP = 2; % at most 2 missing packets are interpolated. (10 samples)
GAP.INTERPOL_USE_PCHIP = 1;% can be either pchip or spline

sampling_interval = 1000/freq;

newsample = sample(1);
newtimestamp = timestamp(1);

interpolation_gap_time=GAP.MAX_INTERPOLATION_GAP*sampling_interval*G.SAMPLE_TOS;
limitswindow = freq*60;

timediffs = diff(timestamp);
n = length(timestamp);
ind=find(timediffs >= 2*sampling_interval & timediffs <= interpolation_gap_time);
prev=2;
for i=ind
    now=i;
    newtimestamp = [newtimestamp timestamp(prev:now)];
    newsample = [newsample sample(prev:now)];
    prev=i+2;
    if timediffs(i) >= 2*sampling_interval && timediffs(i) <= interpolation_gap_time
        t = timestamp(max(1,i-5):min(n,i+5));
        x = sample(max(1,i-5):min(n,i+5));
        gaptimes = timestamp(i)+sampling_interval:sampling_interval:timestamp(i+1);
        if GAP.INTERPOL_USE_PCHIP
            gapsample = pchip(t,x,gaptimes);
        else
            temp = sample(max(1,i-limitswindow):min(i+limitswindow,n));
            lowlimit = min(temp);
            highlimit = max(temp);
            ppmodel = interp1(t,x,gaptimes,'spline');
            ppmodellinear = interp1(t,x,gaptimes,'linear');
            n1 = length(gapsample);
            
            if gapsample(2)<gapsample(1) && gapsample(end-1)<gapsample(end)
                if min(gapsample)<lowlimit
                    gapsample = gapsamplelinear-abs((gapsample-gapsamplelinear)./(min(gapsample)-gapsamplelinear).*(lowlimit-gapsamplelinear));
                end
            elseif gapsample(2)>gapsample(1) && gapsample(end-1)>gapsample(end)
                if max(gapsample)>highlimit
                    gapsample = gapsamplelinear+abs((gapsample-gapsamplelinear)./(max(gapsample)-gapsamplelinear).*(highlimit-gapsamplelinear));
                end
            else
                if min(gapsample)<lowlimit || max(gapsample)>highlimit
                    x = gapsample-gapsamplelinear;
                    x = x/max(abs(x));
                    rangehigh = highlimit-gapsamplelinear;
                    rangelow = gapsamplelinear-lowlimit;
                    
                    gapsample = zeros(1,n1);
                    for j=1:n1
                        if x(j)>0
                            gapsample(j) = gapsamplelinear(j)+x(j)*rangehigh(j);
                        else
                            gapsample(j) = gapsamplelinear(j)+x(j)*rangelow(j);
                        end
                    end
                end
            end
        end
        newtimestamp(end+1:end+length(gaptimes)) = gaptimes;
        newsample(end+1:end+length(gaptimes)) = gapsample;
        
    end
end
newtimestamp = [newtimestamp timestamp(prev:end)];
newsample = [newsample sample(prev:end)];
%{
ns=newsample;
nt=newtimestamp;
newsample = sample(1);
newtimestamp = timestamp(1);

for i=1:n-1
    if timediffs(i) >= 2*sampling_interval && timediffs(i) <= interpolation_gap_time
        t = timestamp(max(1,i-5):min(n,i+5));
        x = sample(max(1,i-5):min(n,i+5));
        gaptimes = timestamp(i)+sampling_interval:sampling_interval:timestamp(i+1);
        if GAP.INTERPOL_USE_PCHIP
            gapsample = pchip(t,x,gaptimes);
        else
            temp = sample(max(1,i-limitswindow):min(i+limitswindow,n));
            lowlimit = min(temp);
            highlimit = max(temp);
            ppmodel = interp1(t,x,gaptimes,'spline');
            ppmodellinear = interp1(t,x,gaptimes,'linear');
            n1 = length(gapsample);
            
            if gapsample(2)<gapsample(1) && gapsample(end-1)<gapsample(end)
                if min(gapsample)<lowlimit
                    gapsample = gapsamplelinear-abs((gapsample-gapsamplelinear)./(min(gapsample)-gapsamplelinear).*(lowlimit-gapsamplelinear));
                end
            elseif gapsample(2)>gapsample(1) && gapsample(end-1)>gapsample(end)
                if max(gapsample)>highlimit
                    gapsample = gapsamplelinear+abs((gapsample-gapsamplelinear)./(max(gapsample)-gapsamplelinear).*(highlimit-gapsamplelinear));
                end
            else
                if min(gapsample)<lowlimit || max(gapsample)>highlimit
                    x = gapsample-gapsamplelinear;
                    x = x/max(abs(x));
                    rangehigh = highlimit-gapsamplelinear;
                    rangelow = gapsamplelinear-lowlimit;
                    
                    gapsample = zeros(1,n1);
                    for j=1:n1
                        if x(j)>0
                            gapsample(j) = gapsamplelinear(j)+x(j)*rangehigh(j);
                        else
                            gapsample(j) = gapsamplelinear(j)+x(j)*rangelow(j);
                        end
                    end
                end
            end
        end
        newtimestamp(end+1:end+length(gaptimes)) = gaptimes;
        newsample(end+1:end+length(gaptimes)) = gapsample;
        
    else
        newtimestamp(end+1) = timestamp(i+1);
        newsample(end+1) = sample(i+1);
    end
end
%}
end

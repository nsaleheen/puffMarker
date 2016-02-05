function f=BreathMinVent(peakvalley_sample,peakvalley_timestamp)
tidalvol = 0;
n = length(peakvalley_sample);
i = 0;
for ind=1:2:n-2
    if peakvalley_timestamp(ind)<peakvalley_timestamp(ind+1) && peakvalley_timestamp(ind+1) < peakvalley_timestamp(ind+2)
        xx = (peakvalley_timestamp(ind+1)-peakvalley_timestamp(ind))/1000;
        yy = (peakvalley_sample(ind+1)-peakvalley_sample(ind));
        tidalvol=tidalvol+(xx*yy)/2;
        i = i + 1;
    end
end
f=tidalvol*i;
end

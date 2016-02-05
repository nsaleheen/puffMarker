function P= calculate_magnitude_peaks_nazir(G, P)
%CALCULATE_MAGNITUDE_PEAKS_NAZIR Summary of this function goes here
%   Detailed explanation goes here
fprintf('...magnitude peak');
cnt = 0;
peak_distribution = zeros(1, 4000);
for id=1:2
    sz = length(P.wrist{id}.magnitude);

    P.wrist{id}.magnitude_peaks = zeros(1,length(P.wrist{id}.magnitude));
    i=1;
    while i < length(P.wrist{id}.magnitude)        
        curValue = P.wrist{id}.magnitude(i);
        smoothValue = P.wrist{id}.magnitude_8000(i);
        if(curValue > smoothValue) 
            maxValue = curValue;
            indx=i;
            while(P.wrist{id}.magnitude(i) > P.wrist{id}.magnitude_8000(i) && i < length(P.wrist{id}.magnitude))
                P.wrist{id}.magnitude_peaks(i) = 500;
                mag_value = int32(P.wrist{id}.magnitude(i)+1);
                peak_distribution(mag_value) = peak_distribution(mag_value) +1;
                if (maxValue < P.wrist{id}.magnitude(i))
                   maxValue = P.wrist{id}.magnitude(i);
                   indx = i;
                end   
                i=i+1;
            end
            if maxValue >1000
                cnt=cnt+1;
                P.wrist{id}.magnitude_peaks(indx) = 1000;
            end
        end 
        i=i+1;
    end     
end

% plot(1:4000, peak_distribution, 'r+');

cnt
end

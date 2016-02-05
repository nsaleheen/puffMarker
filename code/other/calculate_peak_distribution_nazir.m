function peak_distribution = calculate_peak_distribution_nazir( G, P )
%CALCULATE_PEAK_DISTRIBUTION_NAZIR Summary of this function goes here
%   Detailed explanation goes here
fprintf('...peak distribution');
cnt = 0;
peak_distribution = zeros(1, 4000);
for id=1:2
    sz = length(P.wrist{id}.magnitude);
%     P.wrist{id}.magnitude_peaks = zeros(1,length(P.wrist{id}.magnitude));
    i=1;
    while i < length(P.wrist{id}.magnitude)        
        curValue = P.wrist{id}.magnitude(i);
        smoothValue = P.wrist{id}.magnitude_8000(i);
        if(curValue > smoothValue) 
            maxValue = int32(curValue)+1;
            indx=i;
            while(P.wrist{id}.magnitude(i) > P.wrist{id}.magnitude_8000(i) && i < length(P.wrist{id}.magnitude))
%                 P.wrist{id}.magnitude_peaks(i) = 500;
                              
                if (maxValue < P.wrist{id}.magnitude(i))
                   maxValue = int32(P.wrist{id}.magnitude(i)+1);
                   indx = i;
                   
                end   
                i=i+1;
            end
            cnt=cnt+1;
%             P.wrist{id}.magnitude_peaks(indx) = 1000;
peak_distribution(maxValue) = peak_distribution(maxValue) +1;
        end 
        i=i+1;
    end     
end

% plot(1:4000, peak_distribution, 'r+');

cnt

end


function [newsample]=remove_drift_accel(sample)

    N=10;                                      %10 samples window for drift removal

    %% accelerometer preprocessing test
    %sample=medfilt1(sample);
    newsample=sample;
    if length(sample)>N
        for i=1:N:length(sample)-N
            newsample(i:i+9)=detrend(sample(i:i+9));
        end
        %apply median filter to the new data
        newsample=medfilt1(newsample(1:end));  %ignore the last N samples, since we did not remove the drift from it
    else
        newsample=detrend(medfilt1(newsample));
    end
end

%developed by Rummana Bari - Date: 21 January 2014 Idea: A semi-automatic method for peak and valley detection in free-breathing
% respiratory waveforms- Wei Lu
function [valley_ind,peak_ind]=peakvalley_v2(sample,timestamp)
% Returns indices of valleys and peaks. format of data: Valley - peak
% -valley
peak_ind=[];
valley_ind=[];
peak_index=[];
valley_index=[];
if isempty(sample);
    return;
end
y1=smooth(sample,5);  % Moving average filter by default n=5.
% figure;plot(y1,'g');hold on;
sample=y1;

% peak_index=[];
% valley_index=[];
up_intercept=[];
down_intercept=[];
up_intercept_index=[];
down_intercept_index=[];
Timewindow=8;  % In second, TImewindow should include at least one breathe cycle
windowlength=round(Timewindow*21.33);
%plot(sample,'r');hold on;
%% Moving Average Curve MAC from filtered samples
MAC=[];
for i=(windowlength+1):1:length(sample)-(windowlength+1)
    MAC(end+1) = mean(sample(i-windowlength:i+windowlength)); % Moving Average Curve over window
end
j=(windowlength+1):1:length(sample)-(windowlength+1);
%plot(j,MAC,'k','Linewidth',2)

%% MAC Intercept (Up and Down Intercept)
for i=2:length(MAC)
    if (sample(i+windowlength-1)<=MAC(i-1) && sample(i+windowlength)>=MAC(i))
        up_intercept= [up_intercept MAC(i)];
        up_intercept_index=[up_intercept_index i+windowlength-1];
        
    elseif (sample(i+windowlength-1)>=MAC(i-1) && sample(i+windowlength)<=MAC(i))
        down_intercept=[down_intercept MAC(i)];
        down_intercept_index=[down_intercept_index i+windowlength-1];
        
    end
end
% plot(up_intercept_index,sample(up_intercept_index),'kd','MarkerSize',9)
% plot(down_intercept_index,sample(down_intercept_index),'ro','MarkerSize',9)
%% Intercept Outlier Removal

[UI,DI]=Intercept_outlier_detector_RIP_lamia(up_intercept_index,down_intercept_index,sample,timestamp,Timewindow);
if isempty(UI)
    return;
end
if isempty(DI)
    return;
end
%plot(UI,sample(UI),'m^','MarkerFaceColor','m');
%plot(DI,sample(DI),'bv','MarkerFaceColor','b');

%% Peak-Valley
for i=1:length(DI)-1  % As UI>DI, set in Intercept_outlier_detector; Down Intercept comes first
    temp=sample(UI(i):DI(i+1));
    pkvalue=max(temp);
    ind=find(temp==pkvalue);
    if isempty(ind)
        continue;
    end
    
    pkindex=UI(i)+ind(1)-1;
    peak_index=[peak_index pkindex];
    
    temp=sample(DI(i):UI(i));
    [maxtab, mintab]=localMaxMin(temp,1);
    if isempty(mintab)
        vlvalue=min(temp);       %% value of Valley
        ind=find(temp==vlvalue);    
        if isempty(ind)
            continue;
        end
        vlindex=DI(i)+ind(1)-1;    %% Index of valley
    else
        vlindex=DI(i)+mintab(end,1)-1;      %% Index of valley
    end
    valley_index=[valley_index vlindex];
end

%plot(peak_index,sample(peak_index),'bo');
%plot(valley_index,sample(valley_index),'go');

%% Locate Actual Valley using maximum slope algorithm which is located between current valley and next peak

valley_index=confirm_valley(peak_index,valley_index,UI,DI,sample);
%plot(valley_index,sample(valley_index),'gx','MarkerSize',14);


%% Inspiration Expiration Amplitude outlier removal
% Remove those peak-valley pairs whose amplitudes are relatively small
% compared to pre-defined threshold
Inspiration_amplitude=[];
Expiration_amplitude=[];

for i=1:length(valley_index)-1
    Inspiration_amplitude=[Inspiration_amplitude sample(peak_index(i))-sample(valley_index(i))];
    Expiration_amplitude=[Expiration_amplitude abs(sample(valley_index(i+1))-sample(peak_index(i)))];
end
Mean_Inspiration_Amp=mean(Inspiration_amplitude);
Mean_Expiration_Amp=mean(Expiration_amplitude);

% Inspiration Expiration outlier from amplitude threshold
% If Inspiration amplitude is less than 20% of mean ispiration amplitude,
% remove that valley-peak pair
final_peak_index=[];
final_valley_index=[];
% Remove small amplitude Inspiration
for i=1:length(Inspiration_amplitude)
    if (Inspiration_amplitude(i)>0.15*Mean_Inspiration_Amp)
        final_peak_index=[final_peak_index peak_index(i)];
        final_valley_index=[final_valley_index valley_index(i)];
        
    end
end
% 
% plot(final_peak_index,sample(final_peak_index),'bo','MarkerFaceColor','m');
% plot(final_valley_index,sample(final_valley_index),'ro','MarkerFaceColor','g');

%%
% If Expiration amplitude is less than 20% of mean expiration amplitude,
% remove that peak- valley pair
Expiration_amplitude=[];
for i=1:length(final_valley_index)-1
    Expiration_amplitude=[Expiration_amplitude abs(sample(final_valley_index(i+1))-sample(final_peak_index(i)))];
end
Mean_Expiration_Amp=mean(Expiration_amplitude);

peak_ind=[];
valley_ind=[];
valley_ind=[valley_ind final_valley_index(1)];
% Remove small amplitude Expiration
for i=1:length(Expiration_amplitude)
    if (Expiration_amplitude(i)>0.15*Mean_Expiration_Amp)
        valley_ind=[valley_ind final_valley_index(i+1)];
        peak_ind=[peak_ind final_peak_index(i)];
    end
end
%peak_ind=[peak_ind final_peak_index(end)];
%plot(peak_ind,sample(peak_ind),'bo','MarkerFaceColor','k');
%plot(valley_ind,sample(valley_ind),'ro','MarkerFaceColor','k');

end

function  Y = moving_avg(X,Fs,time_window)
window = round(Fs*time_window);
for i = 1:length(X)-window
    Y(i) = mean(X(i:i+window-1));
end
% Y = [zeros(1,window),Y];
Y = [zeros(1,floor(window/2)),Y,zeros(1,ceil(window/2))];
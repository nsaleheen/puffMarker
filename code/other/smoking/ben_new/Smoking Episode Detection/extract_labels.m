function Y = extract_labels(self_report, windows)

%Compute the number of windows
num_windows  = size(windows,1);
window_size  = windows(1,2)-windows(1,1);

%Initialize the feature matrix and set the first column to be
%bias features
Y = ones(num_windows, 1);

%Loop over all windows
for i=1:num_windows
  
  %Set the label for each window to 2 if there is a self report
  %close enough to the window.
  idx = find( (self_report>=(windows(i,1)-3*window_size)) & ... 
              (self_report<(windows(i,2)+3*window_size)));
  Y(i) = 1+(length(idx)>0);
end

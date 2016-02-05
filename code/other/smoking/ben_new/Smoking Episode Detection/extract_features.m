function [F,windows] = extract_features(puff_times,puff_probs,windows,overlap_factor)

%Compute the number of windows
num_windows  = size(windows,1);
window_size  = windows(1,2)-windows(1,1);
dw           = window_size * overlap_factor /2;

%Set the number of features
num_features = 10;

%Initialize the feature matrix and set the first column to be
%bias features
F = zeros(num_windows, num_features);
F(:,1) = 1; 

myprintf('Extracting features: ');

idx = find(puff_probs>=0.05);
Ps  = puff_probs(idx);

%Loop over all windows
for i=1:num_windows

  if(mod(i, ceil(num_windows/10))==0)
    myprintf('=');
  end
  
  %Get the puffs contained in the window +/- the window overlap amount dw
  idx = find( (puff_times>=(windows(i,1)-dw)) & (puff_times<(windows(i,2)+dw))  );
  npuffs = nnz(Ps(idx)>0.05);
    
  %Include indicator variable for whether the 
  %interval contains a non-zero number of
  %puffs
  F(i,2) = npuffs>0; 
  F(i,3) = npuffs;
  F(i,4) = nnz(Ps(idx)>=0.25);
  F(i,5) = nnz(Ps(idx)>=0.5);
  F(i,6) = nnz(Ps(idx)>=0.75);
  F(i,7:10) = (F(i,3:6).^2);

  
  %Check if there is at least one puff
  if(npuffs>=1)

    %If yes, get the puffs
    puffs = puff_times(idx);
    
    %Quantize number of puffs in the window
    %if(npuffs>0 & npuffs<=3)
    %  F(i,4) = 1;
    %elseif(npuffs>3 & npuffs<=6)
    %  F(i,5) = 1;
    %elseif(npuffs>6 & npuffs<=9)
    %  F(i,6) = 1;
    %elseif(npuffs>9 & npuffs<=12)
    %  F(i,7) = 1;
    %elseif(npuffs>12)
    %  F(i,8) = 1;
    %end
    

    %Check if there are at least two puffs 
    %if(length(idx)>=2)
    
    %Compute the inter-puff times
      %inter_puff = (puffs(2:end)-puffs(1:end-1))/10000;

      %Compute the average inter-puff duration 
      %F(i,4) = mean(inter_puff);
      
      %Compute the standard deviation of inter-puff duration
      %F(i,5) = std(inter_puff);
    %end
  end
end
myprintf('\n');

%F=F(:,1:4);
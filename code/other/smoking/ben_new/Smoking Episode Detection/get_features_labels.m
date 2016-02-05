function [F,Y,windows] = get_features_labels(left,right,leftP,rightP,self_report)

%Define window sizes for grouping time axis
window_size = 2e5; 

%Define overlap factor for extracting features
overlap_factor = 2;

%Get non-overlapping prediction windows covering both
%left and right hand puff detections

windows = get_windows(left,right,window_size);

%Extract features for each prediction window from left and right
FL = extract_features(left, leftP, windows, overlap_factor);
FR = extract_features(right, rightP, windows, overlap_factor);

%Extract features for each prediction window from left and right
%FL2 = extract_features(left, leftP, windows, 2*overlap_factor);
%FR2 = extract_features(right, rightP, windows, 2*overlap_factor);

%Extract features for each prediction window from left and right
FL4 = extract_features(left, leftP, windows, 4*overlap_factor);
FR4 = extract_features(right, rightP, windows, 4*overlap_factor);

%Use features values corresponding to largest number of detected puffs
%within each window
%[foo,ind] = max([FL(:,3),FR(:,3)],[],2) ;
%F = bsxfun(@times,FL,ind==1) + bsxfun(@times,FR,ind==2);


F = [FL(:,1),max(FL(:,2),FR(:,2))./(10+FL(:,2)+FR(:,2)),FL(:,2:end),FR(:,2:end),...
    max(FL(:,2:end),FR(:,2:end)),FL(:,2:end-2)+FR(:,2:end-2),...
    FL(:,2:end-2)./(1+FL4(:,2:end-2)), FR(:,2:end-2)./(1+FR4(:,2:end-2))];

    %, FL(:,2:end)./(1+FL2(:,2:end)), FR(:,2:end)./(1+FR2(:,2:end)),...     
    
Y = extract_labels(self_report, windows);

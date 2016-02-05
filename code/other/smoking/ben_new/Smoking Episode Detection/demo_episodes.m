addpath(genpath('CRF'))

%Detect if using octave and set plotting
if(exist('OCTAVE_VERSION', 'builtin') ~= 0)
  graphics_toolkit('fltk')
end

%Set global verbose level for printing status messages
global verbose_level;
verbose_level=1;


subjects={'p10','p11','p12','p14','p15','p16'};

c=1;
for s=1:length(subjects)
  files=ls(sprintf('data/%s*ben*.mat',subjects{s}));
  num_files=size(files,1);

  left_puff   = {};
  right_puff  = {};
  self_report = {};
  Y           = {};
  F           = {};
  windows     = {};
  Yhat        = {};
  P           = {};
  leftP       = {};
  rightP      = {};  

  %Get the predictions for the left and right wrist SVMs 
  %and the self report data
  for i=1:num_files
    load(['data/' files(i,:)]);
    left{i}        = S.wrist{1}.puff_time;
    right{i}       = S.wrist{2}.puff_time;
  
    leftP{i}  = S.wrist{1}.svm_probability;
    rightP{i} = S.wrist{2}.svm_probability;
  
    self_report{i} = S.self_report.time;  
    [F{i},Y{i},windows{i}] = get_features_labels(left{i},right{i},leftP{i},rightP{i},self_report{i});
  end

  %Make predictions and plot results
  for i=1:num_files
    Ytrain=Y;
    Ftrain=F;
    Ytrain(i)=[];
    Ftrain(i)=[];
  
    %Learn the CRF model parameters on all traces
    [wFeatures,wTrans] = learn_crf(Ytrain,Ftrain,2,50,10,10);
    [Yhat{i},P{i}] = predict_crf(F{i},wFeatures,wTrans,'marg');
    
    %Plot the result
    plot_episodes(windows{i},Yhat{i},P{i},left{i},right{i},leftP{i},rightP{i},Y{i},self_report{i},c);
    title(sprintf('Episodes Detections for %s', files(i,1:12)));
    drawnow();
    c=c+1;
  end
  
end  




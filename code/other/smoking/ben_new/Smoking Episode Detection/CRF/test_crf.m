function [err,yhat]=test_crf(Y,X,wFeatures,wTrans,InfType)
%Inputs:
% Y: cell array of test label sequences. Y{i} represents the i^th label sequence.
%    Y{i} is an N_i x 1 vector such that Y{i}(j) gives the value for the j^th label variable 
%    in sequence i.
% X: cell array of test feature sequences. X{i} represents the i^th feature sequence.
%    X{i} is an N_i x D matrix such that X{i}(j,f) gives the value of feature f  
%    for the j^th feature variable in sequence i. X{i}(j,:) is the input feature vector
%    for the j^th label variable in sequence i. Note that the first feature dimension
%    X{i}(j,1) must be the constant bias 1.
% wFeatures: number of features by number of classes matrix of feature weights
% wTrans: number of classes by number of classes matrix of transition parameters
% InfType: takes the value 'marg' or 'mpe'. marg computes label marginal probabilities and
%          uses these marginal probabilities to label each node. mpe computes the most likely
%          labeling of each test sequence.

%Outputs:



err  = 0;
Norm = 0;
N    = length(X);
yhat = {};
for i =1:N
  Beta0 = X{i}*wFeatures;
  
  if(isempty(wTrans))
    logPM = Beta0;  
    [junk Yhat] = max(logPM,[],2);
  else  
    switch(InfType) 
        case 'marg'
          [logPP,logPM,logZ] = chain_inference_log(Beta0,wTrans);
          [junk yhat{i}] = max(logPM,[],2);
        case 'mpe'
          yhat{i} = chain_inference_mpe(Beta0,wTrans);
    end             
  end
  
  err = err + sum(yhat{i}(:)~=Y{i}(:));
  Norm = Norm + length(Y{i}); 
end
err = err/Norm;

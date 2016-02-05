function [yhat,P]=predict_crf(X,wFeatures,wTrans,InfType)
%Inputs:
% X: N x D matrix such that X(j,f) gives the value of feature f  
%    for the j^th feature variable in the sequence. X(j,:) is the input feature vector
%    for the j^th label variable. Note that the first feature dimension
%    X(j,1) must be the constant bias 1.
% wFeatures: number of features by number of classes matrix of feature weights
% wTrans: number of classes by number of classes matrix of transition parameters
% InfType: takes the value 'marg' or 'mpe'. marg computes label marginal probabilities and
%          uses these marginal probabilities to label each node. mpe computes the most likely
%          labeling of each test sequence.

Beta0 = X*wFeatures;
  
if(isempty(wTrans))
  logPM = Beta0;  
  [junk yhat] = max(logPM,[],2);
else  
  switch(InfType) 
    case 'marg'
      [logPP,logPM,logZ] = chain_inference_log(Beta0,wTrans);
      [junk yhat] = max(logPM,[],2);
    case 'mpe'
      yhat = chain_inference_mpe(Beta0,wTrans);
  end             
end  
yhat = yhat(:);
P    = exp(logPM(:,2));



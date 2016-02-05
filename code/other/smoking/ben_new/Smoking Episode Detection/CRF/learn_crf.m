function [wFeatures,wTrans]= learn_crf(Y,X,C,MaxIter,lambdaF,lambdaT)
% Inputs:
% Y: cell array of training label sequences. Y{i} represents the i^th label sequence.
%    Y{i} is an N_i x 1 vector such that Y{i}(j) gives the value for the j^th label variable 
%    in sequence i.
% X: cell array of training feature sequences. X{i} represents the i^th feature sequence.
%    X{i} is an N_i x D matrix such that X{i}(j,f) gives the value of feature f  
%    for the j^th feature variable in sequence i. X{i}(j,:) is the input feature vector
%    for the j^th label variable in sequence i. Note that the first feature dimension
%    X{i}(j,1) must be the constant bias 1.
% C: the number of classes in the data. The classes must be labeled 1...C.
% MaxIter: maximum number of learning iterations
% lambdaF: l2 regularization parameter on feature parameters (note: biases are not penalized).
% lambdaT: l2 regularization on transition parameters
%
% Outputs:
% wFeatures: number of features by number of classes matrix of learned feature weights
% wTrans: number of classes by number of classes matrix of learned transition parameters

%Get the number of training sequences
N = length(X);

%Get the number of features
nVars = size(X{1},2);

%Set the number of classes
nClasses = C;

%Set the optimizer parameters
options.method  = 'lbfgs';
options.display = 1;
options.MaxIter = MaxIter;
options.TolX    = 1e-4;
options.TolFun  = 1e-4;

%Set hyperparameters
params.lambdaF      = lambdaF*ones(nVars,nClasses);
params.lambdaF(1,:) = 0; % Don't penalize biases
params.lambdaT      = lambdaT;
params.ind          = 0; %Do not assume independent labels       
params.nClasses     = nClasses;

%Initial parameter vector
winit = [zeros((nVars)*(nClasses-1),1);zeros(nClasses^2,1)]; 

%Train the crf model
W = minFunc(@crf_obj,winit,options,X,Y,params);

%Extract the learned parameters
wFeatures = [zeros(nVars,1);W(1:nVars*(nClasses-1))];
wFeatures = reshape(wFeatures,nVars,nClasses);
wTrans = W((nVars*(nClasses-1))+1:end);
wTrans = reshape(wTrans,nClasses,nClasses);


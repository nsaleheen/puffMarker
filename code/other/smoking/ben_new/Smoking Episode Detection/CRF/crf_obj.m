function [F,g]=crf_obj(W,X,Y,params);

[N,nVars] = size(X{1});
nClasses  = params.nClasses;

N=length(X);

wFeatures = W(1:nVars*(nClasses-1));
wFeatures = [zeros(nVars,1);W(1:nVars*(nClasses-1))];
wFeatures = reshape(wFeatures,nVars,nClasses);

if(~params.ind)
  wTrans = W((nVars*(nClasses-1))+1:end);
  wTrans = reshape(wTrans,nClasses,nClasses);
  gT=zeros(size(wTrans));
else
  gT=[];  
end

gF=zeros(size(wFeatures));
F=0;
TL=0;

YY={};
YS={};

for i =1:N
  l = size(X{i},1);
  TL=TL+l;
  Beta0 = X{i}*wFeatures;
    
  if(l>1 & ~params.ind)
    YY = sparse(Y{i}(1:end-1),Y{i}(2:end),ones(length(Y{i})-1,1),nClasses,nClasses);
    YS = sparse(1:length(Y{i}),Y{i},ones(length(Y{i}),1),length(Y{i}),nClasses);
    [logPP,logPM,logZ] = chain_inference_log(Beta0,wTrans);
    logLik = sum(sum(YS.*Beta0)) + sum(sum(YY.*wTrans)) -logZ;
  else
    YS = sparse(1:length(Y{i}),Y{i},ones(length(Y{i}),1),length(Y{i}),nClasses);
    logPM = bsxfun(@minus,Beta0,logsum(Beta0,2));  
    logLik = sum(sum(YS.*logPM));   
  end    
  F    = F+full(logLik); 
  
  Err = YS-exp(logPM);
  gF  = gF+full(X{i}'*Err);  
  
  if(l>1 & ~params.ind)
    gT  = gT+ YY  - sum(exp(logPP),3);
  end
end

if(l>1 & ~params.ind)
  F   = F  - 0.5*params.lambdaT*sum(wTrans(:).^2);   
  gT  = gT - params.lambdaT*wTrans;
end

F   = F  - 0.5*sum(sum(params.lambdaF.*wFeatures.^2));   
gF  = gF - params.lambdaF.*wFeatures;

gF  = gF(:,2:end); 
g   = [gF(:);gT(:)];
F=-F/TL;
g=-g/TL;


function [logBP,logBM,logZ]=chain_inference_log(beta0,beta1);

[N,C]=size(beta0);

for n=1:N-1
    alpha(:,:,n)=bsxfun(@plus,beta0(n,:)',beta1);
end    
alpha(:,:,N-1) = bsxfun(@plus,beta0(N,:),alpha(:,:,N-1));

deltaF = zeros(N-1,C);
deltaB = zeros(N-1,C);
for n=1:N-2
    if(n==1)
      deltaF(n+1,:) = logsum(alpha(:,:,n),1);
    else
      deltaF(n+1,:) = logsum(bsxfun(@plus,deltaF(n,:)',alpha(:,:,n)),1);
    end    
    %deltaF(n+1,:) = deltaF(n+1,:)/sum(deltaF(n+1,:)); 
end    

for n=(N-1):-1:2
    if(n==N-1)
      deltaB(n-1,:) = logsum(alpha(:,:,n),2)';
    else
      deltaB(n-1,:) = logsum(bsxfun(@plus,deltaB(n,:),alpha(:,:,n)),2)';
    end    
    %deltaB(n-1,:) = deltaB(n-1,:)/sum(deltaB(n-1,:));
end    

for n=1:N-1
    logBP(:,:,n)=  bsxfun(@plus,deltaF(n,:)',deltaB(n,:)) + alpha(:,:,n);
    logZ=logsum(logsum(logBP(:,:,n),1),2);
    logBP(:,:,n)=logBP(:,:,n) - logZ;
end    

logBM = permute(logsum(logBP,2),[3,1,2]);
logBM(end+1,:) = logsum(logBP(:,:,end),1);


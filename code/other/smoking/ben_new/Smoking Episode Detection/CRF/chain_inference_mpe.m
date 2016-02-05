function X=chain_inference_mpe(beta0,beta1);

[N,C]=size(beta0);

for n=1:N-1
    alpha(:,:,n)=bsxfun(@plus,beta0(n,:)',beta1);
end    
alpha(:,:,N-1) = bsxfun(@plus,beta0(N,:),alpha(:,:,N-1));

deltaF = zeros(N,C);
for n=1:N-1
    if(n==1)
      Psi(:,:,n) = alpha(:,:,n);  
      deltaF(n+1,:) = max(Psi(:,:,n),[],1);
    else
      Psi(:,:,n) = bsxfun(@plus,deltaF(n,:)',alpha(:,:,n));  
      deltaF(n+1,:) = max(Psi(:,:,n),[],1);
    end    
end    

[foo,X(N)] = max(deltaF(N,:));
for n=(N-1):-1:1
  [foo,X(n)] = max(Psi(:,X(n+1),n));
end  




function [theta, mu, sigma, pz] = mogEMFull(X,R,K,max_iter)

%Inputs:
%  X - NxD data matrix with data cases as rows
%  R - NxD binary matrix of observed data indicators. Set to all 1s if data fully observed
%  K - number of clusters
%  max_iter - maximum number of iterations. Try 25 for a default
%
%Outputs:
%  theta - Kx1 vector of mixture proportions
%  mu    - KxD matrix of mean parameters
%  sigma - DxDxK tensor of DxD covariance matrices
%  pz    - NxK matrix of cluster probabilities for each data case

[NX,DX] = size(X);

%Initialize mixture proportions
theta   = ones(K,1);
theta   = theta/sum(theta);

%Initialize Means
perm  = randperm(NX);
mu    = X(perm(1:K),:);

%Initialize covariances
s = var(X(R==1));
for k=1:K
  sigma(:,:,k) = s*eye(DX,DX);
end

for i=1:max_iter

    %Initialize new parameters  
    mu_new = zeros(K,DX);
    sigma_new = zeros(DX,DX,K);

    for n=1:NX
    
      %if(mod(n,100)==0);fprintf('.');end;

      obs = find(R(n,:)==1);   
      mis = find(R(n,:)==0);

      %Estimate mixture posterior
      if(K>1)
        for k=1:K
          logPz(k)  =0;
          p = mvnpdf(X(n,obs),mu(k,obs),sigma(obs,obs,k)) ;
          sigma_inv{k}  = inv(sigma(:,:,k));
          logPz(k) = log(p);
          logPz(k) = logPz(k) + log(theta(k));
        end
        Pz(:,n)  = exp(logPz - logsum(logPz,2))';
      else
        Pz(1,n) = 1;
        sigma_inv{1} = inv(sigma(obs,obs,1));
      end

      for k=1:K

        if(length(mis>0))
          %Compute expectation of Xmis 
          Xhat     = mu(k,mis) ;
          if(length(obs)>0); Xhat = Xhat + (X(n,obs)-mu(k,obs))*sigma_inv{k}*sigma(obs,mis,k);end;

          %Compute expectation of Xmis*Xmis'
          XXhat    = sigma(mis,mis,k)  +  Xhat'*Xhat;
          if(length(obs)>0); XXhat= XXhat - sigma(mis,obs,k)*sigma_inv{k}*sigma(obs,mis,k);end
          
          mu_new(k,mis) = mu_new(k,mis)+Pz(k,n)*Xhat;
          sigma_new(mis,mis,k) = sigma_new(mis,mis,k) + Pz(k,n)*(XXhat - mu(k,mis)'*Xhat - Xhat'*mu(k,mis) + mu(k,mis)'*mu(k,mis));
        end

        if(length(obs>0))
          mu_new(k,obs) = mu_new(k,obs)+Pz(k,n)*X(n,obs);
          sigma_new(obs,obs,k)   = sigma_new(obs,obs,k) + Pz(k,n)*(X(n,obs)-mu(k,obs))'*(X(n,obs)-mu(k,obs));          
        end
        
        if(length(obs>0) & length(mis)>0)        
          temp                   = Pz(k,n)*(X(n,obs)-mu(k,obs))'*(Xhat-mu(k,mis));        
          sigma_new(obs,mis,k)   = sigma_new(obs,mis) + temp;
          sigma_new(mis,obs,k)   = sigma_new(mis,obs) + temp';
        end
      end
   end
   
    %Normalize estimates by total responsibility
    resp = sum(Pz,2);
    for k=1:K
      theta(k,1) = (1+sum(Pz(k,:),2))/(K+sum(Pz(:)));
      mu(k,:) = mu_new(k,:) / (0.005+resp(k));
      sigma(:,:,k) = (sigma_new(:,:,k)+1*eye(DX)) / (0.05+resp(k));
    end
    
end

Pz = Pz';
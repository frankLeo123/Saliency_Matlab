function [L, S] = SMD( F, M, tree, weight, alpha, beta)
% This routine solves the following structured matrix fractorization optimization problem,
%   min |L|_* + alpha*tr(SMS^T) + beta*\sum\sum|w_g*S_g|_p
%   s.t., F = L + S
% inputs:
%       F -- D*N data matrix, D is the data dimension, and N is the number of data vectors.           
%       M -- N*N laplacian matrix
%       tree -- index tree
%       weight -- weight of each node in the tree
%       alpha -- the penalty for tr(SMS^T)
%       beta -- the penalty for |w_g*S_g|_p
% outputs:
%       L -- D*N low-rank matrix
%       S -- D*N structured-sparse matrix
%
%% References
%   [1] Houwen Peng et al. 
%       Salient Object Detection via Structured Matrix Decomposition.
%   [2] Houwen Peng, Bing Li, Rongrong Ji, Weiming Hu, Weihua Xiong, Congyan Lang: 
%       Salient Object Detection via Low-Rank and Structured Sparse Matrix 
%       Decomposition. AAAI 2013: 796-802.

%% intialize
tol1 = 1e-5; %threshold for the error in constraint
tol2 = 1e-5; %threshold for the change in the solutions
maxIter = 1000;
rho = 1.1;
mu = 1e-1;
max_mu = 1e10;
[d n] = size(F);

% to save time
normfF = norm(F,'fro');

% initialize optimization variables
L = zeros(d,n);
Z = zeros(d,n);
S = zeros(d,n);
Y1 = zeros(d,n);
Y2 = zeros(d,n);
svp = 5; % for svd

%% start main loop
iter = 0;
%disp(['initial rank=' num2str(rank(Z))]);
while iter < maxIter
    iter = iter + 1;
    
    % copy Z and S to compute the change in the solutions
    Lk = L;
    Sk = S;
    % to save time
    Y1_mu = Y1./mu;
    Y2_mu = Y2./mu;
    
    % update L  
    temp = F - S + Y1_mu;
    [U,sigma,V] = svd(temp,'econ');
    sigma = diag(sigma);
    svp = length(find(sigma>1/mu));
    if svp>=1
        sigma = sigma(1:svp)-1/mu;
    else
        svp = 1;
        sigma = 0;
    end
    L = U(:,1:svp) * diag(sigma) * V(:,1:svp)';
  
    % udpate Z
    temp = (2*alpha).*M + mu.*eye(n);
    Z = (mu.*S + Y2) / temp; %faster and more accurate than inv(temp)
    
    % update S    
    T = 0.5.* ( F - L + Z + Y1_mu - Y2_mu);
    lambada = 0.5*beta/mu;
   
    S = T;
    for i = 1:length(tree)
        Sl1 = sum(abs(S));
        for j = 1:length(tree{i})
            gij = tree{i}{j};
            gij_l1 = sum(Sl1(gij)); %%%%
            weightij = lambada * weight{i}(j);
            if gij_l1 > weightij
                temp = (gij_l1 - weightij) / gij_l1;
                S(:,gij) = temp .* S(:,gij);
            else
                S(:,gij) = 0;
            end
        end
    end
  
    % check convergence condition
    leq1 = F - L - S;
    leq2 = S - Z;
    relChgL = norm(L - Lk,'fro')/normfF;
    relChgS = norm(S - Sk,'fro')/normfF;
    relChg = max(relChgL, relChgS);
    recErr = norm(leq1,'fro')/normfF; 
    
    convergenced = recErr <tol1 && relChg < tol2;
    
    if iter==1 || mod(iter,50)==0 || convergenced
        %disp(['iter ' num2str(iter) ',mu=' num2str(mu,'%2.1e') ...
        %    ',rank=' num2str(rank(L,1e-3*norm(L,2))) ',stopADM=' num2str(recErr,'%2.3e')]);
    end
    if convergenced
        %disp('SMF done.');
        break;
    else
        Y1 = Y1 + mu*leq1;
        Y2 = Y2 + mu*leq2;
        mu = min(max_mu,mu*rho);        
    end
end

function [S_sal] = postProcessing (L_sal, S_sal, bdCon, fstReachMat, W, sup)
    % removeLowVals
    thresh = graythresh(S_sal);  %automatic threshold
    S_sal(S_sal < thresh) = 0;
    
    % Give a very large weight for very confident bg sps can get slightly
    % better saliency maps, you can turn it off.
    L_sal(bdCon > 0.8) = 1000;

    % add regularization term on 'W'
    W = W + fstReachMat .* 0.1;
    DCol = full(sum(W,2));
    D = spdiags(DCol,0,speye(sup.num));
    M = D - W;
    
    % postprocessing using the method proposed in [W. Zhu et al., CVPR'14]
    spNum = length(L_sal);
    optwCtr =(M + diag(L_sal * 1.5) +  diag(S_sal )) \ ( diag(S_sal ) * ones(spNum, 1));
    
    % postprocessing to enhance foreground saliency
    thresh = graythresh(optwCtr);  %automatic threshold
    optwCtr(optwCtr > thresh) = 1000;
    optwCtr =(M + diag(L_sal * 1.5) +  diag(optwCtr )) \ ( diag(optwCtr ) * ones(spNum, 1));
    
    % propagation
    S_sal = descendPropagation(sup.Lab, optwCtr', sup.num, 3);
   
end

function [distMat] = ComputeFeatDistMat(feat)
% FUNCTION: compute l2-norm distance between every two superpixels
% INPUT:    feature matrix
% OUTPUT:   distance matrix
    supNum = size(feat,1);
    distMat = zeros(supNum, supNum);
    for n = 1:size(feat, 2)
        distMat = distMat + ( repmat(feat(:,n), [1, supNum]) - repmat(feat(:,n)', [supNum, 1]) ).^2;
    end
    distMat = sqrt(distMat);
end
function [bgPrior, bdCon] = GetPriorByRobustBackgroundDetection(distMat, fstReachMat, bndIdx)
    
    % link boundary superpixels
    fstReachMat(bndIdx, bndIdx) = 1;
    fstReachMat = tril(fstReachMat, -1);
    distMatEdge = distMat(fstReachMat>0);
    % Cal pair-wise shortest path cost (geodesic distance)
    geoDistMat = graphallshortestpaths(sparse(fstReachMat), 'directed', false, 'Weights', distMatEdge);
    geoDistMat = reshape(mapminmax(geoDistMat(:)',0,1), size(geoDistMat)); 
    Wgeo = Dist2WeightMatrix(geoDistMat, 0.12);
    Len_bnd = sum( Wgeo(:, bndIdx), 2); % length of perimeters on boundary
    Area = sum(Wgeo, 2);    % soft area
    bdCon = Len_bnd ./ sqrt(Area);
    bdCon = mapminmax(bdCon',0,1)';
    bgPrior = exp(-bdCon.^2 / (2 * 0.3 * 0.3)); %Estimate bg probability
    
end
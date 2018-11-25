function [weightOnEdge] = ComputeWeightOnEdge(distMat, reachMat_lowTri, delta)

    % convert distance matrix to vector
    distMatEdge = distMat(reachMat_lowTri>0);
    %distMatEdge = normalize(distMatEdge); % row normalize to [0,1] 
    distMatEdge = mapminmax(distMatEdge',0,1)'; % row normalize to [0,1] 
    % get the weights on edges
    weightOnEdge = exp(-1/(2*delta)*distMatEdge);
    % weightOnEdge = exp(-distMatEdge.^2 ./ (2 * colorSigma * colorSigma) );
end
function [fstReachMat, fstSndReachMat, fstSndReachMat_lowTri] = GetFstSndReachMat(lblImg, supNum, setDiagEleZero)
% FUNCTION: Get the first and second order reachable matrix
% INPUT:
%   lblImg          --   superpixel labels
%   supNum          --   superpixel number
%   setDiagEleZero  -- 'true' is to set diagnal elements to zero
% OUTPUT:
%   fstReachMat             --  the first order reachable matrix
%   fstSndReachMat          --  the first and second order reachable matrix
%   fstSndReachMat_lowTri   --  the lower triangular matrix of the first and second order reachable matrix

    height = size(lblImg,1);
    %Get edge pixel locations (4-neighbor)
    topbotDiff = diff(lblImg, 1, 1) ~= 0;
    topEdgeIdx = find( padarray(topbotDiff, [1 0], false, 'post') ); %those pixels on the top of an edge
    botEdgeIdx = topEdgeIdx + 1;
    leftrightDiff = diff(lblImg, 1, 2) ~= 0;
    leftEdgeIdx = find( padarray(leftrightDiff, [0 1], false, 'post') ); %those pixels on the left of an edge
    rightEdgeIdx = leftEdgeIdx + height;
    %Get the first order reachable matrix
    fstReachMat = zeros(supNum, supNum);
    fstReachMat( sub2ind([supNum, supNum], lblImg(topEdgeIdx), lblImg(botEdgeIdx)) ) = 1;
    fstReachMat( sub2ind([supNum, supNum], lblImg(leftEdgeIdx), lblImg(rightEdgeIdx)) ) = 1;
    fstReachMat = fstReachMat + fstReachMat';
    fstReachMat(1:supNum+1:end) = 1;    %set diagonal elements to 1
    
    fstReachMat = sparse(fstReachMat);
    % Get the first and second order reachable matrix
    fstSndReachMat = (fstReachMat * fstReachMat + fstReachMat) > 0;
    fstSndReachMat = double(fstSndReachMat);
    % return lower triangular matrix
    fstSndReachMat_lowTri = tril(fstSndReachMat, -1);
end
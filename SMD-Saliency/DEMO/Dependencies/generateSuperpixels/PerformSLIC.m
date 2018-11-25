function [label, num, Lab] = PerformSLIC(img)
% FUNCTION: generate SLIC superpixels
% INPUT:    img - image information
% OUTPUT:   label - superpixels label
%           num - superpixel number
%           Lab - average Lab color value of superpixels

    RGB = double(img.RGB);
    pixNum = img.height * img.width;    
    imgVecR = reshape( RGB(:,:,1)', pixNum, 1);
    imgVecG = reshape( RGB(:,:,2)', pixNum, 1);
    imgVecB = reshape( RGB(:,:,3)', pixNum, 1);

    % m is the compactness parameter, k is the super-pixel number in SLIC algorithm
    m = 20;      k = 250;  
    imgAttr=[img.height, img.width, k, m, pixNum ];
    % obtain superpixel from SLIC algorithm: LabelLine is the super-pixel label vector of the image,
    % Sup1, Sup2, Sup3 are the mean L a b colour value of each superpixel,
    %  k is the number of the super-pixel.
    [labelVec, L, a, b, num ] = SLIC(imgVecR, imgVecG, imgVecB, imgAttr );
    Lab = [L, a, b];
    label = reshape(labelVec, img.width, img.height);
    label = label';     % the superpixle label
    if min(labelVec) == 0
        label = label + 1;
    end
    
end
    
  
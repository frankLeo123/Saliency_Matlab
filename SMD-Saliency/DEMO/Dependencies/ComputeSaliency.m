function [salMap] = ComputeSaliency(img, paras, setting)
% FUNCTION: Calculate saliency using Structured Matrix Fractorization (SMF)
% INPUT:    img - input image
%           paras - parameter setting
% OUTPUT:   saliency map

%% STEP-1. Read an input images and perform preprocessing
[img.height, img.width] = size(img.RGB(:,:,1));
[noFrameImg.RGB, noFrameImg.frame] = RemoveFrame(img.RGB, 'sobel');
[noFrameImg.height, noFrameImg.width, noFrameImg.channel] = size(noFrameImg.RGB);

%% STEP-2. Generate superpixels using SLIC
[sup.label, sup.num, sup.Lab] = PerformSLIC(noFrameImg);
% get superpixel statistics
sup.pixIdx = cell(sup.num, 1);
sup.pixNum = zeros(sup.num,1);
for i = 1:sup.num
     temp = find(sup.label==i);
     sup.pixIdx{i} = temp;
     sup.pixNum(i) = length(temp);
end
sup.pos = GetNormedMeanPos(sup.pixIdx, noFrameImg.height, noFrameImg.width);

%% STEP-3. Extract features
featImg = ExtractFeature(im2single(img.RGB));
for i = 1:3
    featImg(:,:,i) = mat2gray(featImg(:,:,i)).*255;
end
featMat = GetMeanFeat(featImg, sup.pixIdx);  
featMat = featMat./255;
colorFeatures = featMat(:,1:3);
medianR = median(colorFeatures(:,1)); medianG = median(colorFeatures(:,2)); medianB = median(colorFeatures(:,3));
featMat(:,1:3) = (featMat(:,1:3)-1.2*repmat([medianR, medianG, medianB],size(featMat,1),1))*1.5;
%featMapShow(mapminmax(sum(abs(featMat),2)',0,1), sup.label);

%% STEP-4. Create index tree
% get the first and second order reachable matrix (a.k.a adjacent matrix)
[fstReachMat, fstSndReachMat, fstSndReachMat_lowTri] = GetFstSndReachMat(sup.label, sup.num);
% get linked superpixel pairs
[tmpRow, tmpCol] = find(fstSndReachMat_lowTri>0);
edge = [tmpRow, tmpCol];
% compute color distance between adjacent superpixels
colorDistMat = ComputeFeatDistMat(sup.Lab);
% get the weights on edges
weightOnEdge = ComputeWeightOnEdge(colorDistMat, fstSndReachMat_lowTri, paras.delta);
% hierachical segmenation
k = [300 600 2000]; % for hierachical segmentation
multiSegments = mexMergeAdjRegs_Felzenszwalb(edge, weightOnEdge, sup.num, k, sup.pixNum);
% index tree
Tree = CreateIndexTree(sup.num, multiSegments);
%showIndexTree(img, sup, multiSegments);

%% STEP-5. Get high-level priors
% load color prior matrix as used in [X. Shen and Y. Wu, CVPR'12]
if ~exist('colorPriorMat','var')
    fileID = fopen('ColorPrior','rb');
    data = fread(fileID,'double');
    fclose(fileID);
    colorPriorMat = reshape(data(end-399:end), 20, 20);
end
% get the indexes of boundary superpixels
bndIdx = GetBndSupIdx(sup.label);
% get banckground prior by robust background detection [W. Zhu et al., CVPR'14]
[bgPrior, bdCon] = GetPriorByRobustBackgroundDetection(colorDistMat, fstReachMat, bndIdx);
% subplot(1,2,1);featMapShow(bgPrior, sup.label);
prior = GetHighLevelPriors(sup.pos, sup.num, colorPriorMat, colorFeatures, bgPrior);
% pre-processing
featMat = repmat(prior,1,53) .* featMat;

% convert high-level priors as the weight in the structured sparsity
% regularization term
weight = cell(1,length(Tree));
for m = 1:length(Tree)
    for n = 1:length(Tree{m})
        ind = cell2mat(Tree{m}(n));
        tmpPri = prior(ind);
        weight{m}(n) = max(1-max(tmpPri),0);
    end
end

%% STEP-6. Compute affinity and laplacian matrix
% link boundary superpixels
fstSndReachMat(bndIdx, bndIdx) = 1;
fstSndReachMat_lowTri_Bnd = tril(fstSndReachMat, -1);
[tmpRow, tmpCol] = find(fstSndReachMat_lowTri_Bnd>0);
edge = [tmpRow, tmpCol];
% get the weights on edges
weightOnEdge = ComputeWeightOnEdge(colorDistMat, fstSndReachMat_lowTri_Bnd, paras.delta);
% compute affinity matrix
W = sparse([edge(:,1);edge(:,2)], [edge(:,2);edge(:,1)], [weightOnEdge; weightOnEdge], sup.num, sup.num);
DCol = full(sum(W,2));
D = spdiags(DCol,0,speye(sup.num));
M = D - W;

%% STEP-7. Structured matrix decomposition
[L, S] = SMD(featMat', M, Tree, weight, paras.alpha, paras.beta);
S_sal = mapminmax(sum(abs(S),1),0,1);
%featMapShow(mat2gray(S_sal),sup.label);

%% STEP-8: Post-processing to get improvements
% parameters for postprocessing
if(setting.postProc)
    lambada = 0.1;  % 0.1 is good
    L_sal = lambada * (1-mapminmax(sum(abs(L),1),0,1)') + (1-lambada) * (1 - mapminmax(bgPrior',0,1)');
    S_sal = postProcessing(L_sal, S_sal, bdCon, fstReachMat, W, sup);    
end
% save saliency map
salMap = GetSaliencyMap(S_sal, sup.pixIdx, noFrameImg.frame, true);

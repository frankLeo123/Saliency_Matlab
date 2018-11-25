function [ ] = rbd( SRC,RES,srcSuffix )
%RBD 此处显示有关此函数的摘要
%   此处显示详细说明
%%
addpath(genpath('G:\Project\Project\cvpr\Saliency_Matlab\config\RBD\Funcs'));

%% 1. Parameter Settings
doFrameRemoving = true;
sumtime = 0;
useSP = true;           %You can set useSP = false to use regular grid for speed consideration
doMAEEval = true;       %Evaluate MAE measure after saliency map calculation
doPRCEval = true;       %Evaluate PR Curves after saliency map calculation
BDCON = 'G:\Project\Project\cvpr\Saliency_Matlab\config\RBD\Data\BDCON';   %Path for saving bdCon feature image
if ~exist(BDCON, 'dir')
    mkdir(BDCON);
end
if ~exist(RES, 'dir')
    mkdir(RES);
end
%% 2. Saliency Map Calculation
files = dir(fullfile(SRC, strcat('*', srcSuffix)));
for k=1:length(files)
    disp(k);
%     t1 = clock;
    srcName = files(k).name;
    noSuffixName = srcName(1:end-length(srcSuffix));
    %% Pre-Processing: Remove Image Frames
    srcImg = imread(fullfile(SRC, srcName));
    
    
    if doFrameRemoving
        [noFrameImg, frameRecord] = removeframeRBD(srcImg, 'sobel');
        [h, w, chn] = size(noFrameImg);
    else
        noFrameImg = srcImg;
        [h, w, chn] = size(noFrameImg);
        frameRecord = [h, w, 1, h, 1, w];
    end
    
    %% Segment input rgb image into patches (SP/Grid)
    pixNumInSP = 600;                           %pixels in each superpixel
    spnumber = round( h * w / pixNumInSP );     %super-pixel number for current image
    
    if useSP
        [idxImg, adjcMatrix, pixelList] = SLIC_Split(noFrameImg, spnumber);
    else
        [idxImg, adjcMatrix, pixelList] = Grid_Split(noFrameImg, spnumber);
    end
    %% Get super-pixel properties
    spNum = size(adjcMatrix, 1);
    meanRgbCol = GetMeanColor(noFrameImg, pixelList);
    meanLabCol = colorspace('Lab<-', double(meanRgbCol)/255);
    meanPos = GetNormedMeanPos(pixelList, h, w);
    bdIds = GetBndPatchIds(idxImg);
    colDistM = GetDistanceMatrix(meanLabCol);
    posDistM = GetDistanceMatrix(meanPos);
    [clipVal, geoSigma, neiSigma] = EstimateDynamicParas(adjcMatrix, colDistM);
    
    %% Saliency Optimization
    [bgProb, bdCon, bgWeight] = EstimateBgProb(colDistM, adjcMatrix, bdIds, clipVal, geoSigma);
    wCtr = CalWeightedContrast(colDistM, posDistM, bgProb);
    optwCtr = SaliencyOptimization(adjcMatrix, bdIds, colDistM, neiSigma, bgWeight, wCtr);
%     t2 = clock;
%     time = etime(t2,t1)
%     sumtime =time + sumtime;
%     avgtime = sumtime /k
    smapName=fullfile(RES, strcat(noSuffixName, '.png'));
    SaveSaliencyMap(optwCtr, pixelList, frameRecord, smapName, true);
    

end

end


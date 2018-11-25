function [ ] = rbd( SRC,RES,RES_MR,srcSuffix )
%RBD 此处显示有关此函数的摘要
%   此处显示详细说明
%%
addpath(genpath('F:\Project\Project\cvpr\Saliency_Matlab\config\RBD\Funcs'));

%% 1. Parameter Settings
doFrameRemoving = true;
sumtime = 0;
useSP = true;           %You can set useSP = false to use regular grid for speed consideration
doMAEEval = true;       %Evaluate MAE measure after saliency map calculation
doPRCEval = true;       %Evaluate PR Curves after saliency map calculation
BDCON = 'F:\Project\Project\cvpr\Saliency_Matlab\config\RBD\Data\BDCON';   %Path for saving bdCon feature image
if ~exist(BDCON, 'dir')
    mkdir(BDCON);
end
if ~exist(RES, 'dir')
    mkdir(RES);
end
if ~exist(RES_MR, 'dir')
    mkdir(RES_MR);
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
        [noFrameImg, frameRecord] = removeframe(srcImg, 'sobel');
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
    
    %Uncomment the following lines to save more intermediate results.
    %     smapName=fullfile(RES, strcat(noSuffixName, '_wCtr.png'));
    %     SaveSaliencyMap(wCtr, pixelList, frameRecord, smapName, true);
    %         smapName=fullfile(RES, strcat(noSuffixName,'_bgProb.png'));
    %         SaveSaliencyMap(bgProb, pixelList, frameRecord, smapName, false, 1);
    
    %     %Visualize BdCon, bdConVal = intensity / 30;
    %         smapName=fullfile(BDCON, strcat(noSuffixName, '_bdCon_toDiv30.png'));
    %         SaveSaliencyMap(bdCon * 30 / 255, pixelList, frameRecord, smapName, false);
    %% Geodesic Saliency
    
    geoDist = GeodesicSaliency(adjcMatrix, bdIds, colDistM, posDistM, clipVal);
    
    smapName=fullfile(RES_MR, strcat(noSuffixName, '.png'));
    SaveSaliencyMap(geoDist, pixelList, frameRecord, smapName, true);

end

end


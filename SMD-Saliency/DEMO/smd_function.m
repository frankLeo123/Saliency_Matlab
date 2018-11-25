function [ ] = smd_function( inputImgPath_,resSalPath_,input_suffix )
%SMD 此处显示有关此函数的摘要
%   此处显示详细说明
%% compile mex file
%% Path settings
% inputImgPath = {'E:\Dataset\img\DUT-OMRON\','E:\Dataset\result\MSRA1K\singleHSI3\','E:\Dataset\result\PASCAL\singleHSI3\','E:\Dataset\result\DUT-OMRON\singleHSI3\'};                 % input image path
% resSalPath = {'E:\Dataset\result\DUT-OMRON\SMD\','E:\Dataset\result\single\MSRA1K\SMD\','E:\Dataset\result\single\PASCAL\SMD\','E:\Dataset\result\single\DUT-OMRON\SMD\'};                     % result path
itemInput = inputImgPath_;                 % input image path
itemOutput = resSalPath_;                     % result path

% for i = 1:length(resSalPath)
%     %     if ~exist(resSalPath(i), 'file')
%     disp(resSalPath(i));
    itemInput = char(itemInput);
    itemOutput = char(itemOutput);
    mkdir(itemOutput);
    addpath(genpath('Dependencies'));
    
    %% Parameter settings
    paras.alpha = 1.1;
    paras.beta = 0.35;
    paras.delta = 0.05;
    setting.postProc = true; % perform the context-based propagation technique metioned in Sec. 4.1 (Step 4).
    
    %% Calculate saliency using Structured Matrix Fractorization (SMF)
    
    imgFiles = dir([itemInput,'*',input_suffix]);
%     imgFiles=dir([itemInput  '*.jpg']);
    sumtime =0;
    for indImg = 1:length(imgFiles)
        % read image
        disp(indImg);
        t1 =clock;
        imgPath = fullfile(itemInput, imgFiles(indImg).name);
        img.RGB = imread(imgPath);
        img.name = imgPath((strfind(imgPath,'\')+1):end);
        
        % calculate saliency map via structured matrix decomposition
        salMap = ComputeSaliency(img, paras, setting);
        path_name = [itemOutput imgFiles(indImg).name(1:end-4) '.png'];
        imwrite(salMap,path_name);
    end;
    
end

% end


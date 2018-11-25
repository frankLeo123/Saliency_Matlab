clc;clear;
close all;
%% compile mex file
%disp 'compile mex files ... ...'
%compile;
%disp 'compile done'

%% Path settings
inputImgPath = {'E:\dataset\dataset\img\ECSSD\','E:\Dataset\result\MSRA1K\singleHSI3\','E:\Dataset\result\PASCAL\singleHSI3\','E:\Dataset\result\DUT-OMRON\singleHSI3\'};                 % input image path
% inputImgPath = 'E:\Dataset\img\\';
% test = ['1','2'];
% for i = 1:length(test)
%     disp(test(i))
% end;
resSalPath = {'E:\Dataset\result\DUT-OMRON\SMD\','E:\Dataset\result\single\MSRA1K\SMD\','E:\Dataset\result\single\PASCAL\SMD\','E:\Dataset\result\single\DUT-OMRON\SMD\'};                     % result path
for i = 1:length(resSalPath)
    %     if ~exist(resSalPath(i), 'file')
    disp(resSalPath(i));
    itemInput = char(inputImgPath(i));
    itemOutput = char(resSalPath(i));
    mkdir(itemOutput);
    %     end
    % end;
    % addpath
    addpath(genpath('Dependencies'));
    
    %% Parameter settings
    paras.alpha = 1.1;
    paras.beta = 0.35;
    paras.delta = 0.05;
    setting.postProc = true; % perform the context-based propagation technique metioned in Sec. 4.1 (Step 4).
    
    %% Calculate saliency using Structured Matrix Fractorization (SMF)
    
    imgFiles = imdir(itemInput);
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
        %     subplot(1,2,1);imshow(img.RGB,[]);title('Input RGB Image');
        %     subplot(1,2,2);imshow(salMap,[]);title('Saliency Map of Our SMD Method');
        
        % save saliency map
        %     salPath = fullfile(resSalPath, strcat(img.name(1:end-4), '.png'));
        %     imwrite(salMap,salPath);
        t2 = clock;
        time = etime(t2,t1)
        sumtime =time + sumtime;
        avgtime = sumtime /indImg
        path_name = [itemOutput imgFiles(indImg).name(1:end-4) '.png'];
        imwrite(salMap,path_name);
        
        %     fprintf('The saliency map: %s is saved in the file: SAL_MAP \n', img.name);
        %     fprintf('%s/%s images have been processed ... Press any key to continue ...\n', num2str(indImg), num2str(length(imgFiles)) );
        %     pause;
        close all;
    end;
    
end

%% Evaluate saliency map
gtPath = 'GROUND_TRUTH';
gtSuffix = '.png';
resPath = 'results';
if ~exist(resPath,'file')
    mkdir(resPath);
end

% % compute Precison-recall curve
% [rec, pre] = DrawPRCurve(resSalPath, '.png', gtPath, gtSuffix, true, true, 'r');
% PRPath = fullfile(resPath, ['PR.mat']);
% save(PRPath, 'rec', 'pre');
% fprintf('The precison-recall curve is saved in the file: %s \n', resPath);
%
% % compute ROC curve
% thresholds = [0:1:255]./255;
% [TPR, FPR] = CalROCCurve(resSalPath, '.png', gtPath, gtSuffix, thresholds, 'r');
% ROCPath = fullfile(resPath, ['ROC.mat']);
% save(ROCPath, 'TPR', 'FPR');
% fprintf('The ROC curve is saved in the file: %s \n', resPath);
%
% % compute F-measure curve
% setCurve = true;
% [meanP, meanR, meanF] = CalMeanFmeasure(resSalPath, '.png', gtPath, gtSuffix, setCurve, 'r');
% FmeasurePath = fullfile(resPath, ['FmeasureCurve.mat']);
% save(FmeasurePath, 'meanF');
% fprintf('The F-measure curve is saved in the file: %s \n', resPath);
%
% % compute MAE
% MAE = CalMeanMAE(resSalPath, '.png', gtPath, gtSuffix);
% MAEPath = fullfile(resPath, ['MAE.mat']);
% save(MAEPath, 'MAE');
% fprintf('MAE: %s\n', num2str(MAE'));
%
% % compute WF
% Betas = [1];
% WF = CalMeanWF(resSalPath, '.png', gtPath, gtSuffix, Betas);
% WFPath = fullfile(resPath, ['WF.mat']);
% save(WFPath, 'WF');
% fprintf('WF: %s\n', num2str(WF'));
%
% % compute AUC
% AUC = CalAUCScore(resSalPath, '.png', gtPath, gtSuffix);
% AUCPath = fullfile(resPath, ['AUC.mat']);
% save(AUCPath, 'AUC');
% fprintf('AUC: %s\n', num2str(AUC'));
%
% % compute Overlap ratio
% setCurve = false;
% overlapRatio = CalOverlap_Batch(resSalPath, '.png', gtPath, gtSuffix, setCurve, '0');
% overlapFixedPath = fullfile(resPath, ['ORFixed.mat']);
% save(overlapFixedPath, 'overlapRatio');
% fprintf('overlapRatio: %s\n', num2str(overlapRatio'));

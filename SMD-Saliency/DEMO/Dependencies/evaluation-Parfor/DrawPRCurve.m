function [rec, pre] = DrawPRCurve(SMAP, smapSuffix, GT, gtSuffix, targetIsFg, targetIsHigh, color)
% Draw PR Curves for all the image with 'smapSuffix' in folder SMAP
% GT is the folder for ground truth masks
% targetIsFg = true means we draw PR Curves for foreground, and otherwise
% we draw PR Curves for background
% targetIsHigh = true means feature values for our interest region (fg or
% bg) is higher than the remaining regions.
% color specifies the curve color

% Code Author: Wangjiang Zhu
% Email: wangjiang88119@gmail.com
% Date: 3/24/2014

files = dir(fullfile(SMAP, strcat('*', smapSuffix)));
num = length(files);
if 0 == num
    error('no saliency map with suffix %s are found in %s', smapSuffix, SMAP);
end

%precision and recall of all images
ALLPRECISION = zeros(num, 256);
ALLRECALL = zeros(num, 256);
for k = 1:num
    smapName = files(k).name;
    smapImg = imread(fullfile(SMAP, smapName));    
    
    gtName = strrep(smapName, smapSuffix, gtSuffix);
    gtImg = imread(fullfile(GT, gtName));
    
    [precision, recall] = CalPR(smapImg, gtImg, targetIsFg, targetIsHigh);
    
    ALLPRECISION(k, :) = precision;
    ALLRECALL(k, :) = recall;
end

pre = mean(ALLPRECISION, 1);   %function 'mean' will give NaN for columns in which NaN appears.
rec = mean(ALLRECALL, 1);

% plot
if ~strcmp(color, '0')
    plot(rec, pre, color, 'linewidth', 2);  
end
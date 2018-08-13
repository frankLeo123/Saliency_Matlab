% function demo_saliency(numberofsp)
clc;
close all;clear all;
addpath './MEX'
addpath './SLIC'
% cd('D:\documents\saliency\2012_saliency_filters');
k=6;

%%
pic ='./config/brid.png';
img2d = imread(pic);
numberofsp=50;
%0-1
img  = im2double(img2d);

%% demo find min_dix

[sp_res_slic,N_slic] = superpixels(img,250,'Method','slic','Compactness',15);
[sp_res_slic0,N_slic0] = superpixels(img,250,'Method','slic0','Compactness',15);

outputImage_slic = zeros(size(img),'like',img);
outputImage_slic0 = zeros(size(img),'like',img);

idx = label2idx(sp_res_slic);
numRows = size(img,1);
numCols = size(img,2);
for labelVal = 1:N_slic
    redIdx = idx{labelVal};
    greenIdx = idx{labelVal}+numRows*numCols;
    blueIdx = idx{labelVal}+2*numRows*numCols;
    outputImage_slic(redIdx) = mean(img(redIdx));
    outputImage_slic(greenIdx) = mean(img(greenIdx));
    outputImage_slic(blueIdx) = mean(img(blueIdx));
end
%slic0
idx = label2idx(sp_res_slic0);
numRows = size(img,1);
numCols = size(img,2);
for labelVal = 1:N_slic0
    redIdx = idx{labelVal};
    greenIdx = idx{labelVal}+numRows*numCols;
    blueIdx = idx{labelVal}+2*numRows*numCols;
    outputImage_slic0(redIdx) = mean(img(redIdx));
    outputImage_slic0(greenIdx) = mean(img(greenIdx));
    outputImage_slic0(blueIdx) = mean(img(blueIdx));
end

BW_res_slic = boundarymask(sp_res_slic);
BW_res_slic0 = boundarymask(sp_res_slic0);

% BW = boundarymask(sp);


%% write the result
subplot(3,2,1);
imshow(img);
title('Source Image');
subplot(3,2,3);
imshow(imoverlay(img,BW_res_slic,'white'),'InitialMagnification',100);
% img(redIdx) = mean(A(redIdx));
title('Super Segmentation slic');
subplot(3,2,4);
% imshow(imoverlay(img,BW_res,'white'),'InitialMagnification',100);
imshow(outputImage_slic,'InitialMagnification',100);
title('Super Segmentation slic');
subplot(3,2,6);
% imshow(imoverlay(img,BW_res_,'white'),'InitialMagnification',100);
imshow(outputImage_slic0,'InitialMagnification',100);
title('Super Segmentation slic0');
subplot(3,2,5);
imshow(imoverlay(img,BW_res_slic0,'white'),'InitialMagnification',100);
% imshow(outputImage_,'InitialMagnification',100);
title('Super Segmentation slic0');



% function demo_saliency(numberofsp)
clc;
close all;clear all;
addpath './MEX'
addpath './SLIC'
addpath './Select'
% cd('D:\documents\saliency\2012_saliency_filters');
k=6;
numSlic = 100;
compactness = 20;


%%
inputpath = 'E:\Dataset\img\ECSSD\';
inputpathHSI = 'E:\Dataset\img\result\ESCCD\hsi\';
inputpathGt = 'E:\Dataset\img\testE\gt\';
inputpathRbd = 'E:\Dataset\img\testE\result\rbd\';
outputpathHSI = 'E:\Dataset\result\ECSSD\hsi\';
outputpathRes = 'E:\Dataset\img\testE\result\Select\';

%%
% inputpath = 'E:\Dataset\img\MSRA10K\';
% outputpathHSI = 'E:\Dataset\result\MSRA10K\singleHSI\';

mkdir(outputpathRes);
mkdir(outputpathHSI);
Files=dir([inputpath  '*.jpg']);
% FileH=dir([inputpathHSI  '*h.png']);
% FileS=dir([inputpathHSI  '*s.png']);
% FileI=dir([inputpathHSI  '*i.png']);
% FileGt=dir([inputpathGt  '*.png']);
% FileRbd=dir([inputpathRbd  '*.png']);
number=length(Files);
%
for num=1:number
    % pic =imread('./config/Imgs/-3_0_735.jpg');
%     num = 53;
    pic = imread([inputpath Files(num).name]);
    disp([inputpath Files(num).name]);
%     ResH = imread([inputpathHSI FileH(num).name]);
%     ResS = imread([inputpathHSI FileS(num).name]);
%     ResI = imread([inputpathHSI FileI(num).name]);
%     ResGt = imread([inputpathGt FileGt(num).name]);
%     ResRbd = imread([inputpathRbd FileRbd(num).name]);

    %     img = equalhist(pic);
    %     %0-1
    img  = im2double(pic);
    %     img_gray = rgb2gray(img);
    %     img_channel = zeros(size(img_gray),'like',img_gray);
    %% demo find min_dix
    [hsi,H_channel,S_channel,I_channel]=rgb2hsi(img);
    
    
    
    
%     [img_channel] = selectChannel(img);
    img_channel = selectChannel(img);
    path_name = [outputpathHSI Files(num).name(1:end-4) '.png'];
    imwrite(img_channel,path_name);
    
    meanH = SLICSingle(H_channel,numSlic,compactness);
    meanS = SLICSingle(S_channel,numSlic,compactness);
    meanI = SLICSingle(I_channel,numSlic,compactness);
    
    ROImeanH = drawCircle(meanH);
    ROImeanS = drawCircle(meanS);
    ROImeanI = drawCircle(meanI);
    
%     path_name_h = [outputpathHSI [Files(num).name(1:end-4),'h'] '.png'];
%     imwrite(H_channel,path_name_h);
%     path_name_s = [outputpathHSI [Files(num).name(1:end-4),'s'] '.png'];
%     imwrite(S_channel,path_name_s);
%     path_name_i = [outputpathHSI [Files(num).name(1:end-4),'i'] '.png'];
%     imwrite(I_channel,path_name_i);
    
    
    [Yh,Xh]=imhist(H_channel,16);
    [Ys,Xs]=imhist(S_channel,16);
    [Yi,Xi]=imhist(I_channel,16);
%     [leftMax,rightMax,leftMin,rightMin] = calcArea( meanH );
%     drawH= drawCircle(leftMax,rightMax,leftMin,rightMin,img,meanH);
%     [leftMax,rightMax,leftMin,rightMin] = calcArea( meanS );
%     drawS= drawCircle(leftMax,rightMax,leftMin,rightMin,img,meanS);
%     [leftMax,rightMax,leftMin,rightMin] = calcArea( meanI );
%     drawI= drawCircle(leftMax,rightMax,leftMin,rightMin,img,meanI);

    
    
    
    %     [Yh,Xh]=imhist(H_channel,16);
%     [Ys,Xs]=imhist(S_channel,16);
%     [Yi,Xi]=imhist(I_channel,16);
    
    
    
    
    %% write the result
%     subplot(5,4,1);
%     imshow(img);
%     title('Source Image');
%     
%     subplot(5,4,2);
%     imshow(H_channel);
%     title('H-channel');
%     
%     subplot(5,4,3);
%     imshow(S_channel);
%     title('S-channel');
%     
%     subplot(5,4,4);
%     imshow(I_channel);
%     title('I-channel');
%     
%     subplot(5,4,6);
%     imshow(meanH);
%     title('H-channel slic');
%     
%     subplot(5,4,7);
%     imshow(meanS);
%     title('S-channel slic');
%     
%     subplot(5,4,8);
%     imshow(meanI);
%     title('I-channel slic');
%     
%     subplot(5,4,9);
%     imshow(img_channel);
%     title('channel');
%     
%     subplot(5,4,10);
%     plot(Xh,Yh,'r');
%     
%     title('H channel hist');
%     
%     subplot(5,4,11)
%     plot(Xs,Ys,'r');
%     title('S channel hist');
%     
%     subplot(5,4,12)
%     demo = plot(Xi,Yi,'r');
%     title('I channel hist');
%     
%     subplot(5,4,13);
%     imshow(ResRbd);
%     title('result Rbd');
%     
%     subplot(5,4,14);
%     imshow(ROImeanH);
%     title('H-channel draw');
%     
%     subplot(5,4,15);
%     imshow(ROImeanS);
%     title('S-channel draw');
%     
%     subplot(5,4,16);
%     imshow(ROImeanI);
%     title('I_channel draw')
%     
%     subplot(5,4,17);
%     imshow(ResGt);
%     title('ground truth');
%     
%     subplot(5,4,18);
%     imshow(ResH);
%     title('H-channel result');
%     
%     subplot(5,4,19);
%     imshow(ResS);
%     title('S-channel result');
%     
%     subplot(5,4,20);
%     imshow(ResI);
%     title('I_channel result')
%     num = num
%     saveas(demo,[outputpathRes,Files(num).name],'jpg');
end



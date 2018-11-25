% function demo_saliency(numberofsp)
clc;
close all;clear all;
addpath './MEX'
addpath './SLIC'
% cd('D:\documents\saliency\2012_saliency_filters');
k=6;

%% MSRA1K ECSSD DUT-OMRON PASCAL
inputpath = 'E:\Paper\img\pic\';
% outputpath_hsi = 'E:\Dataset\img\testE\hsi\';
outputpath = 'E:\Paper\img\channel\';
outputpathHist = 'E:\Paper\img\hist\';
mkdir(outputpathHist);
mkdir(outputpath);
Files=dir([inputpath '*.jpg']);
number=length(Files);
%
for num=1:number
    img = imread([inputpath Files(num).name]);
    %% demo find min_dix
    [hsi,H_channel,S_channel,I_channel]=rgb2hsi(img);
    lab = rgb2lab(img);
    
    for i =1:3
        max_ = max(max(lab(:,:,i)));
        min_ = min(min(lab(:,:,i)));
        lab(:,:,i) = (lab(:,:,i)-min_) / (max_ - min_);
    end;
    L_channel = lab(:,:,1);
    A_channel = lab(:,:,2);
    B_channel = lab(:,:,3);
    
    path_name_h = [outputpath [Files(num).name(1:end-4),'h'] '.png'];
    imwrite(H_channel,path_name_h);
    path_name_s = [outputpath [Files(num).name(1:end-4),'s'] '.png'];
    imwrite(S_channel,path_name_s);
    path_name_i = [outputpath [Files(num).name(1:end-4),'i'] '.png'];
    imwrite(I_channel,path_name_i);
    %     lab single
    path_name_l = [outputpath [Files(num).name(1:end-4),'l'] '.png'];
    imwrite(L_channel,path_name_l);
    path_name_a = [outputpath [Files(num).name(1:end-4),'a'] '.png'];
    imwrite(A_channel,path_name_a);
    path_name_b = [outputpath [Files(num).name(1:end-4),'b'] '.png'];
    imwrite(B_channel,path_name_b);
    
    
    [Y,X]=imhist(H_channel,16);
    demo = plot(X,Y);
    set (gcf,'Position',[100,100,150,150], 'color','w')
    saveas(demo,[outputpathHist,Files(num).name(1:end-4),'h'],'png');
    
    [Y,X]=imhist(S_channel,16);
    demo = plot(X,Y);
    saveas(demo,[outputpathHist,Files(num).name(1:end-4),'s'],'png');
    
    [Y,X]=imhist(I_channel,16);
    demo = plot(X,Y);
    saveas(demo,[outputpathHist,Files(num).name(1:end-4),'i'],'png');
    
    [Y,X]=imhist(L_channel,16);
    demo = plot(X,Y);
    saveas(demo,[outputpathHist,Files(num).name(1:end-4),'l'],'png');
    
    [Y,X]=imhist(A_channel,16);
    demo = plot(X,Y);
    saveas(demo,[outputpathHist,Files(num).name(1:end-4),'a'],'png');
    
    [Y,X]=imhist(B_channel,16);
    demo = plot(X,Y);
    saveas(demo,[outputpathHist,Files(num).name(1:end-4),'b'],'png');
end



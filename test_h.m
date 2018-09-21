% function demo_saliency(numberofsp)
clc;
close all;clear all;
addpath './MEX'
addpath './SLIC'
% cd('D:\documents\saliency\2012_saliency_filters');
k=6;

%%
inputpath = './config/BSD-FULL/';
outputpath_slic = './debug/equal/mat-slic/';
outputpath_slic0 = './debug/equal/mat-slic0/';
outputpath_slic_ = './debug/equal/mat-slic_/';
outputpath_h = './debug/equal/mat-h/';
outputpath_s = './debug/equal/mat-s/';
outputpath_i = './debug/equal/mat-i/';
mkdir(outputpath_slic);
mkdir(outputpath_slic0);
mkdir(outputpath_slic_);
mkdir(outputpath_h);
mkdir(outputpath_s);
mkdir(outputpath_i);
Files=dir([inputpath '*.jpg']);
number=length(Files);
%
for num=1:number
    pic = imread([inputpath Files(num).name]);
    %     equalhist
    img = equalhist(pic);
    %0-1
    %     img_gray = rgb2gray(img);
    %     img_channel = zeros(size(img_gray),'like',img_gray);
    %% demo find min_dix
    [hsi,H_channel,S_channel,I_channel]=rgb2hsi(img);
    [Yh,Xh]=imhist(H_channel,64);
    [Ys,Xs]=imhist(S_channel,64);
    [Yi,Xi]=imhist(I_channel,64);
    left = 64* 0.25;
    right = 64 * 0.75;
    [ H_result ] = selectChannel( Yh,64,left,right);
    [ S_result ] = selectChannel( Ys,64,left,right );
    [ I_result ] = selectChannel( Yi,64,left,right );
    [sp_res_slic,N_slic] = superpixels(img,250,'Method','slic','Compactness',10);
    [sp_res_slic_0,N_slic_0] = superpixels(img,250,'Method','slic0','Compactness',10);
    [sp_res_slic_h,N_slic_h] = superpixels(H_channel,250,'Method','slic0','Compactness',10);
    [sp_res_slic_s,N_slic_s] = superpixels(S_channel,250,'Method','slic0','Compactness',10);
    [sp_res_slic_i,N_slic_i] = superpixels(I_channel,250,'Method','slic0','Compactness',10);
    maxChannel = max(max(H_result,S_result),I_result);
    if(maxChannel == H_result)
        
        img_channel = H_channel;
        %         [sp_res_slic,N_slic] = superpixels(H_channel,250,'Method','slic','Compactness',15);
        [sp_res_slic_,N_slic0] = superpixels(H_channel,250,'Method','slic0','Compactness',10);
    elseif(maxChannel == S_result)
        img_channel = S_channel;
        [sp_res_slic_,N_slic0] = superpixels(S_channel,250,'Method','slic0','Compactness',10);
        
    elseif(maxChannel == I_result)
        img_channel = I_channel;
        [sp_res_slic_,N_slic0] = superpixels(I_channel,250,'Method','slic0','Compactness',10);
    else
        fprintf('===error \n')
        fprintf('\n')
        fprintf(Files(num).name)
        img_channel = I_channel;
        [sp_res_slic_,N_slic0] = superpixels(I_channel,250,'Method','slic0','Compactness',10);
    end
    
    %%
    savename_slic = [outputpath_slic Files(num).name(1:end-4) '.mat'];
    savename_slic0 = [outputpath_slic0 Files(num).name(1:end-4) '.mat'];
    savename_slic_ = [outputpath_slic_ Files(num).name(1:end-4) '.mat'];
    savename_h = [outputpath_h Files(num).name(1:end-4) '.mat'];
    savename_s = [outputpath_s Files(num).name(1:end-4) '.mat'];
    savename_i = [outputpath_i Files(num).name(1:end-4) '.mat'];
    
    img_slic = uint16(sp_res_slic);
    img_slic0 = uint16(sp_res_slic_0);
    img_slic_ = uint16(sp_res_slic_);
    img_h = uint16(sp_res_slic_h);
    img_s = uint16(sp_res_slic_s);
    img_i = uint16(sp_res_slic_i);
    
    segs = cell(0);
    
    segs{1,1} = img_slic;
    save(savename_slic,'segs');
    
    segs{1,1} = img_slic0;
    save(savename_slic0,'segs');
    
    segs{1,1} = img_slic_;
    save(savename_slic_,'segs');
    
    segs{1,1} = img_i;
    save(savename_i,'segs');
    %    h channel
    segs{1,1} = img_h;
    save(savename_h,'segs');
    
    %     i channel
    segs{1,1} = img_s;
    save(savename_s,'segs');
    %     test = load('E:\Project\Saliency_Matlab\debug\mat\2018.mat');
    %     a = load('E:\lab\database\test_database\extended-berkeley-segmentation-benchmark-master\data\BSDS500\superpixel_segs\2018_.mat');
    %     b = a.segs{1,1};
    %     img_ = double(b)/255;
    %     imshow(img_);
    % saveas(demo,['./debug/','demo'],'jpg');
end



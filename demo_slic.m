% function demo_saliency(numberofsp)
clc;
close all;clear all;
addpath './MEX'
addpath './SLIC'
% cd('D:\documents\saliency\2012_saliency_filters');
k=6;

%%
inputpath = './config/Imgs/';
outputpath = './debug/slic-single/';
Files=dir([inputpath '*.jpg']);
number=length(Files);
%
for num=1:number
    % pic =imread('./config/Imgs/0_0_735.jpg');
    img = imread([inputpath Files(num).name]);
    %0-1
    % img  = im2double(pic);
    img_gray = rgb2gray(img);
    img_channel = zeros(size(img_gray),'like',img_gray);
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
    
    maxChannel = max(max(H_result,S_result),I_result);
    if(maxChannel == H_result)
        % [sp,N] = superpixels(H_channel,450,'Method','slic0','Compactness',15);
        img_channel = H_channel;
        [sp_res_slic0,N_slic0] = superpixels(H_channel,250,'Method','slic0','Compactness',15);
        [sp_res_slic1,N_slic1] = superpixels(H_channel,250,'Method','slic0','Compactness',15,'NumIterations',1);
        [sp_res_slic3,N_slic3] = superpixels(H_channel,250,'Method','slic0','Compactness',15,'NumIterations',3);
        [sp_res_slic5,N_slic5] = superpixels(H_channel,250,'Method','slic0','Compactness',15,'NumIterations',5);
        [sp_res_slic7,N_slic7] = superpixels(H_channel,250,'Method','slic0','Compactness',15,'NumIterations',7);
        [sp_res_slic9,N_slic9] = superpixels(H_channel,250,'Method','slic0','Compactness',15,'NumIterations',9);
    elseif(maxChannel == S_result)
        img_channel = S_channel;
        [sp_res_slic0,N_slic0] = superpixels(S_channel,250,'Method','slic0','Compactness',15);
        [sp_res_slic1,N_slic1] = superpixels(S_channel,250,'Method','slic0','Compactness',15,'NumIterations',1);
        [sp_res_slic3,N_slic3] = superpixels(S_channel,250,'Method','slic0','Compactness',15,'NumIterations',3);
        [sp_res_slic5,N_slic5] = superpixels(S_channel,250,'Method','slic0','Compactness',15,'NumIterations',5);
        [sp_res_slic7,N_slic7] = superpixels(S_channel,250,'Method','slic0','Compactness',15,'NumIterations',7);
        [sp_res_slic9,N_slic9] = superpixels(S_channel,250,'Method','slic0','Compactness',15,'NumIterations',9);
    elseif(maxChannel == I_result)
        img_channel = I_channel;
        %         fprintf('fine')
        [sp_res_slic0,N_slic0] = superpixels(I_channel,250,'Method','slic0','Compactness',15);
        [sp_res_slic1,N_slic1] = superpixels(I_channel,250,'Method','slic0','Compactness',15,'NumIterations',1);
        [sp_res_slic3,N_slic3] = superpixels(I_channel,250,'Method','slic0','Compactness',15,'NumIterations',3);
        [sp_res_slic5,N_slic5] = superpixels(I_channel,250,'Method','slic0','Compactness',15,'NumIterations',5);
        [sp_res_slic7,N_slic7] = superpixels(I_channel,250,'Method','slic0','Compactness',15,'NumIterations',7);
        [sp_res_slic9,N_slic9] = superpixels(I_channel,250,'Method','slic0','Compactness',15,'NumIterations',9);
    else
        fprintf('===error \n')
        fprintf('\n')
        fprintf(Files(num).name)
        [sp_res_slic0,N_slic0] = superpixels(I_channel,250,'Method','slic0','Compactness',15);
        [sp_res_slic1,N_slic1] = superpixels(I_channel,250,'Method','slic0','Compactness',15,'NumIterations',1);
        [sp_res_slic3,N_slic3] = superpixels(I_channel,250,'Method','slic0','Compactness',15,'NumIterations',3);
        [sp_res_slic5,N_slic5] = superpixels(I_channel,250,'Method','slic0','Compactness',15,'NumIterations',5);
        [sp_res_slic7,N_slic7] = superpixels(I_channel,250,'Method','slic0','Compactness',15,'NumIterations',7);
        [sp_res_slic9,N_slic9] = superpixels(I_channel,250,'Method','slic0','Compactness',15,'NumIterations',9);
    end
    % [sp_res_slic,N_slic] = superpixels(img,250,'Method','slic','Compactness',15);
    
    % outputImage_slic = zeros(size(img),'like',img);
    
    % idx = label2idx(sp_res_slic);
    % numRows = size(img,1);
    % numCols = size(img,2);
    % for labelVal = 1:N_slic
    %     redIdx = idx{labelVal};
    %     greenIdx = idx{labelVal}+numRows*numCols;
    %     blueIdx = idx{labelVal}+2*numRows*numCols;
    %     outputImage_slic(redIdx) = mean(img(redIdx));
    %     outputImage_slic(greenIdx) = mean(img(greenIdx));
    %     outputImage_slic(blueIdx) = mean(img(blueIdx));
    % end
    %slic0
    % idx = label2idx(sp_res_slic0);
    % numRows = size(img,1);
    % numCols = size(img,2);
    % for labelVal = 1:N_slic0
    %     redIdx = idx{labelVal};
    %     greenIdx = idx{labelVal}+numRows*numCols;
    %     blueIdx = idx{labelVal}+2*numRows*numCols;
    %     outputImage_slic0(redIdx) = mean(img(redIdx));
    %     outputImage_slic0(greenIdx) = mean(img(greenIdx));
    %     outputImage_slic0(blueIdx) = mean(img(blueIdx));
    % end
    
    % BW_res_slic = boundarymask(sp_res_slic);
    BW_res_slic0 = boundarymask(sp_res_slic0);
    BW_res_slic1 = boundarymask(sp_res_slic1);
    BW_res_slic3 = boundarymask(sp_res_slic3);
    BW_res_slic5 = boundarymask(sp_res_slic5);
    BW_res_slic7 = boundarymask(sp_res_slic7);
    BW_res_slic9 = boundarymask(sp_res_slic9);
    
    % BW = boundarymask(sp);
    
    
    %% write the result
    subplot(4,3,1);
    imshow(img);
    title('Source Image');
    
    subplot(4,3,2);
    imshow(H_channel);
    title('H-channel');
    
    subplot(4,3,3);
    imshow(S_channel);
    title('S-channel');
    
    subplot(4,3,4);
    imshow(I_channel);
    title('I-channel');
    
    subplot(4,3,5);
    imshow(img_channel);
    title('channel');
    
    subplot(4,3,6);
    imshow(imoverlay(img_channel,BW_res_slic0,'white'),'InitialMagnification',100);
    title('Single channel slic0');
    
    subplot(4,3,7);
    imshow(imoverlay(img,BW_res_slic0,'white'),'InitialMagnification',100);
    title('Super Segmentation slic0');
    
    subplot(4,3,8);
    imshow(imoverlay(img,BW_res_slic1,'white'),'InitialMagnification',100);
    title('Super Segmentation slic1');
    
    subplot(4,3,9);
    imshow(imoverlay(img,BW_res_slic3,'white'),'InitialMagnification',100);
    title('Super Segmentation slic3');
    subplot(4,3,10);
    imshow(imoverlay(img,BW_res_slic5,'white'),'InitialMagnification',100);
    title('Super Segmentation slic5');
    subplot(4,3,11);
    imshow(imoverlay(img,BW_res_slic7,'white'),'InitialMagnification',100);
    title('Super Segmentation slic7');
    subplot(4,3,12);
    demo = imshow(imoverlay(img,BW_res_slic9,'white'),'InitialMagnification',100);
    title('Super Segmentation slic9');
    saveas(demo,[outputpath,Files(num).name],'jpg');
    % saveas(demo,['./debug/','demo'],'jpg');
end



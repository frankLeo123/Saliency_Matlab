% function demo_saliency(numberofsp)
clc;
close all;clear all;
addpath './MEX'
addpath './SLIC'
% cd('D:\documents\saliency\2012_saliency_filters');
k=6;

%%
inputpath = 'E:/lab/database/salObj/datasets/imgs/pascal/';
outputpath = './debug/MASA/';
Files=dir([inputpath '*.jpg']);
number=length(Files);
%
for num=1:number
    % pic =imread('./config/Imgs/-3_0_735.jpg');
    pic = imread([inputpath Files(num).name]);
    img = equalhist(pic);
%     %0-1
%     % img  = im2double(pic);
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
        [sp_res_slic0,N_slic0] = superpixels(H_channel,250,'Method','slic0','Compactness',10);
        %         [sp_res_slic1,N_slic1] = superpixels(H_channel,250,'Method','slic0','Compactness',10,'NumIterations',1);
        %         [sp_res_slic3,N_slic3] = superpixels(H_channel,250,'Method','slic0','Compactness',15,'NumIterations',3);
        %         [sp_res_slic5,N_slic5] = superpixels(H_channel,250,'Method','slic0','Compactness',15,'NumIterations',5);
        %         [sp_res_slic7,N_slic7] = superpixels(H_channel,250,'Method','slic0','Compactness',15,'NumIterations',7);
        %         [sp_res_slic9,N_slic9] = superpixels(H_channel,250,'Method','slic0','Compactness',15,'NumIterations',9);
    elseif(maxChannel == S_result)
        img_channel = S_channel;
        %         [sp_res_slic,N_slic] = superpixels(S_channel,250,'Method','slic','Compactness',15);
        [sp_res_slic0,N_slic0] = superpixels(S_channel,250,'Method','slic0','Compactness',10);
        %         [sp_res_slic1,N_slic1] = superpixels(S_channel,250,'Method','slic0','Compactness',10,'NumIterations',1);
        %         [sp_res_slic3,N_slic3] = superpixels(S_channel,250,'Method','slic0','Compactness',15,'NumIterations',3);
        %         [sp_res_slic5,N_slic5] = superpixels(S_channel,250,'Method','slic0','Compactness',15,'NumIterations',5);
        %         [sp_res_slic7,N_slic7] = superpixels(S_channel,250,'Method','slic0','Compactness',15,'NumIterations',7);
        %         [sp_res_slic9,N_slic9] = superpixels(S_channel,250,'Method','slic0','Compactness',15,'NumIterations',9);
    elseif(maxChannel == I_result)
        img_channel = I_channel;
        %         fprintf('fine')
        %         [sp_res_slic,N_slic] = superpixels(I_channel,250,'Method','slic','Compactness',15);
        [sp_res_slic0,N_slic0] = superpixels(I_channel,250,'Method','slic0','Compactness',10);
        %         [sp_res_slic1,N_slic1] = superpixels(I_channel,250,'Method','slic0','Compactness',10,'NumIterations',1);
        %         [sp_res_slic3,N_slic3] = superpixels(I_channel,250,'Method','slic0','Compactness',15,'NumIterations',3);
        %         [sp_res_slic5,N_slic5] = superpixels(I_channel,250,'Method','slic0','Compactness',15,'NumIterations',5);
        %         [sp_res_slic7,N_slic7] = superpixels(I_channel,250,'Method','slic0','Compactness',15,'NumIterations',7);
        %         [sp_res_slic9,N_slic9] = superpixels(I_channel,250,'Method','slic0','Compactness',15,'NumIterations',9);
    else
        fprintf('===error \n')
        fprintf('\n')
        fprintf(Files(num).name)
        img_channel = I_channel;
        %         [sp_res_slic,N_slic] = superpixels(I_channel,250,'Method','slic','Compactness',15);
        [sp_res_slic0,N_slic0] = superpixels(I_channel,250,'Method','slic0','Compactness',10);
        %         [sp_res_slic1,N_slic1] = superpixels(I_channel,250,'Method','slic0','Compactness',10,'NumIterations',1);
        %         [sp_res_slic3,N_slic3] = superpixels(I_channel,250,'Method','slic0','Compactness',15,'NumIterations',3);
        %         [sp_res_slic5,N_slic5] = superpixels(I_channel,250,'Method','slic0','Compactness',15,'NumIterations',5);
        %         [sp_res_slic7,N_slic7] = superpixels(I_channel,250,'Method','slic0','Compactness',15,'NumIterations',7);
        %         [sp_res_slic9,N_slic9] = superpixels(I_channel,250,'Method','slic0','Compactness',15,'NumIterations',9);
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
    
    BW_res_slic = boundarymask(sp_res_slic);
    BW_res_slic_0 = boundarymask(sp_res_slic_0);
    BW_res_slic0 = boundarymask(sp_res_slic0);
    BW_res_slic_h = boundarymask(sp_res_slic_h);
    BW_res_slic_s = boundarymask(sp_res_slic_s);
    BW_res_slic_i = boundarymask(sp_res_slic_i);
    %     BW_res_slic7 = boundarymask(sp_res_slic7);
    %     BW_res_slic9 = boundarymask(sp_res_slic9);
    
    % BW = boundarymask(sp);
    
    
    %% write the result
    subplot(4,4,1);
    imshow(img);
    title('Source Image');
    
    subplot(4,4,2);
    imshow(H_channel);
    title('H-channel');
    
    subplot(4,4,3);
    imshow(S_channel);
    title('S-channel');
    
    subplot(4,4,4);
    imshow(I_channel);
    title('I-channel');
    
    subplot(4,4,5);
    imshow(img_channel);
    title('channel');
    
    subplot(4,4,6);
    imshow(imoverlay(img,BW_res_slic,'white'),'InitialMagnification',100);
    title('Super Segmentation slic');
    
    subplot(4,4,7);
    imshow(imoverlay(img,BW_res_slic_h,'white'),'InitialMagnification',100);
    title('H channel slic0');
    
    subplot(4,4,8);
    imshow(imoverlay(img,BW_res_slic_s,'white'),'InitialMagnification',100);
    title('S channel slic0');
    
    subplot(4,4,9);
    imshow(imoverlay(img,BW_res_slic_i,'white'),'InitialMagnification',100);
    title('I channel slic0');
%   ºÚ°×
    subplot(4,4,10);
    imshow(imoverlay(H_channel,BW_res_slic_h,'white'),'InitialMagnification',100);
    title('H channel slic0');
    
    subplot(4,4,11);
    imshow(imoverlay(S_channel,BW_res_slic_s,'white'),'InitialMagnification',100);
    title('S channel slic0');
    
    subplot(4,4,12);
    imshow(imoverlay(I_channel,BW_res_slic_i,'white'),'InitialMagnification',100);
    title('I channel slic0');
    
    subplot(4,4,13);
    plot(Xh,Yh,'r');
    title('H channel hist');
    
    subplot(4,4,14)
    plot(Xs,Ys,'r');
    title('S channel hist');
    
    subplot(4,4,15)
    demo = plot(Xi,Yi,'r');
    title('I channel hist');
    
    saveas(demo,[outputpath,Files(num).name],'jpg');
    %     subplot(4,3,7);
    %     imshow(imoverlay(img,BW_res_slic_0,'white'),'InitialMagnification',100);
    %     title('Super Segmentation slic0');
    %
    %     subplot(4,3,8);
    %     imshow(imoverlay(img_channel,BW_res_slic0,'white'usi),'InitialMagnification',100);
    %     title('Single channel slic0');
    %
    %     subplot(4,3,9);
    %     imshow(imoverlay(img,BW_res_slic0,'white'),'InitialMagnification',100);
    %     title('Single channel slic0');
    
    
    % saveas(demo,['./debug/','demo'],'jpg');
end



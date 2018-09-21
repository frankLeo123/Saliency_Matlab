% function demo_saliency(numberofsp)
clc;
close all;clear all;
addpath './MEX'
addpath './SLIC'
addpath './Filter'
k=6;

%%
inputpath = './config/demo/';
outputpath = './debug/decend/filter2/';
outputpath1 = './debug/decend/filter_slic/';
mkdir(outputpath);mkdir(outputpath1);
Files=dir([inputpath '*.jpg']);
number=length(Files);
% img = imread('horse.png');
ss = 1;
sr = 0.1;
se = 0.05;
niter = 5;



% for num=1:number
%     img =imread('./config/horse.jpg');
img =imread('./config/126.jpg');
%     img = imread([inputpath Files(num).name]);
%     img = equalhist(pic);
%% demo find min_dix
[hsi,H_channel,S_channel,I_channel]=rgb2hsi(img);
%     [H_channel, scale] = safiltering(H_channel, ss, sr, 10, se);
%     [S_channel, scale1] = safiltering(S_channel, ss, sr, 3, se);
%     [I_channel, scale2] = safiltering(I_channel, ss, sr, 1, se);
w = fspecial('gaussian',[5,5],2);
%replicate:图像大小通过赋值外边界的值来扩展
%symmetric 图像大小通过沿自身的边界进行镜像映射扩展
H_channel = imfilter(H_channel,w,'replicate');
%     imwrite(H_channel,'./debug/decend/guass.png');
[img_weigh, img_height,dim] = size(img);
split_num = 10.0;
split_num_w = floor(img_weigh / split_num);
split_num_h = floor(img_height / split_num);

slic_split = zeros(img_weigh,img_height);
slic_img_ = zeros(img_weigh,img_height);

for i= 0:split_num-1
    for j = 0:split_num-1
        din_x = i*split_num_w + 1;
        din_y = j*split_num_h + 1;
        if i == split_num-1 && j ~= split_num-1
            h_split = H_channel(din_x : img_weigh-1, din_y : din_y + split_num_h);
            s_split = S_channel(din_x : img_weigh-1, din_y : din_y + split_num_h);
            i_split = I_channel(din_x : img_weigh-1, din_y : din_y + split_num_h);
        elseif j == split_num-1 && i ~= split_num-1
            h_split = H_channel(din_x : din_x + split_num_w, din_y : img_height-1);
            s_split = S_channel(din_x : din_x + split_num_w, din_y : img_height-1);
            i_split = I_channel(din_x : din_x + split_num_w, din_y : img_height-1);
        elseif j == split_num-1 && i == split_num-1
            h_split = H_channel(din_x : img_weigh-1, din_y : img_height-1);
            s_split = S_channel(din_x : img_weigh-1, din_y : img_height-1);
            i_split = I_channel(din_x : img_weigh-1, din_y : img_height-1);
        else
            h_split = H_channel(din_x : din_x + split_num_w, din_y : din_y + split_num_h);
            s_split = S_channel(din_x : din_x + split_num_w, din_y : din_y + split_num_h);
            i_split = I_channel(din_x : din_x + split_num_w, din_y : din_y + split_num_h);
        end;
        [split_w,split_h] = size(h_split);
        decent_h = 0;
        decent_s = 0;
        decent_i = 0;
        flag =2;
        for ii = 2: split_w-1
            for jj = 2:split_h-1
                decent_h = decent_h + abs(h_split(ii,jj) - h_split(ii-1,jj-1)) + abs(h_split(ii,jj) - h_split(ii,jj-1))+abs(h_split(ii,jj) - h_split(ii+1,jj-1))...
                    + abs(h_split(ii,jj) - h_split(ii-1,jj)) + abs(h_split(ii,jj) - h_split(ii+1,jj)) + abs(h_split(ii,jj) - h_split(ii-1,jj+1))...
                    + abs(h_split(ii,jj) - h_split(ii,jj+1))+ abs(h_split(ii,jj) - h_split(ii+1,jj+1));
                decent_s = decent_s + abs(s_split(ii,jj) - s_split(ii-1,jj-1)) + abs(s_split(ii,jj) - s_split(ii,jj-1))+abs(s_split(ii,jj) - s_split(ii+1,jj-1))...
                    + abs(s_split(ii,jj) - s_split(ii-1,jj)) + abs(s_split(ii,jj) - s_split(ii+1,jj)) + abs(s_split(ii,jj) - s_split(ii-1,jj+1))...
                    + abs(s_split(ii,jj) - s_split(ii,jj+1))+ abs(s_split(ii,jj) - s_split(ii+1,jj+1));
                decent_i = decent_i + abs(i_split(ii,jj) - i_split(ii-1,jj-1)) + abs(i_split(ii,jj) - i_split(ii,jj-1))+abs(i_split(ii,jj) - i_split(ii+1,jj-1))...
                    + abs(i_split(ii,jj) - i_split(ii-1,jj)) + abs(i_split(ii,jj) - i_split(ii+1,jj)) + abs(i_split(ii,jj) - i_split(ii-1,jj+1))...
                    + abs(i_split(ii,jj) - i_split(ii,jj+1))+ abs(i_split(ii,jj) - i_split(ii+1,jj+1));
            end;
        end;
        decent_max = max(decent_h,max(decent_s,decent_i));
        num_slic_single = round(250/(split_num*split_num) );
        if decent_max == decent_h
            flag = 0;
            %             [sp_res_slic,N_slic] = superpixels(h_split,num_slic_single,'Method','slic0','Compactness',20);
        elseif decent_max == decent_s
            flag = 1;
            %             [sp_res_slic,N_slic] = superpixels(s_split,num_slic_single,'Method','slic0','Compactness',20);
        else
            flag = 2;
            %             [sp_res_slic,N_slic] = superpixels(i_split,num_slic_single,'Method','slic0','Compactness',20);
        end;
        
        %   合成slic
        for ii = 1:split_w
            for jj = 1:split_h
                %                 slic_split(din_x+ ii,din_y+jj) = sp_res_slic(ii,jj);
                if flag == 0
                    slic_img_(din_x+ ii,din_y+jj) = h_split(ii,jj);
                elseif flag == 1
                    slic_img_(din_x+ ii,din_y+jj) = s_split(ii,jj);
                else
                    slic_img_(din_x+ ii,din_y+jj) = i_split(ii,jj);
                end;
                
            end;
        end;
        % figure;
        % imshow(i_split);
        %         figure;
        % h_split = h_split*255;
        
    end;
end;
% slic_img_ = histeq(slic_img_);
[sp_res_slic0_,N_slic_] = superpixels(slic_img_,250,'Method','slic0','Compactness',17);
BW_res_slic = boundarymask(sp_res_slic0_);
%     slic_img = imoverlay(img,BW_res_slic,'white');
% slic_img1 = imoverlay(img,BW_res_slic,'white');
% imwrite(slic_img1,'./debug/decend/test.png');
% imwrite(slic_img_,'./debug/decend/test1.png');
% imwrite(H_channel,'./debug/decend/H.png');
% imwrite(S_channel,'./debug/decend/S.png');
% imwrite(I_channel,'./debug/decend/I.png');
% path_name1 = [outputpath1 Files(num).name(1:end-4) '.png'];
path_name = [outputpath Files(num).name(1:end-4) '.png'];
imwrite(slic_img_,path_name);
% imwrite(slic_img1,path_name1);


%     [sp_res_slic0,N_slic0] = superpixels(img,250,'Method','slic','Compactness',10);
%     BW_res_slic0 = boundarymask(sp_res_slic0);
%     imwrite(imoverlay(img,BW_res_slic0,'white'),'./debug/decend/test_res.png');
%     imwrite(S_channel,'./debug/decend/test_s.png');
%     imwrite(I_channel,'./debug/decend/test_i.png');
%     imwrite(H_channel,'./debug/decend/test_h.png');
%
%     [sp_res_slic0_,N_slic_] = superpixels(slic_img_,250,'Method','slic0','Compactness',17);
%     BW_res_slic0_ = boundarymask(sp_res_slic0_);
%     imwrite(imoverlay(img,BW_res_slic0_,'white'),'./debug/decend/test_res_.png');
% [Yh,Xh]=imhist(H_channel,64);
% [Ys,Xs]=imhist(S_channel,64);
% [Yi,Xi]=imhist(I_channel,64);


%% split for 4 area

% [sp_res_slic,N_slic] = superpixels(img,250,'Method','slic','Compactness',10);
% [sp_res_slic_0,N_slic_0] = superpixels(img,250,'Method','slic0','Compactness',10);

% [sp_res_slic,N_slic] = superpixels(img,250,'Method','slic','Compactness',15);


% BW_res_slic = boundarymask(sp_res_slic);
% BW_res_slic_0 = boundarymask(sp_res_slic_0);


%% write the result
%     subplot(4,4,1);
%     imshow(img);
%     title('Source Image');
%
%     subplot(4,4,2);
%     imshow(H_channel);
%     title('H-channel');
%
%     subplot(4,4,3);
%     imshow(S_channel);
%     title('S-channel');
%
%     subplot(4,4,4);
%     imshow(I_channel);
%     title('I-channel');
%
%     subplot(4,4,5);
%     imshow(img_channel);
%     title('channel');
%
%     subplot(4,4,6);
%     imshow(imoverlay(img,BW_res_slic,'white'),'InitialMagnification',100);
%     title('Super Segmentation slic');
%
%     subplot(4,4,7);
%     imshow(imoverlay(i_split,sp_res_slic,'white'),'InitialMagnification',100);
%     title('H channel slic0');
%
%     subplot(4,4,8);
%     imshow(imoverlay(img,BW_res_slic_s,'white'),'InitialMagnification',100);
%     title('S channel slic0');
%
%     subplot(4,4,9);
%     imshow(imoverlay(img,BW_res_slic_i,'white'),'InitialMagnification',100);
%     title('I channel slic0');
%     %   黑白
%     subplot(4,4,10);
%     imshow(imoverlay(H_channel,BW_res_slic_h,'white'),'InitialMagnification',100);
%     title('H channel slic0');
%
%     subplot(4,4,11);
%     imshow(imoverlay(S_channel,BW_res_slic_s,'white'),'InitialMagnification',100);
%     title('S channel slic0');
%
%     subplot(4,4,12);
%     imshow(imoverlay(I_channel,BW_res_slic_i,'white'),'InitialMagnification',100);
%     title('I channel slic0');
%
%     subplot(4,4,13);
%     plot(Xh,Yh,'r');
%     title('H channel hist');
%
%     subplot(4,4,14)
%     plot(Xs,Ys,'r');
%     title('S channel hist');
%
%     subplot(4,4,15)
%     demo = plot(Xi,Yi,'r');
%     title('I channel hist');
%
%     saveas(demo,[outputpath,Files(num).name],'jpg');

% saveas(demo,['./debug/','demo'],'jpg');
% end



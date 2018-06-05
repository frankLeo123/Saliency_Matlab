% function demo_saliency(numberofsp)
clc;
close all;clear all;
addpath './MEX'
addpath './SLIC'
% cd('D:\documents\saliency\2012_saliency_filters');    
k=6;%�ں�ʱ��Ĳ���
% pic='E:\Doc\Code\Matlab\project\Done\SaliencyFilters\leaf.bmp ';
pic = 'E:\Doc\data\images\Imgs\0_12_12816.jpg';
% pic = 'E:\Doc\data\images\Imgs\1_38_38642.jpg';
% pic = 'E:\Doc\data\images\Imgs\1_44_44224.jpg';

img2d=imread(pic);
numberofsp=50;
%0-1֮���С��
img  = im2double(imread(pic));
%����tempĿ¼�����SLIC�㷨������ͼƬ
mask_path=strcat('./temp/',pic(length(pic)-9:length(pic)-4));
mask_path=strcat(mask_path,'_');    
mask_path=strcat(mask_path,num2str(numberofsp));
mask_path=strcat(mask_path,'.mat');

%% step init hsi
[hsi,H_channel,S_channel,I_channel]=rgb2hsi(img);
[Yh,Xh]=imhist(H_channel,64);
[Ys,Xs]=imhist(S_channel,64);
[Yi,Xi]=imhist(I_channel,64);

%% demo find min_dix
[ H_result ] = selectChannel( Yh,64 );
[ S_result ] = selectChannel( Ys,64 );
[ I_result ] = selectChannel( Yi,64 );

maxChannel=max(max(H_result,S_result),I_result);
%     sp  = mexGenerateSuperPixel(img, numberofsp);  
[sp_res,N] = superpixels(img,450);

    
if(maxChannel == H_result)
    [sp,N] = superpixels(H_channel,450);
end
if(maxChannel == S_result)
    [sp,N] = superpixels(S_channel,450);
end
if(maxChannel == I_result)
    [sp,N] = superpixels(I_channel,450);
end
 BW_res = boundarymask(sp_res);
 BW = boundarymask(sp);
 
% subplot(2,2,1);
% imshow(img);
% title('Source Image');
% subplot(2,2,2);
% imshow(imoverlay(img,BW,'white'),'InitialMagnification',100);
% title('Super Segmentation');
% subplot(2,2,3);
% imshow(imoverlay(img,BW_res,'white'),'InitialMagnification',100);
% title('Before result');
% subplot(2,2,4);
% imshow(imoverlay(img,BW_res,'white'),'InitialMagnification',100);
% title('Before result');
%% step 1, oversegmentation

% sp=sp_res-1;
sp = sp - 1;
sp = double(sp);
% segToImg(sp+1);
maxsp=max(sp(:));
%�ñ��������ã���sp+1
trya=sp+1;

% the mean color of the sp
meanLabColor=zeros(maxsp+1,1,3) ;
meanImg = zeros(size(img)) ;
LabImg=RGB2Lab(img);
% imgLab=img;
for channel = 1: 3
    tempImg = LabImg(:,:,channel);
    for i=1:maxsp+1
        %trya==i�жϾ������Ƿ����=i��ֵ������Ϊ1��������Ϊ0���ھ����У�
        meanLabColor(i,1,channel)=mean( tempImg(trya==i));
    end
end
%rgb����
rgbImg = img*255;
meanrgbColor=zeros(maxsp+1,1,3) ;
for channel = 1: 3
    tempImg = rgbImg(:,:,channel);
    for i=1:maxsp+1
        meanrgbColor(i,1,channel)=mean( tempImg(trya==i));
        tempImg( trya == i) =  meanrgbColor(i,1,channel) ;
    end
    meanImg(:, :, channel) = tempImg;
end
meanImg = meanImg / 255 ;

subplot(2,2,4);
imshow(meanImg);
% meanImg=floor(meanImg);
% imshow(uint8(meanImg));
% figure;
% imshow(img);
%% step 2, element uniqueness
tic
[X, Y] = size(sp) ;
cntr=get_centers(sp+1);
%û�㶮ΪɶҪ���Թ̶�����ֵ
cntr = cntr / max( X , Y);

% U=uniqueness( cntr, labImg, 15 );
% cntr
% meanColor
U=uniqueness( cntr, meanLabColor, 0.25 );
%�����һ����Ϊ��imshow���
U=(U-min(U(:)))/(max(U(:))-min(U(:)));
tryb = sp+1;
for i=1:maxsp+1
    tryb(tryb==i)=U(i);
end
% figure;
% imshow(tryb);

%% step 3, element distrix`bution
% D = distribution( cntr, labImg , 20);
D = distribution( cntr, meanLabColor , 20);
D =(D-min(D(:)))/ (max(D(:))-min(D(:)));
% D(D<0.3)=0;
% D(D>=0.3)=1;
tryc=sp+1;
for i=1:maxsp+1
%     tryc(tryc==i)=D(i);
    tryc(tryc==i)=1-D(i);
end
% figure;
% imshow(tryc);
%% step 4, saliency assignment

% S = assignment( U, D, cntr, img ) ;
S = assignment( U,D, cntr, rgbImg, meanrgbColor, sp ,0.03,0.03,k) ;
%S = ( S-min(S(:))) / ( max(S(:)) - min(S(:))) ;

% figure;
% imshow(S);
toc
%% adaptive threshold
[height,width] = size(S) ;
thres = 2/(height*width)*sum(S(:));
thres_S = im2bw(S,thres) ;


%% write the result
% imwrite(meanImg,'leaf_my_abstract.png');
% imwrite(tryb,'leaf_my_uniqueness.png');
% imwrite(1-tryc,'leaf_my_distribution.png');
% imwrite(S,'lock_my_result.png');

%% show the result

% figure;
% subplot(4,3,1);
% imshow(img);
% title('Source Image');
% subplot(4,3,2);
% imshow(imoverlay(img,BW,'white'),'InitialMagnification',100);
% title('Super Segmentation');
% subplot(4,3,3) ;
% imshow(hsi);
% title('HSI pics');
% subplot(4,3,4);
% imshow(H_channel);
% title('H_channel');
% subplot(4,3,5);
% imshow(S_channel);
% title('S_channel');
% subplot(4,3,6);
% imshow(I_channel);
% title('I_channel');
% subplot(4,3,7);
% % [Yh,Xh]=imhist(H_channel,64);
% plot(Xh,Yh,'r');title('Hͨ��(64��λ)');
% %����ͼ
% subplot(4,3,8);
% % [Ys,Xs]=imhist(S_channel,64);
% plot(Xs,Ys,'r');title('Sͨ��(64��λ)');
% subplot(4,3,9);
% % [Yi,Xi]=imhist(I_channel,64);
% plot(Xi,Yi,'r');title('Iͨ��(64��λ)');

% figure;
subplot(2,3,1);
imshow(img);
title('Source Image');
subplot(2,3,2);
imshow(meanImg);
title('Super Segmentation');
subplot(2,3,3) ;
imshow(tryb);
title('Element Uniqueness');
subplot(2,3,4);
imshow(tryc);
title('Element Distribution');
subplot(2,3,5);
imshow(S);
title('Final Result');
subplot(2,3,6);
imshow(thres_S);
title('Threshold Result');

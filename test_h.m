clc;
close all;clear all;
addpath './MEX'
addpath './SLIC'

img = imread('./config/0_2_2304.jpg');
% inputpath = './config/Imgs/';
outputpath = './debug/';

[hsi,H_channel,S_channel,I_channel]=rgb2hsi(img);
hsv = rgb2hsv(img);
h = hsv(:,:,1);
s = hsv(:,:,2);
v = hsv(:,:,3);
% [Yh,Xh]=imhist(H_channel,64);
% [Ys,Xs]=imhist(S_channel,64);
% [Yi,Xi]=imhist(I_channel,64);
subplot(3,3,1);
imshow(img);
title('Source Image');

subplot(3,3,2);
imshow(H_channel);
title('H-channel');

subplot(3,3,3);
imshow(S_channel);
title('S-channel');

subplot(3,3,4);
imshow(I_channel);
title('I-channel');

subplot(3,3,5);
imshow(hsi);
title('hsi');

subplot(3,3,6);
imshow(hsv);
title('hsv');
subplot(3,3,7);
imshow(h);
title('hsv_h');
subplot(3,3,8);
imshow(s);
title('hsv_s');
subplot(3,3,9);
imshow(v);
title('hsv_v');
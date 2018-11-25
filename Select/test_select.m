%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明\
%
% x1 = 0.1250,x2 = 0.1875;
clear all;
pic =imread('E:\Dataset\img\testE\img\0032.jpg');

[hsi,h,s,img] = rgb2hsi(pic);
[Yi,Xi]=imhist(h,16);
[x1,x2] = selectChannel(Yi);
h = floor(h * 255);
x1 = floor(x1 * 255);
x2 = floor(x2 * 255);
span = floor(255/16)-3;
[idx1,dix1] = find(h > x1-span & h < x1 + span);
[idx2,dix2] = find(h > x2-span & h < x2 + span);
res = pic;
for ii = 1:max(size(idx1))
    res(idx1(ii),dix1(ii),:) = [255,0,0];
    % rectangle('position',[dix1(ii),idx1(ii),2,2],'Curvature',[1],'edgecolor','r');
end;
[a,b] = size(idx2);
if a~=0
    for j = 1:max(size(idx2))
        res(idx2(j),dix2(j),:) = [0,0,255];
    end;
end;
imshow(res);
plot(Xi,Yi,'r');
title('S channel hist');
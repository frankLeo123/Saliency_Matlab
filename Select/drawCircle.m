function [res] = drawCircle(meanHSI)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明\
%
%% 画区域
% res = pic;
% if leftMax<0 ||leftMin < 0
%     disp('++====error')
%     return;
% end;
% [rMax,cMax] = find(img > leftMax/16 & img < rightMax/16) ;
% [rMin,cMin] = find(img > leftMin/16 & img < rightMin/16) ;
% 
% for ii = 1:max(size(rMax))
%     res(rMax(ii),cMax(ii),:) = [255,0,0];
% end;
% [a,b] = size(rMin);
% if a~=0
%     for j = 1:max(size(rMin))
%         res(rMin(j),cMin(j),:) = [0,0,255];
%     end;
% end;

%% 矩形框
% clear all;
% pic =imread('E:\Dataset\img\testE\img\0007.jpg');
% disp('===============')
% numSlic = 100;
% compactness = 20;
% [hsi,h,s,i] = rgb2hsi(pic);
% imgSingle = SLICSingle(h,numSlic,compactness);
% img = h;
% res = img;
% [r,c] = size(img);
% center = [r/2,c/2];
% rectL = 1/5 * min(r,c);
% leftX = floor(center - rectL);
% rightX = floor(center + rectL);
% % rectangle('Position',[40,40,2,2],'edgecolor','r');
% for i = leftX(1):rightX(1)
%     for j = leftX(2):rightX(2)
%         res(leftX(1):leftX(1)+2,j) = 255; %top
%         res(i,rightX(2)-2:rightX(2)) =255; %right
%         res(rightX(1)-2:rightX(1),j) =255; %bottom
%         res(i,leftX(2):leftX(2)+2) = 255; %left
%     end;
% end;
% imshow(res);

%% rect

% name = '0007';
% numSlic = 50;
% compactness =20;
% addpath '../SLIC'
% H_channel =imread(['E:\Dataset\result\ECSSD\LAB\',name,'h.png']);
% meanHSI = SLICSingle(double(H_channel)/255,numSlic,compactness);

subplot(2,2,1)
imshow(meanHSI);
title('meanSLIC')

res = meanHSI;
img = res;
[r,c] = size(res);
center = [r/2,c/2];
rectL = 1/5 * min(r,c);
leftX = floor(center - rectL);
rightX = floor(center + rectL);

rect = res(leftX(1):rightX(1), leftX(2):rightX(2));
% rect
subplot(2,2,2)
% imshow(rect);
% title('rect center')

% idx+-3 是选取的灰度值
gap = 8 /255 * (max(max(img))-min(min(img)));
% gap = 5;
rect = im2uint8(rect);
res = im2uint8(res);
[Y,X] = imhist(rect);
[gray_num,idx]  =sort(Y,'descend');
idx = idx(1);
condition = (rect>= (idx-gap)) & (rect<= (idx+gap));
rect(find (condition)) = 255;
res(leftX(1):rightX(1), leftX(2):rightX(2)) = rect;


[initX,initY] = find(res == 255);
initx = initX(1);
inity = initY(1);
res = im2uint8(img);

for i = 1:r
    for j = 1:c
        if res(i,j) < (idx - gap) || res(i,j) > (idx+gap)
            res(i,j) =  0;
        else
            res(i,j) = 255;
        end;
    end;
end;
subplot(2,2,3)
imshow(res);    
title('连通域')
% thresh = graythresh(res)
% res = im2bw(res,thresh ); 
                       %转换为二值化图像
imLabel = bwlabel(res);                %对各连通域进行标记
stats = regionprops(imLabel,'Area');    %求各连通域的大小
area = cat(1,stats.Area);
index = find(area == max(area));        %求最大连通域的索引
img = ismember(imLabel,index); 
res = img;

subplot(2,2,4)
imshow(res);
title('最大连通域')




    
    
    
    

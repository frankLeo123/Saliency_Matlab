function [error] = GMM(img)
% function [gap,bool] = GMM(img)
% clear all;
% img = imread('E:/Project/cvpr/Saliency_Matlab/config/LAB/0007a.png') ;
% img =imread(['E:\Project\cvpr\Saliency_Matlab\config\LAB\0007s.png']);
gray_level = 256;
[datay,data]=imhist(img,gray_level);
% plot(X,Y,'b');
% hold on;
Y = datay/sum(datay);
plot(data,Y,'g');
hold on;
gap = -1;
bool = 1;
dataImg = double(img(:));
[u,sig,t,iter] = fit_mix_gaussian(dataImg,2);

if iter == 500 %√ª ’¡≤
    bool = -1;
    
else
    bool = 1;
end;
%   [u,sig,t,g,f,pp,gg]=gaussmix(datay,[],100.001,2,'kf');
sig = sig.^2;
y2 = t(2)*1/sqrt(2*pi*sig(2))*exp(-(data-u(2)).^2/2/sig(2));
% y1 = exp(y);
plot(data,y2,'b');grid on;
hold on;
y1 = t(1)*1/sqrt(2*pi*sig(1))*exp(-(data-u(1)).^2/2/sig(1));
% y1 = exp(y);
plot(data,y1,'r');legend('gray level','gmm1','gmm2');grid on;
hold on;
% figure;
% for i = 1: gray_level
%     if abs(y1(i) - y2(i)) == min(abs(y1 -y2))
%         gap = y1(i);
%     end;
% end;

Y1 = zeros(256,1);
for i = 1: gray_level
    Y1(i) = max(y1(i),y2(i));
end;
% plot(data,Y1);legend('gray level','gmm1','gmm2');grid on;

% error = sum(abs(Y-Y1));



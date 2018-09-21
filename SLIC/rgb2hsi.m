function [hsi,H,S,I] = rgb2hsi(rgb)
%  function hsi = rgb2hsi(rgb)

% 抽取图像分量
rgb = im2double(rgb);
r = rgb(:, :, 1);
g = rgb(:, :, 2);
b = rgb(:, :, 3);

% 执行转换方程
num = 0.5*((r - g) + (r - b));
den = sqrt((r - g).^2 + (r - b).*(g - b));
% theta = acos(num./(den + eps));
theta = zeros(size(r));
% theta(theta == 0) = acos(-sqrt(3.0)/2.0);
% 消除黑块
[x,y,z] = size(rgb);
for i= 1:x
    for j = 1:y
        if num(i,j) == 0
            theta(i,j) = acos(-sqrt(3.0)/2.0);
        else
            theta(i,j) = acos(num(i,j)/den(i,j)); %防止除数为0
%             fprintf ('done');
%             fprintf ('\n');
        end;
    end;
end;

H = theta;
H(b > g) = 2*pi - H(b > g);
H = H/(2*pi);

num = min(min(r, g), b);
den = r + g + b;
den(den == 0) = eps; 
% den(den == 0) = 2.0/sqrt(6); %防止除数为0
S = 1 - 3.* num./den;

% H(S == 0) = 0;

I = (r + g + b)/3;

% 将3个分量联合成为一个HSI图像
hsi = cat(3, H, S, I);
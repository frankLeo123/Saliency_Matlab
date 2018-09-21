function [ img ] = equalhist( rgb_img )
%EQUALHIST �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
r = rgb_img(:,:,1);
g = rgb_img(: , : , 2);
b = rgb_img(:, : , 3);
r_ = histeq(r);
g_ = histeq(g);
b_ = histeq(b);
img = cat(3,r_,g_,b_);



end


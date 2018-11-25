function [ meanImg ] = SLICSingle( img,num,compactness )
%SLIC �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
[sp,N_slic0] = superpixels(img,num,'Compactness',compactness);
%     sp = double(sp);
% segToImg(sp+1);
maxsp=max(sp(:));
meanhsiColor=zeros(maxsp,1) ;

trya=sp+1;
hsiImg = img*255;
for i=1:maxsp+1
    meanhsiColor(i,1)=mean( hsiImg(trya==i));
    hsiImg( trya == i) =  meanhsiColor(i,1) ;
end
meanImg = uint8(hsiImg);
% imshow(meanImg);
% figure;
% meanImg = meanImg / 255 ;

end


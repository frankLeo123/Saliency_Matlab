clear all;

inputpath = 'E:\dataset\dataset\img\testE\ECSSDLAB\';
outputpath = 'E:\dataset\dataset\img\testE\ECSSDLAB_TEST\';

Files=dir([inputpath  '*.png']);
mkdir(outputpath);
number=length(Files);
%
for num=1:number
%     num = 8;
    pic = imread([inputpath Files(num).name]);
    
    subplot(1,5,1)
    [Y,X]=imhist(pic,16);
    plot(X,Y);
    xlabel('color');
    title('16bins');
    subplot(1,5,2)
    [Y,X]=imhist(pic,32);
    plot(X,Y);
    xlabel('color');
    title('32bins');
    subplot(1,5,3)
    [Y,X]=imhist(pic,64);
    plot(X,Y);
    xlabel('color');
    title('64bins');
    subplot(1,5,4)
    [Y,X]=imhist(pic,128);
    plot(X,Y);
    xlabel('color');
    title('128bins');
    subplot(1,5,5)
    [Y,X]=imhist(pic,256);
    demo = plot(X,Y);
    xlabel('color');
    title('256bins')
    saveas(demo,[outputpath,Files(num).name(1:end-4)],'jpg');
end;
    
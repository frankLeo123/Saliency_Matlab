% img = imread('horse.png');
ss = 3;
sr = 0.1;
se = 0.05;
niter = 5;
% [res, scale] = safiltering(img, ss, sr, niter, se);

inputpath = './debug/pascal/';
outputpath = './debug/texture/';
mkdir(outputpath);
Files=dir([inputpath '*.jpg']);
number=length(Files);
for num=1:number
    pic = imread([inputpath Files(num).name]);
    [res, scale] = safiltering(pic, ss, sr, niter, se);
    path_name = [outputpath Files(num).name(1:end-4) '.png'];
    imwrite(res,path_name);
end;
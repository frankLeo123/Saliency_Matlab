function [] = DRFI(SRC,RES,srcSuffix)
addpath(genpath('G:\Project\Project\cvpr\Saliency_Matlab\config\drfi_matlab-master\'));

inputpath = SRC;
outputpath = RES;
mkdir(outputpath);
% Files=dir([inputpath  srcSuffix]);
Files = dir(fullfile(inputpath, strcat('*', srcSuffix)));
number=length(Files);
%
for num=1:number
    %     image_name = './data/1_45_45397.png';
    image = imread( [inputpath Files(num).name] );
    
    para = makeDefaultParameters;
    
    % acclerate using the parallel computing
    % matlabpool
    
    t = tic;
    smap = drfiGetSaliencyMap( image, para );
    time_cost = toc(t);
    fprintf( 'time cost for saliency computation using DRFI approach: %.3f\n', time_cost );
    
    % subplot('121');
    % imshow(image);
    % subplot('122');
    % imshow(smap);
    path_name = [outputpath [Files(num).name(1:end-4)] '.png'];
    imwrite(smap,path_name);
end;
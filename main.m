%% author mjh
% test 5 paper for matlab code
% 1 select channel
% 2 run 4 methods paper get saliency result

% This demo shows how to use Saliency Optimization[1], as well as
% Saliency Filter[2], Geodesic Saliency[3], and Manifold Ranking[4].

% [1] Wangjiang Zhu, Shuang Liang, Yichen Wei, and Jian Sun. Saliency
% Optimization from Robust Background Detection. In CVPR, 2014.

addpath './SRD'
addpath './SMD-Saliency/DEMO'
addpath './RBD'

% imgRoot='E:\Dataset\img\testE\result\singleLAB\';
% saldir='E:\Dataset\img\testE\img\SRD\';% the output path of the saliency map
input_suffix = '.jpg'

resSalPath = {'E:\Dataset\result\single2Lab\ECSSD\','E:\Dataset\result\single2Lab\MSRA1K\','E:\Dataset\result\single2Lab\PASCAL\','E:\Dataset\result\single2Lab\DUT-OMRON\'};                 % input image path                 % result path
inputImgPath = {'E:\Dataset\result\single2Lab\ECSSD\new\','E:\Dataset\result\single2Lab\MSRA1K\new\','E:\Dataset\result\single2Lab\PASCAL\new\','E:\Dataset\result\single2Lab\DUT-OMRON\new\'};
for i = 1:length(resSalPath)
    %     if ~exist(resSalPath(i), 'file')
    itemInput = char(inputImgPath(i));
    itemOutput = char(resSalPath(i));
    saldir = [itemOutput,'Newsrd\'];
    mkdir(saldir);
    %srd
    srd(itemInput,saldir,input_suffix); % input 3-channel img
    
    % smd
    smddir = [itemOutput,'Newsmd\'];
    mkdir(smddir);
    smd_function(itemInput,smddir,input_suffix);
    
    % GS & RBD
    SRC = imgRoot;
    RES = [itemOutput,'Newrbd\'];
    RES_MR = [itemOutput,'Newgs\'];
    mkdir(RES);
    mkdir(RES_MR);
    rbd(SRC,RES,RES_MR,input_suffix)
end;

%% author mjh
% test 5 paper for matlab code
% 1 select channel
% 2 run 4 methods paper get saliency result

% This demo shows how to use Saliency Optimization[1], as well as
% Saliency Filter[2], Geodesic Saliency[3], and Manifold Ranking[4].

% [1] Wangjiang Zhu, Shuang Liang, Yichen Wei, and Jian Sun. Saliency
% Optimization from Robust Background Detection. In CVPR, 2014.

% addpath './SRD'
% addpath './SMD-Saliency/DEMO'
clear all;
addpath './config/RBD'
addpath './config/drfi_matlab-master'
addpath './config/DSR'
addpath './config/bsca'
input_suffix = '.jpg'

% inputImgPath = {'E:\dataset\4test\SOD\imageSelect\'};                 % input image path
% resSalPath = {'E:\dataset\result\'};                     % result path
inputImgPath = {'F:\dataset\4test\ECSSD\select\img\','F:\dataset\4test\ECSSD\select\lab\'};                 % input image path
resSalPath = {'F:\dataset\4test\ECSSD\select\resimg\','F:\dataset\4test\ECSSD\select\reslab\'};                     % result path
sumtime = 0;
for i = 1:length(resSalPath)
    itemInput = char(inputImgPath(i));
    itemOutput = char(resSalPath(i));
    % GS & RBD
    SRC = itemInput;
    
    bscaRES = [itemOutput,'BSCA\'];
    rbdRES= [itemOutput,'RBD\'];
    drfiRES= [itemOutput,'DRFI\'];
    dsrRES= [itemOutput,'DSR1\'];
%     
    mkdir(rbdRES);
    rbd(SRC,rbdRES,input_suffix)
    
    mkdir(bscaRES);
    BSCA(SRC,bscaRES,input_suffix)

    
    mkdir(drfiRES);
    DRFI(SRC,drfiRES,input_suffix)

    mkdir(dsrRES);
%     t1 = clock;
    DSR(SRC,dsrRES,input_suffix)
%     t2 = clock;
%     time = etime(t2,t1)
%     sumtime =time + sumtime;
%     avgtime = sumtime /i 
    
end;

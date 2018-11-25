
% for test
addpath './Select/'
addpath './SLIC/'
clear all;
% inputpath = 'E:\Dataset\img\MSRA1K\';
% outputpath = 'E:\Dataset\img\testE\result\SelectLAB\';
% outputpathLAB = 'E:\Dataset\result\single2Lab\MSRA1K\new\';
% inputImgPath = {'F:\dataset\4test\SOD\images\','F:\dataset\4test\ECSSD\images\','F:\dataset\4test\HKU-IS\images\','F:\dataset\4test\PASCALS\images\','F:\dataset\4test\DUT\images\'};                 % input image path
% resSalPath = {'F:\dataset\4test\SOD\LAB\','F:\dataset\4test\ECSSD\LAB\','F:\dataset\4test\HKU-IS\LAB\','F:\dataset\4test\PASCALS\LAB\','F:\dataset\4test\DUT\LAB\'};                     % result path
inputImgPath = {'F:\dataset\4test\SOD\images\'};                 % input image path
resSalPath = {'F:\dataset\4test\SOD\images\'};                     % result path

for i = 1:length(resSalPath)
    %     if ~exist(resSalPath(i), 'file')
    disp(resSalPath(i));
    itemInput = char(inputImgPath(i));
    itemOutput = char(resSalPath(i))
    mkdir(itemOutput);
    %%
    
    % mkdir(outputpathLAB);
    Files=dir([itemInput  '*.jpg']);
    % FilesHSI = dir([inputpathHSI '*.png']);
    % FilesRBD = dir([inputpathRBD '*.png']);
    number=length(Files);
    % 统计channel 数目
    selectChannelNum = zeros(6,1);
    %
    for num=1:number
        % pic =imread('./config/Imgs/-3_0_735.jpg');
        %         num = 14;
        %     img =imread([inputpath Files(num).name]);
        disp(i + '-' + num);
        %         num = 6;
        img = imread([itemInput Files(num).name]);
        %% demo find min_dix
        [hsi,H_channel,S_channel,I_channel]=rgb2hsi(img);
        lab = rgb2lab(img);
        
        for jj =1:3
            max_ = max(max(lab(:,:,jj)));
            min_ = min(min(lab(:,:,jj)));
            lab(:,:,jj) = (lab(:,:,jj)-min_) / (max_ - min_);
        end;
        L_channel = lab(:,:,1);
        A_channel = lab(:,:,2);
        B_channel = lab(:,:,3);
        
        areaMax = zeros(1,6);areaMin = zeros(1,6);
        dist = zeros(1,6);gapNum = zeros(1,6);
        x1 = zeros(1,6);x2 = zeros(1,6);
        label = 3;
        [r,c] = size(H_channel);
        
        [x1(1),x2(1),gapNum(1),areaMax(1),areaMin(1),dist(1)] = calcArea(H_channel);
        [x1(2),x2(2),gapNum(2),areaMax(2),areaMin(2),dist(2)] = calcArea(S_channel);
        [x1(3),x2(3),gapNum(3),areaMax(3),areaMin(3),dist(3)] = calcArea(I_channel);
        [x1(4),x2(4),gapNum(4),areaMax(4),areaMin(4),dist(4)] = calcArea(L_channel);
        [x1(5),x2(5),gapNum(5),areaMax(5),areaMin(5),dist(5)] = calcArea(A_channel);
        [x1(6),x2(6),gapNum(6),areaMax(6),areaMin(6),dist(6)] = calcArea(B_channel);
        dis = areaMin./areaMax;
        %% max regionprops
        
        num_ = zeros(1,6);
        for ii = 1:6
            if dis(ii) < 0.04 || dis(ii) > 25
                continue;
            elseif gapNum(ii)== -1
                continue;
            elseif x1(ii)<0.5 && x2(ii) <0.5
                continue;
            else
                num_(ii) = (areaMax(ii) + areaMin(ii)) / gapNum(ii);
            end;
        end;
        
        if max(num_) == 0 || max(num_) == num_(3)
            label =3;
        elseif max(num_) == num_(1)
            label = 1;
        elseif max(num_) == num_(2)
            label = 2;
        elseif max(num_) == num_(4)
            label = 4;
        elseif max(num_) == num_(5)
            label = 5;
        else
            label = 6;
        end;
        %% new
        
        if label == 1
            [num2,num2Idx] = sort(num_,'descend');
            if num2(2) == 0 || num2(2) == num_(3)
                label =3;
                selectChannelNum(3) = selectChannelNum(3)+1;
            elseif num2(2) == num_(2)
                label = 2;
                selectChannelNum(2) = selectChannelNum(2)+1;
            elseif num2(2) == num_(4)
                label = 4;
                selectChannelNum(4) = selectChannelNum(4)+1;
            elseif num2(2) == num_(5)
                label = 5;
                selectChannelNum(5) = selectChannelNum(5)+1;
            else
                label = 6;
                selectChannelNum(6) = selectChannelNum(6)+1;
            end;
        end;
        %         Channel = H_channel;
        if label == 2
            selectChannelNum(2) = selectChannelNum(2)+1;
            Channel = S_channel;
        elseif label == 4
            selectChannelNum(4) = selectChannelNum(4)+1;
            Channel = L_channel;
        elseif label == 5
            selectChannelNum(5) = selectChannelNum(5)+1;
            Channel  = A_channel;
        elseif label == 6
            selectChannelNum(6) = selectChannelNum(6)+1;
            Channel = B_channel;
        else
            selectChannelNum(3) = selectChannelNum(3)+1;
            Channel = I_channel;
        end;
        
        % %         save 1to3
        pic = Channel;
        [x,y,z] = size(pic);
        res = zeros(x,y,3);
        if z == 1
            disp('single error')
            res(:,:,1) =pic;
            res(:,:,2) =pic;
            res(:,:,3) =pic;
%             res = double(res/255);
        else
            res = pic;
        end;
%         path_name = [outputpathHSI Files(num).name(1:end-4) '.jpg'];
%         imwrite(res,path_name);
        
        path_name = [itemOutput Files(num).name(1:end-4) '.jpg'];
        imwrite(res,path_name);
        %         imshow(Channel);
    end;
end;
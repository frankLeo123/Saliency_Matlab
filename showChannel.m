% function [Channel,label] = selectChannel(H_channel,S_channel,I_channel,L_channel,A_channel,B_channel)
% for test

clear all;
name = '0007';
addpath './Select/'
addpath './SLIC/'
inputpath = '.\config\testError\';
outputpath = '.\debug\testError\';

%%

% mkdir(outputpathLAB);
mkdir(outputpath);
Files=dir([inputpath  '*.jpg']);
selectChannelNum = zeros(6,1);
number=length(Files);
%
for num=1:number
    % pic =imread('./config/Imgs/-3_0_735.jpg');
    %     num = 21;
    pic =imread([inputpath Files(num).name]);
    img = im2double(pic);
    [hsi,H_channel,S_channel,I_channel]=rgb2hsi(img);
    lab = rgb2lab(img);
    for i =1:3
        max_ = max(max(lab(:,:,i)));
        min_ = min(min(lab(:,:,i)));
        lab(:,:,i) = (lab(:,:,i) - min_)/(max_-min_);
    end;
    L_channel = lab(:,:,1);
    A_channel = lab(:,:,2);
    B_channel = lab(:,:,3);
    H_channel = uint8(H_channel*255);
    S_channel = uint8(S_channel*255);
    I_channel = uint8(I_channel*255);
    L_channel = uint8(L_channel*255);
    A_channel = uint8(A_channel*255);
    B_channel = uint8(B_channel*255);
    %     resH =imread([inputpathRBD FilesRBD(6 *num -5).name(1:end-5) 'h.png']);
    %     resS =imread([inputpathRBD FilesRBD(6 *num -4).name(1:end-5) 's.png']);
    %     resI =imread([inputpathRBD FilesRBD(6 *num -3).name(1:end-5) 'i.png']);
    %     resL =imread([inputpathRBD FilesRBD(6 *num -2).name(1:end-5) 'l.png']);
    %     resA =imread([inputpathRBD FilesRBD(6 *num -1).name(1:end-5) 'a.png']);
    %     resB =imread([inputpathRBD FilesRBD(6 *num -5).name(1:end-5) 'b.png']);
    
    %% slic
    %     numSlic = 50;
    %     compactness =20;
    %     meanH = SLICSingle(double(H_channel)/255,numSlic,compactness);
    %     meanS = SLICSingle(double(S_channel)/255,numSlic,compactness);
    %     meanI = SLICSingle(double(I_channel)/255,numSlic,compactness);
    %     meanL = SLICSingle(double(L_channel)/255,numSlic,compactness);
    %     meanA = SLICSingle(double(A_channel)/255,numSlic,compactness);
    %     meanB = SLICSingle(double(B_channel)/255,numSlic,compactness);
    % res = drawCircle(meanH);
    % imshow(res);
    
    areaMax = zeros(1,6);areaMin = zeros(1,6);
    dist = zeros(1,6);gapNum = zeros(1,6);
    x1 = zeros(1,6);x2 = zeros(1,6);
    label = 3;
    [r,c] = size(H_channel);
    % diff = zeros(1,3);
    % [leftMax,rightMax,leftMin,rightMin] = calcArea( meanH );
    [x1(1),x2(1),gapNum(1),areaMax(1),areaMin(1),dist(1)] = calcArea(H_channel);
    [x1(2),x2(2),gapNum(2),areaMax(2),areaMin(2),dist(2)] = calcArea(S_channel);
    [x1(3),x2(3),gapNum(3),areaMax(3),areaMin(3),dist(3)] = calcArea(I_channel);
    [x1(4),x2(4),gapNum(4),areaMax(4),areaMin(4),dist(4)] = calcArea(L_channel);
    [x1(5),x2(5),gapNum(5),areaMax(5),areaMin(5),dist(5)] = calcArea(A_channel);
    [x1(6),x2(6),gapNum(6),areaMax(6),areaMin(6),dist(6)] = calcArea(B_channel);
    dis = areaMin./areaMax;
    %% max regionprops
    %     areaHSI = zeros(r,c,6);
    %     sumArea = sum(sum(ones(r,c)));
    %     areaHSI(:,:,1) = drawCircle(meanH);
    %     areaHSI(:,:,2) = drawCircle(meanS);
    %     areaHSI(:,:,3) = drawCircle(meanI);
    %     areaHSI(:,:,4) = drawCircle(meanL);
    %     areaHSI(:,:,5) = drawCircle(meanA);
    %     areaHSI(:,:,6) = drawCircle(meanB);
    %
    %     dis(isnan(dis)) = 0;
    %     j =1;
    %
    %     num_ = zeros(1,6);
    %     for i = 1:6
    %         if dis(i)<0.04
    %             continue;
    %         elseif dist(i) <= 4 && dis(i) > 0.75
    %             continue;
    %         else
    %             num_(i) = sum(sum(areaHSI(:,:,i)/255));
    %             if num_(i) > sumArea *0.4 || num_(i) < sumArea * 0.04
    %                 %             num(i) = 0;
    %             end;
    %         end;
    %     end;
    %
    %     if max(num_) == 0 || max(num_) == num_(3)
    %         label =3;
    %     elseif max(num_) == num_(1)
    %         label = 1;
    %     elseif max(num_) == num_(2)
    %         label = 2;
    %     elseif max(num_) == num_(4)
    %         label = 4;
    %     elseif max(num_) == num_(5)
    %         label = 5;
    %     else
    %         label = 6;
    %     end;
    
    num_ = zeros(1,6);
    for i = 1:6
        if dis(i) < 0.04 || dis(i) > 25
            continue;
        elseif gapNum(i)== -1
            continue;
        elseif x1(i)<0.5 && x2(i) <0.5
            continue;
        else
            num_(i) = (areaMax(i) + areaMin(i)) / gapNum(i);
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
    %     gap = zeros(1,6);
    %     bool = zeros(1,6);
    % %     [gap(1),bool(1)] = GMM(H_channel);
    %     [gap(1),bool(1)] = GMM(H_channel);
    %     [gap(2),bool(2)] = GMM(S_channel);
    %     [gap(3),bool(3)] = GMM(I_channel);
    %     [gap(4),bool(4)] = GMM(L_channel);
    %     [gap(5),bool(5)] = GMM(A_channel);
    %     [gap(6),bool(6)] = GMM(B_channel);
    %
    %     for i = 1:6
    %         if gap(i) == min(gap(gap >= 0))
    %             label = i;
    %         end;
    %     end;
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
        Channel = A_channel;
    elseif label == 6
        selectChannelNum(6) = selectChannelNum(6)+1;
        Channel = B_channel;
    else
        selectChannelNum(3) = selectChannelNum(3)+1;
        Channel = I_channel;
    end;
    %     path_name = [outputpathLAB Files(num).name(1:end-4) '.png'];
    %     imwrite(Channel,path_name);
    % imshow(Channel);
    %% draw
    subplot(3,7,1)
    imshow(img);
    title('img');
    
    subplot(3,7,2)
    imshow(H_channel);
    title('h_channel');
    subplot(3,7,3)
    imshow(S_channel);
    title('S_channel');
    subplot(3,7,4)
    imshow(I_channel);
    title('I_channel');
    subplot(3,7,5)
    imshow(L_channel);
    title('L_channel');
    subplot(3,7,6)
    imshow(A_channel);
    title('A_channel');
    subplot(3,7,7)
    imshow(B_channel);
    title('B_channel');
    
    subplot(3,7,8)
    imshow(Channel);
    title('select_channel');
    
    subplot(3,7,9)
    [Y,X]=imhist(H_channel,16);
    plot(X,Y);
    title('H_channel');
    subplot(3,7,10)
    [Y,X]=imhist(S_channel,16);
    plot(X,Y);
    title('S_channel');
    subplot(3,7,11)
    [Y,X]=imhist(I_channel,16);
    plot(X,Y);
    title('I_channel');
    subplot(3,7,12)
    [Y,X]=imhist(L_channel,16);
    plot(X,Y);
    title('L_channel');
    subplot(3,7,13)
    [Y,X]=imhist(A_channel,16);
    plot(X,Y);
    title('A_channel');
    subplot(3,7,14)
    [Y,X]=imhist(B_channel,16);
    demo = plot(X,Y);
    title('B_channel');
    
    saveas(demo,[outputpath,Files(num).name(1:end-4)],'jpg');
end;







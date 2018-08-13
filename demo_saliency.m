% function demo_saliency(numberofsp)
clc;
close all;clear all;
addpath './MEX'
addpath './SLIC'

k=16;numberofsp=50;
%% patch pics
inputpath = './config/Imgs/';
outputpath = './debug/new/';
Files=dir([inputpath '*.jpg']);
number=length(Files);

for num=1:number
    pic = imread([inputpath Files(num).name]);
    img  = im2double(pic);
    %% single
    %     pic ='./config/1_45_45784.jpg';
    %     img2d = imread(pic);
    %
    %     %0-1
    %     img  = im2double(img2d);
    %% step init hsi
    [hsi,H_channel,S_channel,I_channel]=rgb2hsi(img);
    [Yh,Xh]=imhist(H_channel,64);
    [Ys,Xs]=imhist(S_channel,64);
    [Yi,Xi]=imhist(I_channel,64);
    
    %% demo find min_dix
    left = 64* 0.25;
    right = 64 * 0.75;
    [ H_result ] = selectChannel( Yh,64,left,right);
    [ S_result ] = selectChannel( Ys,64,left,right );
    [ I_result ] = selectChannel( Yi,64,left,right );
    a = 1;b = 2; c =3;
    d = max(max(a,b),c);
    maxChannel = max(max(H_result,S_result),I_result);
    % sp  = mexGenerateSupe;rPixel(img, numberofsp);
    [sp_res_slic0,N_slic0] = superpixels(img,250,'Method','slic0','Compactness',15);

    outputImage_slic0 = zeros(size(img),'like',img);
    %slic0
    idx = label2idx(sp_res_slic0);
    numRows = size(img,1);
    numCols = size(img,2);
    for labelVal = 1:N_slic0
        redIdx = idx{labelVal};
        greenIdx = idx{labelVal}+numRows*numCols;
        blueIdx = idx{labelVal}+2*numRows*numCols;
        outputImage_slic0(redIdx) = mean(img(redIdx));
        outputImage_slic0(greenIdx) = mean(img(greenIdx));
        outputImage_slic0(blueIdx) = mean(img(blueIdx));
    end
    
    if(maxChannel == H_result)
        [sp,N] = superpixels(H_channel,450,'Method','slic0','Compactness',15);
    end
    if(maxChannel == S_result)
        [sp,N] = superpixels(S_channel,450,'Method','slic0','Compactness',15);
    end
    if(maxChannel == I_result)
        [sp,N] = superpixels(I_channel,450,'Method','slic0','Compactness',15);
    end
%     BW_res_slic = boundarymask(sp_res_slic);
    BW_res_slic0 = boundarymask(sp_res_slic0);
    
    % BW = boundarymask(sp);
    
    
    %% step 1, oversegmentation
    
    % sp=sp_res-1;
    sp = sp - 1;
    sp = double(sp);
    % segToImg(sp+1);
    maxsp=max(sp(:));
    %�ñ��������ã���sp+1
    trya=sp+1;
    
    % the mean color of the sp
    meanLabColor=zeros(maxsp+1,1,3) ;
    meanImg = zeros(size(img)) ;
    LabImg=RGB2Lab(img);
    % imgLab=img;
    for channel = 1: 3
        tempImg = LabImg(:,:,channel);
        for i=1:maxsp+1
            %trya==i �жϾ������Ƿ����?i��ֵ������Ϊ1��������Ϊ0���ھ����У�
            meanLabColor(i,1,channel)=mean( tempImg(trya==i));
        end
    end
    %rgb����
    rgbImg = img*255;
    meanrgbColor=zeros(maxsp+1,1,3) ;
    for channel = 1: 3
        tempImg = rgbImg(:,:,channel);
        for i=1:maxsp+1
            meanrgbColor(i,1,channel)=mean( tempImg(trya==i));
            tempImg( trya == i) =  meanrgbColor(i,1,channel) ;
        end
        meanImg(:, :, channel) = tempImg;
    end
    meanImg = meanImg / 255 ;
    
    subplot(2,2,4);
    imshow(meanImg);
    % meanImg=floor(meanImg);
    % imshow(uint8(meanImg));
    % figure;
    % imshow(img);
    %% step 2, element uniqueness
    tic
    [X, Y] = size(sp) ;
    cntr=get_centers(sp+1);
    %û�㶮ΪɶҪ���Թ̶�����ֵ
    cntr = cntr / max( X , Y);
    
    % U=uniqueness( cntr, labImg, 15 );
    % cntr
    % meanColor
    U=uniqueness( cntr, meanrgbColor, 0.25 );
    %�����һ����Ϊ��imshow���?
    U=(U-min(U(:)))/(max(U(:))-min(U(:)));
    tryb = sp+1;
    for i=1:maxsp+1
        tryb(tryb==i)=U(i);
    end
    % figure;
    % imshow(tryb);
    
    %% step 3, element distrix`bution
    % D = distribution( cntr, labImg , 20);
    D = distribution( cntr, meanrgbColor , 20);
    D =(D-min(D(:)))/ (max(D(:))-min(D(:)));
    % D(D<0.3)=0;
    % D(D>=0.3)=1;
    tryc=sp+1;
    for i=1:maxsp+1
        %     tryc(tryc==i)=D(i);
        tryc(tryc==i)=1-D(i);
    end
    
    %% step 4, saliency assignment
    
    % S = assignment( U, D, cntr, img ) ;
    S = assignment( U,D, cntr, rgbImg, meanrgbColor, sp ,0.03,0.03,k) ;
    %S = ( S-min(S(:))) / ( max(S(:)) - min(S(:))) ;
    
    toc
    %% adaptive threshold
    [height,width] = size(S) ;
    thres = 2/(height*width)*sum(S(:));
    thres_S = im2bw(S,thres) ;
    
    
    %% write the resule
    
    subplot(4,3,1);
    imshow(img);
    title('Source Image');
    subplot(4,3,2);
    imshow(meanImg);
    title('Super Segmentation');
    subplot(4,3,3) ;
    imshow(tryb);
    title('Element Uniqueness');
    subplot(4,3,4);
    imshow(tryc);
    title('Element Distribution');
    subplot(4,3,5);
    imshow(S);
    title('Final Result');
    subplot(4,3,6);
    imshow(thres_S);
    title('Threshold Result');
    % some result
    subplot(4,3,7);
    imshow(H_channel);
    title('H_channel');
    subplot(4,3,8);
    imshow(S_channel);
    title('S_channel');
    subplot(4,3,9);
    imshow(I_channel);
    title('I_channel');
    % demo = imshow(thres_S);
    % imshow(thres_S);
    subplot(4,3,10);
    [Yh,Xh]=imhist(H_channel,64);
    plot(Xh,Yh,'r');
    if maxChannel == H_result
        
        % demo = imshow(H_channel);
        title('H_channel Result');
    end;
    
    subplot(4,3,11);
    [Yh,Xh]=imhist(S_channel,64);
    plot(Xh,Yh,'r');
    
    if maxChannel == S_result
        
        % demo = imshow(S_result);
        title('S_channel Result');
    end;
    
    subplot(4,3,12);
    [Yh,Xh]=imhist(I_channel,64);
    demo = plot(Xh,Yh,'r');
    
    if maxChannel == I_result
        % demo = imshow(I_result);
        title('I_channel Result');
    end;
    %     saveas(demo,'./debug/demo','jpg');
    saveas(demo,[outputpath,Files(num).name],'jpg');
end;


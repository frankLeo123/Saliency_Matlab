function demo

clear all;
clc;
addpath('./others/');
%%------------------------set parameters---------------------%%
global imgRoot;
global saldir;
global supdir;
global imnames;
spnumber = 200;% superpixel number
theta = 10; % control the edge weight
cenNum = 36;
alpha = 0.99;
options = zeros(1,5);
options(1) = 1; % display
options(2) = 1;
sumtime = 0;
options(3) = 0.00002; % precision
options(4) = 200; % maximum number of iterations
% imgRoot='./test/';% test image path
% imgRoot='E:\Dataset\result\single2Lab\MSRA1K\LAB3\'
imgRoot='E:\dataset\dataset\img\ECSSD/'
saldir='E:\dataset\result\SRD\';% the output path of the saliency map
supdir='./superpixels/';% the superpixel label file path
mkdir(supdir);
mkdir(saldir);
imnames=dir([imgRoot '*' '.jpg']);

for ii=1:length(imnames)   
    disp(ii);
    imname = [imgRoot imnames(ii).name]; 
    t1 = clock;
    [input_im, w]=removeframe_(imname);% run a pre-processing to remove the image frame 
    
    [m,n,k] = size(input_im);    
    input_vals=reshape(input_im, m*n, k);
    clear k

    %% ---------------------- generate superpixels Layer 1 ---------------------%%
    imname=[imname(1:end-4) '.bmp'];
    comm=['SLICSuperpixelSegmentation' ' ' imname ' ' int2str(20) ' ' int2str(spnumber) ' ' supdir];
    system(comm);    
    spname=[supdir imnames(ii).name(1:end-4)  '.dat'];
    superpixels=ReadDAT([m,n],spname); % superpixel label matrix
    spnum=max(superpixels(:));% the actual superpixel number
    [adjc bord] = calAdjacentMatrix(superpixels,spnum);
    clear comm spname
    
    % compute the feature (mean color in lab color space) for each superpixels    
    rgb_vals = zeros(spnum,3);
    inds=cell(spnum,1);
    [x, y] = meshgrid(1:1:n, 1:1:m);
    x_vals = zeros(spnum,1);
    y_vals = zeros(spnum,1);
    num_vals = zeros(spnum,1);
    for i=1:spnum
        inds{i}=find(superpixels==i);
        num_vals(i) = length(inds{i});
        rgb_vals(i,:) = mean(input_vals(inds{i},:),1);
        x_vals(i) = sum(x(inds{i}))/num_vals(i);
        y_vals(i) = sum(y(inds{i}))/num_vals(i);
    end  
    seg_vals = colorspace('Lab<-', rgb_vals);
    clear i x y input_vals rgb_vals
    
    % k-meams
    labCen = zl_kmeans(cenNum, seg_vals, options);
    
    disSupCen = normalize( DistanceZL(seg_vals, labCen, 'euclid'), 'column' );
    simSupCen = exp( -theta*disSupCen );
    clear disSupCen labCen
    
    W_lab = normalize( DistanceZL(seg_vals, seg_vals, 'euclid') ); % euclid
    sal_lab = exp( -theta*W_lab );
    
    % Ranking
    spGraph = calSparseGraph( sal_lab, adjc, bord, spnum );
    W = sal_lab.*spGraph;
    dd = sum(W,2); D = sparse(1:spnum,1:spnum,dd);
    
    P = (D-alpha*W)\eye(spnum); 
    Sal = P*simSupCen;
    Sal = normalize( Sal' );
    clear W dd D
    
    weight = calPostprocessingWeight(sal_lab,adjc,spnum);
    
    salSup = Sal.*(ones(cenNum,1)*num_vals');
    Isum = sum(salSup,2);
    
    comVal = calfgDistributionSal(salSup,Isum,x_vals,y_vals,weight,m,n,spnum,cenNum);
    clear salSup Isum
    
    [~, index] = max(simSupCen,[],2);
    bgIndex = unique([superpixels(1,:),superpixels(m,:),superpixels(:,1)',superpixels(:,n)']);
    bgCenInd = unique(index(bgIndex));
    
    bgComInd = find(comVal == 0);
    fgComInd = find(comVal ~= 0);
    bgInd = unique([bgCenInd;bgComInd]);
    bgInd = setdiff( bgInd,fgComInd );
    
    simSupCen = simSupCen';
    bgSal = 1-normalize(simSupCen(bgInd(1),:));
    for i = 2:length(bgInd)
        bgSal = bgSal.*( 1-normalize(simSupCen(bgInd(i),:)) );
    end
    bgSal = normalize(bgSal);
    bgSal = normalize(P*bgSal');
    
    fgSal = normalize( sum(comVal*ones(1,spnum).*simSupCen,1) );
    fgSal = normalize(P*fgSal');
    fgSal = normalize( sum(weight.*padarray(fgSal',[spnum-1 0],'replicate','post'),2) );
    clear P index bgIndex bgCenInd bgComInd fgComInd bgInd simSupCen
    
    finSal = normalize( 0.6*fgSal + 0.4*bgSal);
    clear superpixels weight W_lab sal_lab Sal simSupCen comVal fgSal bgSal
    
    salall = zeros(m,n);
    for k = 1:spnum
        salall(inds{k}) = finSal(k);
    end
    clear k x_vals y_vals adjc finSal
    clear num_vals seg_vals spnum inds
    
    mapstage1=zeros(w(1),w(2));
    mapstage1(w(3):w(4),w(5):w(6))=salall;
    mapstage1=uint8(mapstage1*255);
    
    t2 = clock;
    time = etime(t2,t1)
    sumtime =time + sumtime;
    avgtime = sumtime /ii
    
    outname=[saldir imnames(ii).name(1:end-4) '.jpg'];
    imwrite(mapstage1,outname);
    
    clear mapstage1 outname w salall m n
end

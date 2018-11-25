% Demo for paper "Saliency Detection via Cellular Automata" 
% by Yao Qin, Huchuan Lu, Yiqun Xu and He Wang
% To appear in Proceedings of IEEE Conference on Computer Vision and Pattern Recognition (CVPR 2015), Boston, June, 2015.

clc;
clear all;
close all;
addpath('./others/');
%%--------------------------set parameters---------------------------%%
% SLIC algorithm parameters
spnumber_bg=300;  % the number of superpixels 
compactness_bg=30;
spnumber=300;      
compactness=20;
% parameters in GCD and GSD Matrix
sigma_1 =0.2; % control the weight of color distinction 
sigma_2 =1.3; %control the weight of geodesic distance
beta=10;      
% Single-layer Cellular Automata parameters
theta = 10;  % control the strength of similarity between neighbors
a=0.6;
b=0.2;     % a and b control the strength of coherence

%%-------------------------Read an input image-----------------------%%                          
imgRoot = './img/';% test image path
saldir = './saliencymap_BSCA/';% the output path of the saliency map
mkdir(saldir);
supdir='./superpixels/';% the superpixel label file path
mkdir(supdir);
imnames = dir([ imgRoot '*' 'jpg']);
for ii = 1:length(imnames)
    disp(ii);  
    imName = [ imgRoot imnames(ii).name ];  
    [input_im,w]=removeframe(imName);% run a pre-processing to remove the image frame               
    input_imlab = RGB2Lab(input_im);
    [m,n,r]=size(input_im);
    
    %%------------------------generate superpixels----------------------%%
    outname=[imgRoot imnames(ii).name(1:end-4) '.bmp'];% the slic software support only the '.bmp' image   
    comm=['SLICSuperpixelSegmentation' ' ' outname ' '...
          int2str(compactness_bg) ' ' int2str(spnumber_bg) ' ' supdir];
    system(comm); 
    spname=[supdir imnames(ii).name(1:end-4)  '.dat'];
    sulabel_bg=ReadDAT([m,n],spname); % superpixel label matrix
    supNum_bg = max(sulabel_bg(:));% the actual superpixel number
    regions_bg = calculateRegionProps(supNum_bg,sulabel_bg);                    
    
    %%-----------------Global Distance Matrix Integration---------------%%
    % Extract LAB features of all superpixels 
    [sp_feature_bg] = extractSupfeat(input_imlab,regions_bg,supNum_bg);                                                                                                    
    boundsp_bg = extract_bg_sp(sulabel_bg,m,n); % label the boundary superpixels
    boundsp_feat_bg = sp_feature_bg(boundsp_bg,:); % Extract the LAB features of the boundary superpixels
    boundsp_num_bg = length(boundsp_bg);
                       
   %  K-means Algorithm 
    paramPropagate.nclus = 3;    %the number of boundary clusters
    paramPropagate.maxIter=200;
    centers_bg = form_codebook(boundsp_feat_bg(:,1:3)',...
                 paramPropagate.nclus,paramPropagate.maxIter);
    [ featLabel_bg ] = labelCluster( centers_bg, ...
                 boundsp_feat_bg(:,1:3)', boundsp_num_bg, paramPropagate.nclus );
    
    clus_num=numel(unique(featLabel_bg));
    maxlabel=max(featLabel_bg);
    if (clus_num~= paramPropagate.nclus)
        if clus_num == maxlabel 
            paramPropagate.nclus = clus_num;
        else
            paramPropagate.nclus = clus_num;
            centers_bg = form_codebook(boundsp_feat_bg(:,1:3)',...
                         paramPropagate.nclus,paramPropagate.maxIter);
            [ featLabel_bg ] = labelCluster( centers_bg, ...
                boundsp_feat_bg(:,1:3)', boundsp_num_bg, paramPropagate.nclus );
        end
    end
    
    % get the labels of boundary superpixels in each cluster
    bound_clus=cell(1,paramPropagate.nclus);   
    for i=1:length(boundsp_bg)    
      bound_clus{featLabel_bg(i)}=[bound_clus{featLabel_bg(i)},boundsp_bg(i)];  
    end
    
    % get the LAB features of boundary superpixels in each cluster
    clustsp_feature=cell(1,paramPropagate.nclus);
    for i=1:paramPropagate.nclus   
        for j=1:length(bound_clus{i})
            clustsp_feature{i}=[clustsp_feature{i},sp_feature_bg(bound_clus{i}(j),:)'];
        end
    end
  
    % compute the location information of superpixels in each cluster
    weight_bg = cell(1,paramPropagate.nclus);
    for j = 1:paramPropagate.nclus
        weight_bg{j} = zeros(numel(bound_clus{j}), 2);  
       for k = 1:numel(bound_clus{j})
           weight_bg{j}(k, 1) = sum(regions_bg{bound_clus{j}(k)}.pixelIndxy(:, 1))...
                            /size(regions_bg{bound_clus{j}(k)}.pixelIndxy, 1);
           weight_bg{j}(k, 2) = sum(regions_bg{bound_clus{j}(k)}.pixelIndxy(:, 2))...
                            /size(regions_bg{bound_clus{j}(k)}.pixelIndxy, 1);            
       end
    end
    weight_bg = normalization(weight_bg, 1);
    
    %%------------------------generate superpixels----------------------%%    
    comm=['SLICSuperpixelSegmentation' ' ' outname ' '...
          int2str(compactness) ' ' int2str(spnumber) ' ' supdir];
    system(comm); 
    spname=[supdir imnames(ii).name(1:end-4)  '.dat'];
    sulabel=ReadDAT([m,n],spname); % superpixel label matrix
    supNum = max(sulabel(:));% the actual superpixel number
    regions = calculateRegionProps(supNum,sulabel);  
    
    % extract LAB features of all superpixels 
    [sp_feature] = extractSupfeat(input_imlab,regions,supNum);                                                                                                    
    boundsp = extract_bg_sp(sulabel,m,n); % label the boundary superpixels
  
    % compute the location information of all superpixels
    weight = zeros(supNum, 2);  
    for k = 1:supNum
        weight(k, 1) = sum(regions{k}.pixelIndxy(:, 1))...
                            /size(regions{k}.pixelIndxy, 1);
        weight(k, 2) = sum(regions{k}.pixelIndxy(:, 2))...
                            /size(regions{k}.pixelIndxy, 1);            
    end
    weight = normalization(weight, 0);
    
    % compute GCD maps
    K_cluster = paramPropagate.nclus;
    s_ave=cell(1,K_cluster);
    for k=1:K_cluster
    s_ave{k}=zeros(1,supNum);
        for i=1:supNum
            for j=1:length(bound_clus{k})
                sum_c=0;               
                for l=1:3
                    col_dis=power((sp_feature(i,l)-clustsp_feature{k}(l,j)),2);
                    sum_c=sum_c + col_dis;   
                end  
                s_ave{k}(i)=s_ave{k}(i)+1/((exp(-(sqrt(sum_c)/(2*sigma_1*sigma_1))))+beta);           
            end
            s_ave{k}(i)=s_ave{k}(i)/length(bound_clus{k});
        end
    end 
    s_ave=normalization(s_ave,1);
         
    % compute GSD maps
    w_ave=cell(1,K_cluster);
    for i = 1:K_cluster
        w_ave{i} = zeros(1, supNum);
        for j = 1:supNum
            row = size(weight_bg{i}, 1);
            temp = weight_bg{i} - repmat(weight(j,:), row, 1);
            sum_val = temp(:, 1).^2 + temp(:, 2).^2 ;
            w_ave{i}(j) = sum( exp(- sum_val ./(2*sigma_2*sigma_2)))/numel(sum_val);
        end
    end
    
    % integrate global distance matrices to get the background-based map    
    S_bg=zeros(1,supNum);
    for i=1:supNum
        sum_ws=0;
        for k=1:paramPropagate.nclus
            sum_ws=sum_ws+w_ave{k}(i)*s_ave{k}(i);            
        end 
        S_bg(i)=sum_ws;
    end   
    S_bg=normalization(S_bg,0);
   
    %%-----------------Single-layer Cellular Automata---------------%%
    % compute the feature (mean color in lab color space) 
    % for each superpixel
    input_vals=reshape(input_im, m*n, r);
    rgb_vals=zeros(supNum,1,3);
    inds=cell(supNum,1);
    for i=1:supNum
        inds{i}=find(sulabel==i);
        rgb_vals(i,1,:)=mean(input_vals(inds{i},:),1);
    end  
    lab_vals = colorspace('Lab<-', rgb_vals);                      
    seg_vals=reshape(lab_vals,supNum,3); % feature for each superpixel  
    
    % compute Impact Factor Matrix
    impfactor=AdjcProcloop(sulabel,supNum);
    edges=[];
    for i=1:supNum
        indext=[];
        ind=find(impfactor(i,:)==1);
        for j=1:length(ind)
            indj=find(impfactor(ind(j),:)==1);
            indext=[indext,indj];
        end
        indext=[indext,ind];
        indext=indext((indext>i));    
        indext=unique(indext);
        if(~isempty(indext))
            ed=ones(length(indext),2);
            ed(:,2)=i*ed(:,2);
            ed(:,1)=indext;
            edges=[edges;ed];
        end
    end   
    weights = makeweights(edges,seg_vals,theta);             
    F = adjacency(edges,weights,supNum);                    
    
    % calculate a row-normalized impact factor matrix
    D_sam=sum(F,2);
    D=diag(D_sam);
    F_normal=inv(D)*F;   % the row-normalized impact factor matrix
    
    % compute Coherence Matrix 
    C=a*normalization(1./max(F'),0)+b;
    C_normal=diag(C);
   
    % Update the saliency map according to Synchronous Updating Rule
    S_N1=S_bg';
    diff = setdiff(1:supNum, boundsp);
    
    % step1: decrease the saliency value of boundary superpixels
    for lap=1:5
        S_N1(boundsp) = S_N1(boundsp) - 0.6;
        neg_Ind = find(S_N1 < 0);
        if numel(neg_Ind) > 0
           S_N1(neg_Ind) = 0.001; 
        end
        S_N1=C_normal*S_N1+(1-C_normal).*diag(ones(1,supNum))*F_normal*S_N1;
        S_N1(diff)=normalization(S_N1(diff),0);
    end        
    
    % step2: control the ratio of foreground larger than a threshold
    for lap = 1:5
        S_N1(boundsp) = S_N1(boundsp) - 0.6;
        neg_Ind = find(S_N1 < 0);
        if numel(neg_Ind) > 0
           S_N1(neg_Ind) = 0.001; 
        end
        most_sal_sup = find(S_N1 > 0.93);
        if numel(most_sal_sup) < 0.02*supNum
            sal_diff = setdiff(1:supNum, most_sal_sup);
            S_N1(sal_diff) = normalization(S_N1(sal_diff), 0);
        end
        S_N1=C_normal*S_N1+(1-C_normal).*diag(ones(1,supNum))*F_normal*S_N1;
        S_N1(diff)=normalization(S_N1(diff),0);
    end  
    
    % step3: simply update the saliency map according to rules
    for lap = 1:10
        S_N1 = C_normal*S_N1+(1-C_normal).*diag(ones(1,supNum))*F_normal*S_N1;
        S_N1 = normalization(S_N1, 0);
    end
    
    image_sam_1=zeros(m,n);
    image_sam_1(:)=S_N1(sulabel(:));
    image_saliency_1 = zeros(w(1), w(2));
    image_saliency_1(w(3):w(4), w(5):w(6)) = image_sam_1;
    outname=[saldir imnames(ii).name(1:end-4) '_BSCA' '.png'];
    imwrite(image_saliency_1,outname);                   
end
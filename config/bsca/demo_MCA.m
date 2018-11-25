% Demo for paper "Saliency Detection via Cellular Automata" 
% by Yao Qin, Huchuan Lu, Yiqun Xu and He Wang
% To appear in Proceedings of IEEE Conference on Computer Vision and Pattern Recognition (CVPR 2015), Boston, June, 2015.

clc;
clear all;
close all;
addpath('./others/');
%%---------------------------set parameters-----------------------------%%
v=0.15; % the value of ln(lamda/l-lamba)
M=5; % the number of incorporated saliency maps
N2=5; % the number of updating time steps

%%-----------------------Input M saliency maps -------------------------%%
imgRoot1 = './saliencymap1/';
imgRoot2 = './saliencymap2/';
imgRoot3 = './saliencymap3/';
imgRoot4 = './saliencymap4/';
imgRoot5 = './saliencymap5/'; % the input saliency maps paths
saldir = './saliencymap_MCA/';% the output path of the saliency map
mkdir(saldir);
imnames1 = dir([ imgRoot1 '*' 'png']);
imnames2 = dir([ imgRoot2 '*' 'png']);
imnames3 = dir([ imgRoot3 '*' 'png']);
imnames4 = dir([ imgRoot4 '*' 'png']);
imnames5 = dir([ imgRoot5 '*' 'png']);
for ii = 1:length(imnames1)
    disp(ii);
    imName1 = [ imgRoot1 imnames1(ii).name(1:end-4)  '.png' ];  
    imName2 = [ imgRoot2 imnames1(ii).name(1:end-4)  '.png' ];
    imName3 = [ imgRoot3 imnames1(ii).name(1:end-4)  '.png' ];
    imName4 = [ imgRoot4 imnames1(ii).name(1:end-4)  '.png' ];  
    imName5 = [ imgRoot5 imnames1(ii).name(1:end-4)  '.png' ];
    
    input_im1=double(imread(imName1));
    input_im2=double(imread(imName2));
    input_im3=double(imread(imName3));
    input_im4=double(imread(imName4));
    input_im5=double(imread(imName5));
    
    % avoid that saliency values equal zero
    input_im1=normalize_1(input_im1,0);  
    input_im2=normalize_1(input_im2,0);
    input_im3=normalize_1(input_im3,0);
    input_im4=normalize_1(input_im4,0);  
    input_im5=normalize_1(input_im5,0);

    [m,n]=size(input_im1);
    S_M=cell(1,M);
    for i=1:M               
         if i==1
            S_M{i}=input_im1;
            else if i==2
                 S_M{i}=input_im2;
              else if i==3
                      S_M{i}=input_im3;
                 else if i==4
                         S_M{i}=input_im4;
                     else  
                         S_M{i}=input_im5;
                     end
                 end
             end
         end
    end
    
    %%-----------------Multilayer Cellular Automata--------------------%%
    % compute the threshold 
    threshold=zeros(1,M);    
    for i=1:M                 
        threshold(i)=log(graythresh(S_M{i})/(1-graythresh(S_M{i})));
    end
    
    % record saliency values in th form of ln()
    for i=1:M                
        S_M{i}=log((S_M{i})./(1-S_M{i}));
    end
    coda_2_sign=cell(1,M);   
    
    % update the saliency maps according to rules
    for lap=1:N2
        for i=1:M               
           coda_2_sign{i}=sign(S_M{i}-threshold(i));
        end
        sum2=zeros(m,n);
        for j=1:M           
            sum2=sum2+coda_2_sign{j};
        end

        for i=1:M       
            S_M{i}= S_M{i}+(sum2-coda_2_sign{i})*v;
        end
    end
   
    % restore saliency values from ln()
    for i=1:M 
        S_M{i}=exp(S_M{i})./(1+exp(S_M{i}));
    end
    
    S_M=normalization(S_M,1);
    
    % integrate M updated saliency maps
    S_N2=zeros(m,n);
    for i=1:M
        S_N2=S_N2+S_M{i};
    end
    S_N2=normalization(S_N2,0);

    outname=[saldir imnames1(ii).name(1:end-12) '_MCA' '.png'];
    imwrite(S_N2,outname); 
 
end

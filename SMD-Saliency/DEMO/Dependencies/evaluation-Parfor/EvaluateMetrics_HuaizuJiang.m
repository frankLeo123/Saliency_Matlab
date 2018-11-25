function perf = EvaluateMetrics_HuaizuJiang( DATASET_NAME, smap_dir, alpha, smap_suffix, img_extension )
    % Evaluate a salient object detection algorithm according to the ground
    % truth annotations. A saliency map is binarized with a set of fixed
    % thresholds [0:255]. At each threshold, a set of metrics are computed.
    % Evaluation can be accelerated using matlabpool.
    % 
    % Input:
    % DATASET_NAME  benchmark dataset name, e.g., 'MSRA'
    % smap_dir      directory where the saliency maps are stored
    % alpha         parameter to compute the F-measure, defined as
    % F-measure = (1 + alpha) * precision * recall / (alpha * precision + recall). (default 0.5)
    % smap_suffix   if the saliency map of a.png is stored as a_smap.png, smap_suffix = '_smap'. (default '_smap')
    % img_extension extension of images (default '.png')   
    % 
    % Output:
    % perf          performance struct, which contains
    %   recall
    %   precision
    %   tpr         true positive rate
    %   fpr         false positive rate
    %   f_measure   mean F-measure scores obtained at each fixed threshold
    %   mae         mean absolute error
    %   auc         area under ROC curve
    %   ap          average precision score
    %   wf          weighted f-measure
    
    % ground truth directory
    % gt_dir = fullfile('../../Data', [DATASET_NAME, '_gt']);
    gt_dir = fullfile('H:\Saliency_Weak\GitHub\Data', [DATASET_NAME, '_gt']);
    
    if nargin < 5
        img_extension = '.png';
    end

    if nargin < 4 
        smap_suffix = '_smap';
    end
    
    if nargin < 3 
        alpha = 0.5;
    end

    image_list = dir(fullfile(smap_dir, strcat('*', img_extension)));
%     image_list = dir(fullfile('../../Results', DATASET_NAME, 'LSSVMP/*.png'));
    fprintf( '\tThere are %d images.\n', length(image_list) );

    nframe = length(image_list);
    precision = zeros(nframe,256);
    recall = zeros(nframe,256);
    temp_fpr = zeros(nframe, 256);
    temp_tpr = zeros(nframe, 256);
    
    adp_pre_vec = zeros(nframe, 1);
    adp_rec_vec = zeros(nframe, 1);
    
    temp_mae = zeros(nframe, 1);
    
    temp_wf = zeros(nframe, 1);

    parfor ix = 1 : nframe
        smap_name = image_list(ix).name;
        image_name = [smap_name(1:end-length(img_extension)-length(smap_suffix)), img_extension];
%         image_name = [smap_name(1:end-11), '.png'];
        smap_name = [image_name(1:end-4), smap_suffix, img_extension];
        gt_name = image_name;
        
        smap = imread(fullfile(smap_dir, smap_name));
        if size(smap,3) == 3
            % smap = smap(:,:,1);
            smap = rgb2gray(smap);
        end
        
        gt_mask = imread(fullfile(gt_dir, gt_name));
        if size(gt_mask,3) == 3
            % gt_mask = gt_mask(:,:,1);
            gt_mask = rgb2gray(gt_mask);
        end
        
        gt_mask = imresize(gt_mask, size(smap));

        fg_map = smap(gt_mask>0);
        bg_map = smap(gt_mask==0);
        fg_hist = histc(fg_map, 0:255);
        bg_hist = histc(bg_map, 0:255);
        
        fg_false = [0; cumsum(fg_hist(1:end-1))];    % # of pt in fg having sal < thr, false negative
%         fg_false = cumsum(fg_hist(1:end));    % # of pt in fg having sal < thr, false negative
        fg_true = sum(fg_hist)-fg_false;            % # of pt in fg having sal >= thr, true positive
%         if fg_true(1) == sum(fg_hist)
%             fg_true(1) = 0;
%         end
        
        bg_true = [0; cumsum(bg_hist(1:end-1))];     % # of pt in bg having sal < thr, true negative
%         bg_true = cumsum(bg_hist(1:end));     % # of pt in bg having sal < thr, true negative
        bg_false = sum(bg_hist)-bg_true;            % # of pt in bg having sal < thr,  false positive

        precision(ix, :) = fg_true./(fg_true+bg_false+eps);
        recall(ix, :) = fg_true/(sum(gt_mask(:)>0) + eps);
        %recall(ix, :) = fg_true ./ (fg_true + fg_false + eps);
        
        temp_fpr(ix, :) = bg_false ./ (bg_false + bg_true + eps);
        temp_tpr(ix, :) = fg_true ./ (fg_true + fg_false + eps);
        
        g = im2double( gt_mask );
%         g( g > 0.5 ) = 1.0;
%         g( g < 0.5 ) = 0;
        a = im2double( smap );
        
        temp_mae(ix) = mean2( abs(g - a) );
        
        M = a > 2 * mean2(a);
        G = g > 0.5;
        adp_pre_vec(ix) = length(find(M & G)) / (length(find(M)) + eps);
        adp_rec_vec(ix) = length(find(M & G)) / (length(find(G)) + eps);
        
        temp_wf(ix) = WFb( a, g > 0.5 );
    end

    pre_avg = mean(precision, 1);
    rec_avg = mean(recall, 1);
    
    tpr = mean( temp_tpr, 1 );
    fpr = mean( temp_fpr, 1 );
    
    auc = -trapz( fpr, tpr );

    rr = rec_avg;
    pp = pre_avg;
    
    f_measure = (1 + alpha) * mean(rr) * mean(pp) / max( alpha*mean(pp) + mean(rr), eps );
    
    mae = mean( temp_mae );
    
    ap = -trapz( rr, pp );
    
    wf = mean(temp_wf);
    
    perf.recall = rr;
    perf.precision = pp;
    
    perf.fpr = fpr;
    perf.tpr = tpr;
   
    perf.f_measure = f_measure;
    perf.mae = mae;
    
    perf.auc = auc;
    perf.ap = ap;
    
    perf.adp_pre = mean(adp_pre_vec);
    perf.adp_rec = mean(adp_rec_vec);
    alpha = 0.3;
    perf.adp_fmeasure = (1 + alpha) * perf.adp_pre * perf.adp_rec / (alpha * perf.adp_pre + perf.adp_rec + eps);
    
    perf.wf = wf;
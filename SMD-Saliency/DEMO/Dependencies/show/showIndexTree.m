function [] = showIndexTree(img, sup, multiSegments)
    layerNum = size(multiSegments,2);
    figure; subplot(1,layerNum+2, 1); imshow(mat2gray(img.RGB), []);
    RGBLabel = superpixels2RGB(sup.label);
    subplot(1,layerNum+2, 2); imshow(RGBLabel, []);
    
    lblImg = sup.label;
    for i = 1:size(multiSegments,2)
        lblImg_temp = lblImg;
        layer_i = multiSegments(:,i);
        labels = unique(layer_i);
        for j = 1:length(labels)
            ind = find(layer_i==labels(j));
            for k = 1:length(ind)
                lblImg_temp(lblImg(:)==ind(k)) = labels(j);
            end
        end
        RGBLabel = superpixels2RGB(lblImg_temp);
        subplot(1, layerNum+2, 2+i); imshow(RGBLabel,[]);
    end
    
end
function meanPos = GetNormedMeanPos(pixelList, height, width)
% FUNCTION: compute position coordinate of superpixels

spNum = length(pixelList);
meanPos = zeros(spNum, 2);

for n = 1 : spNum
    [rows, cols] = ind2sub([height, width], pixelList{n});    
    meanPos(n,1) = mean(rows) / height;
    meanPos(n,2) = mean(cols) / width;
end
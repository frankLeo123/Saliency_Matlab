function [] =  featMapShow(feat,labelMap) 
[height, width] = size(labelMap);
featMap = zeros(height, width);
if min(min(labelMap)) == 0
    labelMap = labelMap + 1;
end
for i=1:height
    for j=1:width
        label = labelMap(i,j);
        featMap(i,j) = feat(label);
    end
end
imshow(featMap,[]);



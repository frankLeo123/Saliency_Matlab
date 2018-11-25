function salMap = GetSaliencyMap(feaVec, pixelList, frameRecord, doNormalize, fill_value)
% Fill back super-pixel values to image pixels and save into images


if (~iscell(pixelList))
    error('pixelList should be a cell');
end

if (nargin < 6)
    doNormalize = true;
end

if (nargin < 7)
    fill_value = 0;
end

h = frameRecord(1);
w = frameRecord(2);

top = frameRecord(3);
bot = frameRecord(4);
left = frameRecord(5);
right = frameRecord(6);

partialH = bot - top + 1;
partialW = right - left + 1;
partialImg = CreateImageFromSPs(feaVec, pixelList, partialH, partialW, doNormalize);

guassSigmaRatio = 0.55;
if partialH ~= h || partialW ~= w
    featImg = ones(h, w) * fill_value;
    featImg(top:bot, left:right) = partialImg;
    featImg = calculateGuassOptimization(featImg,guassSigmaRatio,h,w);
    salMap = ( featImg - min(featImg(:)) ) / ( max(featImg(:)) - min(featImg(:)) );
else
    partialImg = calculateGuassOptimization(partialImg,guassSigmaRatio,h,w);
    salMap = ( partialImg - min(partialImg(:)) ) / ( max(partialImg(:)) - min(partialImg(:)) );
end
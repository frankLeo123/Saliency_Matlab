function prior = GetHighLevelPriors(supPos, supNum, colorPriorMat, colorFeatures, bgPrior)
    % center prior
    center = [0.5 0.5];
    centerPrior = zeros(supNum,1);
    sigma = 0.25;
    for c = 1:supNum
        tmpDist = norm( supPos(c,:) - center );
        centerPrior(c) = exp(-tmpDist^2/(2*sigma^2));
    end
    % color prior
    colorPrior = zeros(supNum,1);
    for index = 1:supNum
        nR = colorFeatures(index,1)/(sum(colorFeatures(index,:))+1e-6);
        nG = colorFeatures(index,2)/(sum(colorFeatures(index,:))+1e-6);
        x = min(floor(nR/0.05)+1,20);
        y = min(floor(nG/0.05)+1,20);
        colorPrior(index,1) = (colorPriorMat(x,y)+0.5)/1.5;
    end
    % integrate center, color and background priors
    prior = centerPrior .* colorPrior .* bgPrior;
    prior = mapminmax(prior',0,1)';
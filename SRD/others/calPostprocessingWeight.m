function weight = calPostprocessingWeight(sal_lab,adjc,spnum)

weight = sal_lab.*adjc;
DD = sum(weight,2)./(sum(adjc,2));
DD = padarray(DD',[spnum-1 0],'replicate','post')./(padarray(DD,[0 spnum-1],'replicate','post') + 0.000001);
weight = weight.*DD;
weight = weight./(padarray(sum(weight,2),[0 spnum-1],'replicate','post')+0.000001);
clear DD
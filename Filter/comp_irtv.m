function [irtv, dgx, lgx] = comp_irtv(gx, ss, epsl, epsd)

% if ~exist('epsl', 'var'), epsl = 0.001; end
if ~exist('epsl', 'var'), epsl = 0.00001; end
% if ~exist('epsd', 'var'), epsd = 0.02; end
if ~exist('epsd', 'var'), epsd = 0.00001; end
% global epsl epsd
% dgx = gaussianfilter(abs(gx), ss); 
% lgx = abs(gaussianfilter(gx, ss));
fr = ceil(3*ss);
k = fspecial('gaussian', [2*fr+1 2*fr+1], ss);
% k = fspecial('gaussian', [1 2*fr+1], ss);
% k = fspecial('average', [2*fr+1, 2*fr+1]);
% [x, y] = meshgrid(1:2*fr+1, 1:2*fr+1);
% x = x - (fr+1);
% y = y - (fr+1);
% dist = sqrt(x.*x + y.*y);
% k = max((fr-dist)/fr, 0);
% k = fspecial('average', [2*fr+1 2*fr+1]);
dgx = imfilter(abs(gx), k, 'symmetric'); 
lgx = abs(imfilter(gx, k, 'symmetric'));
dgx = mean(dgx, 3);
lgx = mean(lgx, 3);

%irtv = (lgx+epsl) ./ (dgx+epsd);
irtv = (lgx+epsl) ./ (dgx+epsd);

end
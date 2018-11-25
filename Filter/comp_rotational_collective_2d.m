function [ cF ] = comp_rotational_collective_2d( F, ss, theta )
fr = ceil(ss);
h = fspecial('average', [fr*2+1 fr*2+1]);
% h2 = fspecial('gaussian', [fr*2+1 fr*2+1], ss/3.0);
% h = h .* h2;
h_right = h;
h_left = h;
h_right(:, 1:fr) = 0;
h_left(:, fr+1:2*fr+1) = 0;
h_right = h_right / sum(sum(h_right));
h_left = h_left / sum(sum(h_left));
h_right = imrotate(h_right, theta);
h_left = imrotate(h_left, theta);

h_right = flipud(fliplr(h_right));
h_left = flipud(fliplr(h_left));
collective_right = imfilter(F, h_right, 'symmetric');
collective_left = imfilter(F, h_left, 'symmetric');
cF = max(collective_right, collective_left);
end
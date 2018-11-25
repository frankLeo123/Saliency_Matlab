function [ res, scale] = safiltering( img, ss, sr, niter, se, div )
if (~exist('ss','var'))
   ss = 3;
end
if (~exist('sr','var'))
   sr = 0.1;
end
if (~exist('se','var'))
   se = 0.1;
end
if (~exist('niter','var'))
   niter = 5;
end
if (~exist('div','var'))
   div = 30;
end

sigma_s = ss; % gaussian kernel for directional RTV
sigma_final = sigma_s*1.5; % gaussian kernel for joint bilateral filtering
sigma_r = sr.*sqrt(size(img, 3)); % color weights kernel for joint bilateral filtering
 
sigma_e = se.^2;
division = div;

[h, w, ~] = size(img);
L0 = gpuArray(im2single(img));
L = L0;

for ii = 1:niter
    disp(strcat('safiltering itertion ', num2str(ii), '...'));
    tic;
    [flatness, max_angle] = comp_flatness_rotational(L, sigma_s, sigma_e, division);
    total_collective = zeros(h, w);
    for i = 0:division:179
        cf = comp_rotational_collective_2d(flatness, ss, i);
        idx = (max_angle == i);
        total_collective = total_collective + idx .* cf;
    end    
    scale = max(1.0, total_collective*ss);
    r_L = gaussian_varying_scale(L, scale);
    L = blf_2d_gpu(L0, r_L, sigma_final, sigma_r);
    figure(12), imshow(L); drawnow;
end
figure(12), imshow(L);
res = gather(L);
end
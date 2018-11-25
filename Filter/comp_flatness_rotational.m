function [ flatness_max, max_angle] = comp_flatness_rotational( L, sigma_s, sigma_e, division)
step = 1;
[gx, gy] = gradient(L);
irtv = comp_irtv(comp_directional_gradient(gx, gy, 0, step), sigma_s);
max_irtv = irtv;
% min_irtv = irtv;
[h, w, ~] = size(L);
max_angle = zeros(h, w);

for i = division : division : 179
    irtv = comp_irtv(comp_directional_gradient(gx, gy, i, step), sigma_s);
    max_irtv = max(irtv, max_irtv);
    idx = (irtv == max_irtv);
    max_angle = max_angle .* (1-idx) + i * idx;
end

wx = max_irtv;
ex = wx.^2;
ex = exp(-0.5 * ex / sigma_e);
flatness_max = ex;
end


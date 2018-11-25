function [ dir_G ] = comp_directional_gradient( gx, gy, theta, step)
%COMP_DIRECTIONAL_GRADIENT �� �Լ��� ��� ���� ��ġ
%   �ڼ��� ���� ��ġ
v = step * [cosd(theta), sind(theta)];
dir_G = v(1)*gx + v(2)*gy;
end


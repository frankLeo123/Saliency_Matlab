function [ dir_G ] = comp_directional_gradient( gx, gy, theta, step)
%COMP_DIRECTIONAL_GRADIENT 이 함수의 요약 설명 위치
%   자세한 설명 위치
v = step * [cosd(theta), sind(theta)];
dir_G = v(1)*gx + v(2)*gy;
end


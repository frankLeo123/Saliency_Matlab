% function [ label ] = GMM( singleChannel )
%GMM 此处显示有关此函数的摘要
%   此处显示详细说明
%% 程序说明
%% 该程序为混合正态分布参数估计算法
%% 微博：iyx_yao
%% 欢迎交流

%% 产生拟合数据
clear all;
% bad =imread(['E:\Project\cvpr\Saliency_Matlab\config\LAB\0001h.png']);
% good =imread(['E:\Project\cvpr\Saliency_Matlab\config\LAB\0007a.png']);
% 
% [Y,X]=imhist(good);
% plot(X,Y,'b');
% hold on;
% 
% k = 2; % 高斯分布的个数
% 
% %% 参数初始化：kmeans算法估计
% idx = kmeans(Y,k);
% for i = 1:k
%     N(i) = length(Y(idx == i));
%     a(i) = N(i) / length(Y);
%     u(i) = mean(Y(idx == i));
%     o(i) = std(Y(idx == i));
% end
% 
% %% 迭代程序
% t = 1;
% while t < 100
%     Es = 0;
%     for i = 1:k
%     Es = Es + a(i) * normpdf(Y,u(i),o(i));
%     end
%     for i = 1:k
%     E = a(i) * normpdf(Y,u(i),o(i));
%     N(i) = sum(E./Es);
%     a(i) = N(i)/length(Y);
%     u(i) =  sum(E./Es.*Y)/N(i);
%     o(i) = sqrt(sum(E./Es.*(Y-u(i)).^2)/N(i));
%     end
%     t = t + 1;
% end
% disp('理论值')
% % [nk,mu,sigma]
% disp('计算值')
% [a,u,o]
% 
% x = [];
% x = [x normrnd(u(2),o(2),1,256)];
% plot(X,x,'r');
% hold on;
% idx = idx *200;
% plot(X,idx','g');
% end
%% before

k = 3; % 高斯分布的个数
mu = [0  50  100];
sigma = [10 10 10];
nk = [1/3 1/3 1/3];
x = [];
tmp = linspace(1,300,300);
tmp1 = linspace(1,900,900);
for i = 1:k
    x = [x normpdf(tmp,mu(i),sigma(i))];
end
% x=-1:.1:1;
% norm=normpdf(x,0,1);
% figure('Position',[50,50,600,500],'Name','Normal PDF','Color',[1,1,1]);
% plot(x,norm)

plot(tmp1',x,'b')
hold on;
%% 参数初始化：kmeans算法估计
idx = kmeans(x',k);
for i = 1:k
    N(i) = length(x(idx == i));
    a(i) = N(i) / length(x);
    u(i) = mean(x(idx == i));
    o(i) = std(x(idx == i));
end

%% 迭代程序
t = 1;
while t < 100
    Es = 0;
    for i = 1:k
    Es = Es + a(i) * normpdf(x,u(i),o(i));
    end
    for i = 1:k
    E = a(i) * normpdf(x,u(i),o(i));
    N(i) = sum(E./Es);
    a(i) = N(i)/length(x);
    u(i) =  sum(E./Es.*x)/N(i);
    o(i) = sqrt(sum(E./Es.*(x-u(i)).^2)/N(i));
    end
    t = t + 1;
end
disp('理论值')
[nk,mu,sigma]
disp('计算值')
[a,u,o]

res = [];
for i = 1:k
    res = [res normpdf(tmp,u(i),o(i))];
end
plot(tmp1',idx,'r')

function [centres, options, post, errlog] = zl_kmeans(dictionarySize, data, options)
% k - 平均聚类
% Adapted from Netlab neural network software:
% http://www.ncrg.aston.ac.uk/netlab/index.php
%
%	Description
%	 CENTRES = KMEANS(CENTRES, DATA, OPTIONS) uses the batch K-means
%	algorithm to set the centres of a cluster model. The matrix DATA
%	represents the data which is being clustered, with each row
%	corresponding to a vector. The sum of squares error function is used.
%	The point at which a local minimum is achieved is returned as
%	CENTRES.  The error value at that point is returned in OPTIONS(8).
%
%	[CENTRES, OPTIONS, POST, ERRLOG] = KMEANS(CENTRES, DATA, OPTIONS)
%	also returns the cluster number (in a one-of-N encoding) for each
%	data point in POST and a log of the error values after each cycle in
%	ERRLOG.    The optional parameters have the following
%	interpretations.
%
%	OPTIONS(1) is set to 1 to display error values; also logs error
%	values in the return argument ERRLOG. If OPTIONS(1) is set to 0, then
%	only warning messages are displayed.  If OPTIONS(1) is -1, then
%	nothing is displayed.
%
%	OPTIONS(2) is a measure of the absolute precision required for the
%	value of CENTRES at the solution.  If the absolute difference between
%	the values of CENTRES between two successive steps is less than
%	OPTIONS(2), then this condition is satisfied.
%
%	OPTIONS(3) is a measure of the precision required of the error
%	function at the solution.  If the absolute difference between the
%	error functions between two successive steps is less than OPTIONS(3),
%	then this condition is satisfied. Both this and the previous
%	condition must be satisfied for termination.
%
%	OPTIONS(4) is the maximum number of iterations; default 100.
%
%	Copyright (c) Ian T Nabney (1996-2001)

ndata = size(data,1);
ncentres = dictionarySize;

if(nargin<3)
    options = zeros(1,5);
    options(1) = 1; % display
    options(2) = 1;
    options(3) = 0.1;
end

if (ncentres > ndata)
  error('More centres than data')
end

% 设置最大循环次数，默认值为100
if (options(4))
  niters = options(4);
else
  niters = 100;
end

store = 0;
if (nargout > 3)
  store = 1;
  errlog = zeros(1, niters);
end

% 随机选择SIFT描述符作为初始的聚类中心
perm = randperm(ndata);
perm = perm(1:ncentres);
centres = data(perm, :);
clear perm

% Matrix to make unit vectors easy to construct
id = eye(ncentres);

% k - 平均聚类算法的主循环
for n = 1:niters

  % 保存老的聚类中心，用于判断终止条件
  old_centres = centres;
  
  % 计算训练集和聚类中心点集所有点之间的距离（欧式距离）
  %d2 = zl_distance2(data, centres);  % d2为矩阵：ndata × ncentres
  d2 = DistanceZL(data, centres, 'euclid');

  % 将每个数据点分配到最近的聚类中心，index为ndata维的向量，表示每个数据点对应的聚类中心
  [minvals, index] = min(d2', [], 1);
  post = id(index,:);  % post：ndata × ncentres的矩阵
  clear index d2

  num_points = sum(post, 1);
  % 计算新的聚类中心
  for j = 1:ncentres
    if (num_points(j) > 0)
      centres(j,:) = sum(data(find(post(:,j)),:), 1)/num_points(j);
    end
  end
  clear num_points

  % Error value is total squared distance from cluster centres
  e = sum(minvals);
  clear minvals
  if store
    errlog(n) = e;
  end
  if options(1) > 0
    fprintf(1, 'Cycle %4d  Error %11.6f\n', n, e);
  end

  if n > 1
    % Test for termination
    if max(max(abs(centres - old_centres))) < options(2) & ...
        abs(old_e - e) < options(3)
      options(5) = e;
      return;
    end
  end
  old_e = e;
end

% If we get here, then we haven't terminated in the given number of 
% iterations.
options(5) = e;
if (options(1) >= 0)
  disp('Warning: Maximum number of iterations has been exceeded');
end


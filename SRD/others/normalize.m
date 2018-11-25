function value = normalize(in,par)
% ����ֵ��Χ��һ����0~1
% Input��
%           ker        ����һ���ķ�ʽѡ��
%                           'matrix' 
%                           'row'
%                           'column' 

if nargin < 2
    par = 'matrix';
end

in = double(in);
[m n] = size(in);
switch lower(par)
    case 'matrix'
        value = (in - min(in(:)))/(max(in(:)) - min(in(:)));
    case 'row'
        value = zeros(m,n);
        for i = 1:m
            value(i,:) = (in(i,:) - min(in(i,:)))/(max(in(i,:)) - min(in(i,:)));
        end
    case 'column' 
        value = zeros(m,n);
        for i = 1:n
            value(:,i) = (in(:,i) - min(in(:,i)))/(max(in(:,i)) - min(in(:,i)));
        end
    otherwise
        value = (in - min(in(:)))/(max(in(:)) - min(in(:)));
end
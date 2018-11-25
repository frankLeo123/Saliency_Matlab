function dist = calDistribution(salSup,Isum,x_vals,y_vals,m,n,spnum,number)

% xo = n/2; yo = m/2;

x_valMat = ones(number,1)*x_vals'; y_valMat = ones(number,1)*y_vals';
x0 = (sum(salSup.*x_valMat,2)./Isum)*ones(1,spnum);
y0 = (sum(salSup.*y_valMat,2)./Isum)*ones(1,spnum);
coherence = sum(salSup.*sqrt((x_valMat-x0).^2 + (y_valMat - y0).^2),2)./Isum;
% centric = sum(salSup.*sqrt((x_valMat-xo).^2 + (y_valMat - yo).^2),2)./Isum;

bgDis = min([y_vals-1 n-x_vals m-y_vals x_vals-1],[],2);
bgDis = max(bgDis) - bgDis;
centric = sum(salSup.*(ones(number,1)*bgDis'),2)./Isum;

dist = coherence + centric;
clear x_valMat y_valMat x0 y0 coherence centric


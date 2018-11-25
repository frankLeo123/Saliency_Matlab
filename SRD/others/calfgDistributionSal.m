function fgSal = calfgDistributionSal(salSup,Isum,x_vals,y_vals,weight,m,n,spnum,number)

comSal = calDistribution(salSup,Isum,x_vals,y_vals,m,n,spnum,number);

fgSal = comSal;
index = comSal > mean(comSal);

fgSal(index) = mean(comSal);
fgSal = 1 - normalize(fgSal);

clear dist coherence centric

function W = calSparseGraph( sal_lab, adjc, bord, spnum )

sal = sal_lab.*bord;
[~,index] = max(sal,[],2);

a = 1:spnum;
W = sparse([a';index],[index;a'], ...
    [ones(spnum,1);ones(spnum,1)],spnum,spnum);
W = W + adjc;
W(W ~= 0) = 1;
function [a b rsqr resid] = OLS(x,y)

x1 = [ones(length(x),1) x];
linefit = inv(x1'*x1)*x1'*y;
resid = y - x*linefit(2) - linefit(1); 
ym = y - mean(y); 
rsqr = 1 - ( resid'*resid)/(ym'*ym);
a = linefit(2);
b = linefit(1);

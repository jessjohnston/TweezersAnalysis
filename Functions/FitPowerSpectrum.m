function [parameters sigma_par cv chi2] = ...
                        FitPowerSpectrum(xfin,yfin,sfin,p0,hydroparam,fNyq)

warning off;

options = optimset('TolX',1e-9,'Display','Off','MaxIter',1e3,'MaxFunEvals',1e3);
weights = inline('(1./theoreticalP(p,xfin,fNyq,hydroparam)-1./yfin)./sfin', ...
                            'p','xfin','fNyq','hydroparam','yfin','sfin');
[parameters,RESNORM,RESIDUAL,EXITFLAG,OUTPUT,LAMBDA,JACOBIAN] = ...
        lsqnonlin(weights,p0,[],[],options,xfin,fNyq,hydroparam,yfin,sfin);

% calculate chi-squared goodness of fit                    
nfree = length(yfin)-length(parameters);
% bbac = 1-gammainc(RESNORM/2,(nfree-2)/2);
chi2 = RESNORM/nfree;

% Errors on parameters      
CURVATURE = JACOBIAN'*JACOBIAN;
COVARIANCE = CURVATURE^(-1);
numParam = length(parameters);
sigma_par = zeros(numParam,1);
cv = zeros(numParam,numParam);
for i = 1:numParam
    sigma_par(i) = sqrt(COVARIANCE(i,i));
    for j = i:numParam
        cv(i,j) = COVARIANCE(i,j)/sqrt(parameters(i)*parameters(j));
    end
end
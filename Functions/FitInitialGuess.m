function  parameters0 = FitInitialGuess(f,P,fNyq)

% initial guess for fc and D (eq 13, pg 596, Berg-Sorenson)
for p=0:2,
    for q=0:2,
        eval(['s',num2str(p),num2str(q),'=sum((f.^(2*',num2str(p),')).*(P.^(',num2str(q),')));']);
    end
end
a =(s01*s22-s11*s12)/(s02*s22-s12.^2);
b =(s11*s02-s01*s12)/(s02*s22-s12.^2);
fc = sqrt(a/b);
D = (1/b)*(2*pi^2);

% Don't know where initial guess came from below (Berg-Sorenson pg 600-601)
%  initial guess for f_DIODE (3dB frequency of the photodiode)
P_aliasedNyq = 0;
for n = -10:10,
    P_aliasedNyq = P_aliasedNyq + (D/(2*pi^2))./((fNyq+2*n*fNyq).^2+fc^2);
end
if P(length(P)) < P_aliasedNyq
    dif = P(length(P))/P_aliasedNyq;
    f_diode0 = sqrt(dif*fNyq^2/(1-dif));
else
    f_diode0 = 2*fNyq;
end

% initial guess for alpha (fraction of photodiode response that is instantaneous)
alpha0 = 0.3; 
a0 = sqrt(1/alpha0^2 - 1);


% initial fit parameters
parameters0 = [fc log(D) f_diode0 a0]; 

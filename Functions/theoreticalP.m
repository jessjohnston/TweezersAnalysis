function P_theor = theoreticalP(parameters,x,fNyq,hydroparam)

% fit parameters
fc = parameters(1);
D = exp(parameters(2));
fdiode = parameters(3);
alpha = 1/sqrt(1+parameters(4)^2);

% low pass filter correction (eq 35, pg 601, Berg-Sorensen)
gdiode = @(f,fdiode,alpha) alpha^2+(1-alpha^2)./(1+(f/fdiode).^2);

% calculate theoretical aliased Lorentzian
P_theor = zeros(length(x),1);
if hydroparam.filter == 1;    
    for i = 1:length(x),
        P_theor(i) = 0;
        for n = -10:10,
           P_theor(i) = P_theor(i)+PhysicalPowerSpectrum(x(i)+2*n*fNyq, ...
                       hydroparam,fc,D)*gdiode(x(i)+2*n*fNyq,fdiode,alpha);
        end  
    end
else
    for i = 1:length(x),
        P_theor(i) = 0;
        for n = -10:10,
          P_theor(i) = P_theor(i)+(D/(2*pi^2))./((x(i)+2*n*fNyq).^2+fc^2)...
                                       *gdiode(x(i)+2*n*fNyq,fdiode,alpha);
        end
    end
end 

end
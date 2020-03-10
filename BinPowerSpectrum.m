function [fb_plot Pb_plot] = BinPowerSpectrum(f,P,nbin)

% bin Power Spectrum
edges = [1 floor(length(f)/nbin*(1:nbin))];
fb_plot = zeros(nbin,1); Pb_plot = zeros(nbin,1);
for i = 1 : nbin
    fb_plot(i) = mean(f(edges(i):edges(i+1)));
    Pb_plot(i) = mean(P(edges(i):edges(i+1)));
end


end
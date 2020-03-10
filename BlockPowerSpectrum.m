function [fb Pb s nblock_plot] = BlockPowerSpectrum(f,P,nblock)

% (pg 596 of Berg-Sorensen)
nbin = floor(length(f)/nblock);
fb = zeros(nbin,1); Pb = fb; s = fb; nblock_plot = fb;
for i = 1:nbin
    index = (i-1)*nblock+1:i*nblock;
    fb(i) = mean(f(index));
    Pb(i) = mean(P(index));
    s(i) = 1/(Pb(i)*sqrt(nblock));
    nblock_plot(i) = length(index);
end

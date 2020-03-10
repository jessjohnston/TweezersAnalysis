function  [f,P,T,fNyq] = CalculatePowerSpectrum(X,sampling_f)

X = X - mean(X);
numX = length(X);

fNyq = sampling_f/2;
delta_t = 1/sampling_f;

time = (0:numX-1)'*delta_t;

T = time(end);
f = ((1:numX)/T)';

FT = delta_t*fft(X);
P = FT.*conj(FT)/T;

ind = find(f < fNyq,1,'last'); 
f = f(1:ind);
P = P(1:ind);
   
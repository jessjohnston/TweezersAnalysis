function P_hydro = PhysicalPowerSpectrum(f,hydroparam,fc,D)

rho = hydroparam.rho;
nu = hydroparam.nu;
R = hydroparam.R;
l = hydroparam.l;

% parameters
gamma = 6*pi*rho*nu*R;
m = 4/3*pi*R^3*rho;

% eq 32, pg 599, Berg-Sorenson
f_m = gamma/(2*pi*m); % parameterizes time takes for friction to dissipate KE of sphere
f_nu = nu/(pi*R^2); % parameterizes flow pattern around sphere undergoing linear harmonic oscillations


% real and imaginary (eq 34, Berg-Sorensen)
sqrt_f = sqrt(abs(f)/f_nu);
Reg = 1+sqrt_f-3/16*R/l+3/4*R/l*exp(-2*l/R*sqrt_f).*cos(2*l/R*sqrt_f);
Img = -sqrt_f+3/4*R/l*exp(-2*l/R*sqrt_f).*sin(2*l/R*sqrt_f);

P_hydro = (D/(2*pi^2)*Reg)./((fc+f.*Img-f.^2/f_m).^2+(f.*Reg).^2);


%% Displacement slope Calibration

[filename dirpath] = uigetfile(fullfile(dirpath,'*.txt'),'Select a file');
[tmp fname] = fileparts(filename);
data = dlmread(fullfile(dirpath,filename));


x = data(:,5);
y = data(:,4);
qpd = data(:,3);

% low pass filter strain gauge data
fNorm = .05;                                
[b,a] = butter(10, fNorm, 'low');                                                           
x = filtfilt(b, a, x);                                                           
qpd = filtfilt(b, a, qpd);  

time = 0:length(x)-1;
figure(1); clf; hold on;
plot(x,qpd); plot(x,y,'g');

[x2 y2] = ginput(2);

range = find(x > min(x2) & x < max(x2)); 

x = x(range);
qpd = qpd(range);

f = fittype('a*x+b');
[c gof] = fit(x,qpd,f,'startpoint',[-1 0]);

plot(x,c(x),'r');
title(['Displacement Slope = ' num2str(c.a)]);
xlabel('strain position');
ylabel('qpd');
print('-djpeg',fullfile(dirpath,strcat(fname,'_Fit')));


%% Power spectrum Single

[filename dirpath] = uigetfile(fullfile(dirpath,'*.txt'),'Select a power spectrum files','MultiSelect','on');
[tmp fname] = fileparts(filename);

sampling_f = 50000;

% fit parameters
nbin = 5000;
nblock = 100;
Lfit_start = 10;
Lfit_end = 10000;

% hydrodynamic drag parameters
hydroparam.filter = 0;
hydroparam.l = 0;
hydroparam.R = .63e-6;
hydroparam.nu = 1.33e-3;

% plot parameters
plotparams.histogram = 0;
plotparams.powerspectrum = 0;
plotparams.fit = 1;
plotparams.fitparameters = 0;

data = dlmread(fullfile(dirpath,filename));
[tmp savename] = fileparts(filename);
        
X = data(:,2);
        
% calculate power spectrum
[f P T fNyq] = CalculatePowerSpectrum(X,sampling_f);

% bin power spectrum
[fb_plot Pb_plot] = BinPowerSpectrum(f,P,nbin);

% Block Power Spectrum
[fb Pb s nblock_plot] = BlockPowerSpectrum(f,P,nblock);

%  Choose data to be fit 
ind = find(fb > Lfit_start & fb <= Lfit_end);
xfin = fb(ind);
yfin = Pb(ind);
sfin = s(ind);

% initial guess of power spectrum fit
p0 = FitInitialGuess(f,P,fNyq); 

% Fit Power Spectrum to Lorentzian    
[parameters sigma_par cv chi2] = FitPowerSpectrum(xfin,yfin,sfin,p0,hydroparam,fNyq);

% Plot fitted Lorentzian
figure(1); clf;
PlotPowerSpectrum(fb_plot,Pb_plot,fname); hold on;
PlotFittedLorentzian(fb,Pb,nblock_plot,parameters,sigma_par,chi2,fNyq,hydroparam,fname);
fname =  strcat(savename,'_Fitted'); 
print('-djpeg',fullfile(dirpath,fname));

% store values
fc = parameters(1); 
fcerror = sigma_par(1);
       


%% Power Spectrum Calibration

[filename dirpath] = uigetfile(fullfile(dirpath,'*.txt'),'Select axial position file');
data = dlmread(fullfile(dirpath,filename));
axialPos = data(:,1);

[filename dirpath] = uigetfile(fullfile(dirpath,'*.txt'),'Select a power spectrum files','MultiSelect','on');
numSteps = length(filename)/(length(axialPos)-1);

sampling_f = 50000;

% fit parameters
nbin = 10000;
nblock = 70;
Lfit_start = 10;
Lfit_end = 5000;

% hydrodynamic drag parameters
hydroparam.filter = 0;
hydroparam.l = 0;
hydroparam.R = .63e-6;
hydroparam.nu = 1.33e-3;

% plot parameters
plotparams.histogram = 0;
plotparams.powerspectrum = 0;
plotparams.fit = 1;
plotparams.fitparameters = 0;

k = 1;
pos = []; fc = []; fcerror = [];
for i = 1:length(axialPos)-1
    for j = 1:numSteps
        data = dlmread(fullfile(dirpath,filename{k}));
        [tmp savename] = fileparts(filename{k});
        
        X = data(:,2);
        

        % calculate power spectrum
        [f P T fNyq] = CalculatePowerSpectrum(X,sampling_f);

        % bin power spectrum
        [fb_plot Pb_plot] = BinPowerSpectrum(f,P,nbin);
           
        % Block Power Spectrum
        [fb Pb s nblock_plot] = BlockPowerSpectrum(f,P,nblock);

        %  Choose data to be fit 
        ind = find(fb > Lfit_start & fb <= Lfit_end);
        xfin = fb(ind);
        yfin = Pb(ind);
        sfin = s(ind);

        % initial guess of power spectrum fit
        p0 = FitInitialGuess(f,P,fNyq); 

        % Fit Power Spectrum to Lorentzian    
        [parameters sigma_par cv chi2] = FitPowerSpectrum(xfin,yfin,sfin,p0,hydroparam,fNyq);

        % Plot fitted Lorentzian
        figure(1); clf;
        PlotPowerSpectrum(fb_plot,Pb_plot,fname); hold on;
        PlotFittedLorentzian(fb,Pb,nblock_plot,parameters,sigma_par,chi2,fNyq,hydroparam,fname);
        fname =  strcat(savename,'_Fitted'); 
        print('-djpeg',fullfile(dirpath,fname));

        % store values
        fc = [fc; parameters(1)]; 
        fcerror = [fcerror; sigma_par(1)];
        pos = [pos; axialPos(i) - axialPos(1)]; 
        
        k = k + 1;
    end
end

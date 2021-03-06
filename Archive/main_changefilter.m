clear all;
close all;
clc;
dirpath = fileparts(pwd);

%% Use manual data to find equilibrium position

% load and parse Manual pulls
[piezoPos qpdVolts fname numData dirpath filename] = LoadParseData(dirpath);

% find equilibrium offset
[piezoPos2 qpdVolts2 xoffset yoffset] = AdjustEquilibriumPosition(piezoPos,qpdVolts);
SaveData(piezoPos2,qpdVolts2,dirpath,filename,'Corrected');
dlmwrite(fullfile(dirpath,'EquilibriumOffset.txt'),[xoffset yoffset]);

% load frequency data
[freq sampling_f freqName] = LoadFileIndex(dirpath);

% load OSCILLATION data
[piezoPos qpdVolts fname numData dirpath filename] = LoadParseData(dirpath);
[piezoPos2 qpdVolts2] = AdjustEquilibriumPosition(piezoPos,qpdVolts,xoffset,yoffset);

% low pass filter data
[fpiezoPos fqpdVolts] = BoxCarFilter(piezoPos2,qpdVolts2);
h = PlotRawData(fpiezoPos,fqpdVolts,1);
PlotLegend(freqName,'southwest');
print('-djpeg',fullfile(dirpath,['Raw_Oscillations_Uncorrected__Comparison']));

%% Manually correct for drift

% parse drift data
% driftInfo = ParseDriftManual(dirpath);

% manually adjust drift in oscillations
% adjustPos = AdjustDriftOscillations(piezoPos2,qpdVolts2,driftInfo,fname,dirpath);

% low pass filter data
[fpiezoPos fqpdVolts] = BoxCarFilter(adjustPos,qpdVolts2);
SaveData(fpiezoPos,fqpdVolts,dirpath,filename,'Corrected');

h = PlotRawData(fpiezoPos,fqpdVolts,1);
PlotLegend(freqName,'southwest');
saveIndex = FindNextFileIndex(dirpath,'Raw_Oscillations_Corrected_','jpg');
print('-djpeg',fullfile(dirpath,['Raw_Oscillations_Corrected_' num2str(saveIndex)]));
       
% raw data to line
fid = fopen(fullfile(dirpath,'RawFit.txt'),'a');
results = [];
for i = 1:numData
    warning off;
    piezo = fpiezoPos{i};
    qpd = fqpdVolts{i};

    A = max(piezo)-min(piezo);
    
    steps = round(length(qpd)/4);
    range = steps*2:steps*3;
    piezo = piezo(range);
    qpd = qpd(range);
    
    [a b rsqr resid] = OLS(piezo,qpd);
    fun = @(x) a*x+b;
    [h p kstat] = lillietest(resid);
    results = [results; freq(i) abs(a) A rsqr h p];
    
    figure(2); clf; hold on; box on;
    plot(piezo,qpd);
    plot(piezo,fun(piezo),'r','linewidth',2);
    xlabel('Piezo Position','fontsize',25);
    ylabel('QPD Volts','fontsize',25);
    title([num2str(freq(i)) ' Hz; slope = ' num2str(abs(a))],'fontsize',25);
    set(gca,'fontsize',20);
    print('-djpeg',fullfile(dirpath,['RawFit_' fname{i}]));
   
    fprintf(fid,'%s\t%f\t%f\t%f\t%d\t%f\n',fname{i},freq(i),abs(a),rsqr,h,p);
end
fclose(fid);


figure(3); clf; hold on; box on;
colorSet = varycolor(length(freq));
for i = 1:length(freq)
    scatter(freq(i),results(i,2),120,'marker','s','markeredgecolor',colorSet(i,:));
end
xlabel('Frequency (Hz)','fontsize',25);
ylabel('Raw Stiffness','fontsize',25);
title(['slope = ' num2str(abs(a))],'fontsize',25);
set(gca,'fontsize',20,'xscale','log');
print('-djpeg',fullfile(dirpath,'Raw Scatter slope vs frequency'));


figure(4); clf; hold on; box on;
colorSet = varycolor(length(freq)-1);
for i = 1:length(freq)-1
    plot(freq(i:i+1),results(i:i+1,2),'color',colorSet(i,:),'linewidth',2);
end
xlabel('Frequency (Hz)','fontsize',25);
ylabel('Raw Stiffness','fontsize',25);
title('pulls in order','fontsize',25);
set(gca,'fontsize',20,'xscale','log');
print('-djpeg',fullfile(dirpath,'Raw Slopes vs frequency in order'));


%% Calibration parameters for optical tweezers

% manually find displacement slope
%dispslope = FitDisplacementSlope(dirpath);


% manually fit power spectrum
% [psfile pspath] = uigetfile(fullfile(dirpath,'*.txt'),'Select a power spectrum files','MultiSelect','on');
% data = dlmread(fullfile(pspath,psfile));
% sampling_f = 40000;
% nblock = 100;
% Lfit_start = 30;
% Lfit_end = 10000;
% [fc fcerror] = PowerSpectrumSingle(data,pspath,sampling_f,nblock,Lfit_start,Lfit_end);

%%

fc = 1192;
dispslope = 3.88;


%%
strain2nm = 1415;

R = 0.6e-6;
eta = 1.45e-3; 
beta = 6*pi*eta*R;
k = fc*(2*pi *beta);
extension = cell(numData,1);
force = cell(numData,1);
for i = 1:numData
    ext = (fpiezoPos{i} - fqpdVolts{i}/dispslope*strain2nm)*1e-9; % in meters
    F = k*fqpdVolts{i}/dispslope*strain2nm*1e-9; % in Newtons
    extension{i} = -ext*1e9;    % nm
    force{i} = -F*1e12;         % pN
end
SaveData(extension,force,dirpath,filename,'FvsX_Filtered');

% plot force vs extension all together
linewidth = 2;
h = PlotForceVsExtension(extension,force,linewidth);
saveIndex = FindNextFileIndex(dirpath,'FvsX_Oscillations_Comparison_','jpg');
print('-djpeg',fullfile(dirpath,['FvsX_Oscillations_Comparison_' num2str(saveIndex)]));
saveas(h,fullfile(dirpath,['FvsX_Oscillations_Comparison_' num2str(saveIndex) '.fig']));
 

fid = fopen(fullfile(dirpath,'Fit.txt'),'a');
results = [];
for i = 1:numData
    warning off;
    piezo = extension{i};
    qpd = force{i};
    A = max(piezo)-min(piezo);
    steps = round(length(qpd)/4);
    range = steps*2:steps*3;
    piezo = piezo(range);
    qpd = qpd(range);
    
    [a b rsqr resid] = OLS(piezo,qpd);
    fun = @(x) a*x+b;
    [h p kstat] = lillietest(resid);
    results = [results; freq(i) abs(a) A rsqr h p];
    
    figure(2); clf; hold on; box on;
    plot(piezo,qpd);
    plot(piezo,fun(piezo),'r','linewidth',2);
    xlabel('Extension (nm)','fontsize',25);
    ylabel('Force (pN)','fontsize',25);
    title([num2str(freq(i)) ' Hz; slope = ' num2str(abs(a)) ' pN/nm'],'fontsize',25);
    set(gca,'fontsize',20);
    print('-djpeg',fullfile(dirpath,['Fit_' fname{i}]));
   
    fprintf(fid,'%s\t%f\t%f\t%f\t%d\t%f\n',fname{i},freq(i),abs(a),rsqr,h,p);
end
fclose(fid);

figure(3); clf; hold on; box on;
colorSet = varycolor(length(freq));
for i = 1:length(freq)
    scatter(freq(i),results(i,2),120,'marker','s','markeredgecolor',colorSet(i,:));
end
xlabel('Frequency (Hz)','fontsize',25);
ylabel('Stiffness (pN/nm)','fontsize',25);
set(gca,'fontsize',20,'xscale','log');
print('-djpeg',fullfile(dirpath,'Scatter slope vs frequency'));

figure(4); clf; hold on; box on;
colorSet = varycolor(length(freq)-1);
for i = 1:length(freq)-1
    plot(freq(i:i+1),results(i:i+1,2),'color',colorSet(i,:),'linewidth',2);
end
xlabel('Frequency (Hz)','fontsize',25);
ylabel('Stiffness  (pN/nm)','fontsize',25);
title('pulls in order','fontsize',25);
set(gca,'fontsize',20,'xscale','log');
print('-djpeg',fullfile(dirpath,'Slopes vs frequency in order'));



clear all;
close all;
clc;
dirpath = fileparts(pwd);

fc = 1374;
strain2nm = 1415;
disp = -16.6;
R = 0.6e-6;
eta = 1.4e-3; 

%% Use manual data to find equilibrium position

% load and parse Manual pulls
[piezoPos qpdVolts fname numData dirpath filename] = LoadParseData(dirpath);

% find equilibrium offset
[piezoPos2 qpdVolts2 xoffset yoffset] = AdjustEquilibriumPosition(piezoPos,qpdVolts);
SaveData(piezoPos2,qpdVolts2,dirpath,filename,'Adjusted');
dlmwrite(fullfile(dirpath,'EquilibriumOffset.txt'),[xoffset yoffset]);

% low pass filter data
fNorm = .4;
forder = 5;
[fpiezoPos fqpdVolts] = LowPassFilter(piezoPos2,qpdVolts2,fNorm,forder);
SaveData(fpiezoPos,fqpdVolts,dirpath,filename,'Filtered');

% plot adjusted data
linewidth = 2;
h = PlotRawData(fpiezoPos,fqpdVolts,linewidth);
PlotLegend(fname,'southwest');
title('Equilibrium Selection','fontsize',16);
print('-djpeg',fullfile(dirpath,'Raw_Equilibrium_Selection'));
saveas(h,fullfile(dirpath,'Raw_Equilibrium_Selection.fig'));

% convert to force vs extension
params.disp = disp;
params.strain2nm = strain2nm;
params.fc = fc;
params.R = R;
params.eta = eta;
[force extension] = Convert2FvsX(piezoPos2,qpdVolts2,params);
SaveData(extension,force,dirpath,filename,'FvsX');

% low pass filter data
fNorm = .4;
forder = 5;
[fforce fextension] = LowPassFilter(extension,force,fNorm,forder);
SaveData(fextension,fforce,dirpath,filename,'FvsX_Filtered');

% plot all force vs extension
linewidth = 2;
h = PlotForceVsExtension(extension,force,linewidth);
print('-djpeg',fullfile(dirpath,'FvsX_Equilibrium_Selection'));
saveas(h,fullfile(dirpath,'FvsX_Equilibrium_Selection.fig'));


%% Convert Sine waves to F vs X

% load and parse data
[piezoPos qpdVolts fname numData dirpath filename] = LoadParseData(dirpath);

% load file index
try
    [f sampling_f freqName] = LoadFileIndex(dirpath);
    status = 1;
catch
    status = 0;
end

% adjust to equilibrium offset
[xoffset yoffset] = GetEquilibriumOffset(dirpath);
[piezoPos2 qpdVolts2] = AdjustEquilibriumPosition(piezoPos,qpdVolts,xoffset,yoffset);
SaveData(piezoPos2,qpdVolts2,dirpath,filename,'Adjusted');

% low pass filter data
fNorm = .05;
forder = 5;
[fpiezoPos fqpdVolts] = LowPassFilter(piezoPos2,qpdVolts2,fNorm,forder);

% plot and save individual filtered data
xname = 'Piezo Position (nm)';
yname = 'QPD (V)';
PlotIndividualData(fpiezoPos,fqpdVolts,dirpath,fname,xname,yname,'Filtered');
SaveData(fpiezoPos,fqpdVolts,dirpath,filename,'Filtered');

% plot all adjusted data
linewidth = 2;
h = PlotRawData(fpiezoPos,fqpdVolts,linewidth);
if status == 1
    PlotLegend(freqName,'southwest');
else
    PlotLegend(fname,'southwest');
end
saveIndex = FindNextFileIndex(dirpath,'Raw_Oscillations_Comparison_','jpg');
print('-djpeg',fullfile(dirpath,['Raw_Oscillations_Comparison_' num2str(saveIndex)]));
saveas(h,fullfile(dirpath,['Raw_Oscillations_Comparison_' num2str(saveIndex) '.fig']));
        
% convert to force vs extension
params.disp = disp;
params.strain2nm = strain2nm;
params.fc = fc;
params.R = R;
params.eta = eta;
[force extension] = Convert2FvsX(piezoPos2,qpdVolts2,params);
SaveData(extension,force,dirpath,filename,'FvsX');

% low pass filter data
fNorm = .05;
forder = 5;
[fforce fextension] = LowPassFilter(force,extension,fNorm,forder);
SaveData(fextension,fforce,dirpath,filename,'FvsX_Filtered');

% plot individual force vs extensions
xname = 'Extension (nm)';
yname = 'Force (pN)';
PlotIndividualData(fextension,fforce,dirpath,fname,xname,yname,'FvsX');

% plot force vs extension all together
linewidth = 2;
h = PlotForceVsExtension(fextension,fforce,linewidth);
if status == 1
    PlotLegend(freqName,'northwest');
else
    PlotLegend(fname,'northwest');
end
saveIndex = FindNextFileIndex(dirpath,'FvsX_Oscillations_Comparison_','jpg');
print('-djpeg',fullfile(dirpath,['FvsX_Oscillations_Comparison_' num2str(saveIndex)]));
saveas(h,fullfile(dirpath,['FvsX_Oscillations_Comparison_' num2str(saveIndex) '.fig']));
 

%% Convert force clamp to F vs X

% load and parse data
[piezoPos qpdVolts fname numData dirpath filename] = LoadParseData(dirpath);

% adjust to equilibrium offset
[xoffset yoffset] = GetEquilibriumOffset(dirpath);
[piezoPos2 qpdVolts2] = AdjustEquilibriumPosition(piezoPos,qpdVolts,xoffset,yoffset);
SaveData(piezoPos2,qpdVolts2,dirpath,filename,'Adjusted');

% low pass filter data
fNorm = .2;
forder = 5;
[fpiezoPos fqpdVolts] = LowPassFilter(piezoPos2,qpdVolts2,fNorm,forder);
SaveData(fpiezoPos,fqpdVolts,dirpath,filename,'Filtered');

% plot time series data
samplingf = 100;
linewidth = 1;
PlotRawDataTimeSeries(fpiezoPos,fqpdVolts,samplingf,dirpath,fname,linewidth);

% convert to force vs extension
params.disp = disp;
params.strain2nm = strain2nm;
params.fc = fc;
params.R = R;
params.eta = eta;
[force extension] = Convert2FvsX(piezoPos2,qpdVolts2,params);
SaveData(extension,force,dirpath,filename,'FvsX');

% low pass filter data
fNorm = .2;  
forder = 5;
[fextension fforce] = LowPassFilter(extension,force,fNorm,forder);
SaveData(fextension,fforce,dirpath,filename,'FvsX_Filtered');

% plot force vs extension all together
linewidth = 2;
h = PlotForceVsExtension(fextension,fforce,linewidth);
PlotLegend(freqName,'southwest');
saveIndex = FindNextFileIndex(dirpath,'FvsX_Oscillations_Comparison_','jpg');
print('-djpeg',fullfile(dirpath,['FvsX_Oscillations_Comparison_' num2str(saveIndex)]));
saveas(h,fullfile(dirpath,['FvsX_Oscillations_Comparison_' num2str(saveIndex) '.fig']));
 
% plot individual force and extension time series
linewidth = 1;
PlotFvsXTimeSeries(fextension,fforce,samplingf,dirpath,fname,linewidth);


%% Plot Multiple Force vs extension

[fextension fforce name] = PlotMultipleFvsX(dirpath);

close all;
linewidth = 1;
h = PlotRawData(fextension,fforce,linewidth);
PlotLegend(name,'northwest');
saveIndex = FindNextFileIndex(dirpath,'FvsX_Comparison_','jpg');
print('-djpeg',fullfile(dirpath,['FvsX_Comparison_' num2str(saveIndex)]));
saveas(h,fullfile(dirpath,['FvsX_Comparison_' num2str(saveIndex) '.fig']));
 




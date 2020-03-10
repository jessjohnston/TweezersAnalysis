clear all;
close all;
clc;
dirpath = fileparts(pwd);

%% Use manual data to find equilibrium position

% load and parse Manual pulls
[piezoPos qpdVolts fname numData dirpath filename] = LoadParseData(dirpath);

% find equilibrium offset
[piezoPos2 qpdVolts2 xoffset yoffset] = AdjustEquilibriumPosition(piezoPos,qpdVolts);
SaveData(piezoPos2,qpdVolts2,dirpath,filename,'Adjusted');
dlmwrite(fullfile(dirpath,'EquilibriumOffset.txt'),[xoffset yoffset]);
% 
% % low pass filter data
% fNorm = .4;
% forder = 5;
% [fpiezoPos fqpdVolts] = LowPassFilter(piezoPos2,qpdVolts2,fNorm,forder);
% SaveData(fpiezoPos,fqpdVolts,dirpath,filename,'Filtered');
% 
% % plot adjusted data
linewidth = 2;
for i = 1:length(piezoPos2)
    h = PlotRawData({piezoPos2{i}},{qpdVolts2{i}},linewidth);
    PlotLegend(fname,'southwest');
    print('-djpeg',fullfile([dirpath,'Raw_' fname{i}]));
end
%saveas(h,fullfile(dirpath,'Raw_Equilibrium_Selection.fig'));

% load drift data
[t piezo driftname driftData] = LoadDriftData(dirpath);

% load frequency data
[freq sampling_f freqName] = LoadFileIndex(dirpath);


% select range for oscillations
figure; 
plot(t,piezo);
title('Select range for all oscillations','fontsize',20);
[tselect pselect] = ginput(2);
xrange = find(t > min(tselect) & t < max(tselect));
t = t(xrange);
piezo = piezo(xrange);
driftData = driftData(xrange,:);

figure; hold on; box on;
plot(t,driftData(:,2),'b');
plot(t,driftData(:,3),'r');
plot(t,driftData(:,4),'g');
legend('X','Y','Z','fontsize',25,'location','northwest');
xlabel('Time (s)','fontsize',25);
ylabel('Position (nm)','fontsize',25);
set(gca,'fontsize',20);
print('-djpeg',fullfile([dirpath,'Positions']));


figure; hold on; box on;
plot(t,driftData(:,5)-driftData(1,5),'b');
plot(t,driftData(:,6)-driftData(1,6),'r');
plot(t,driftData(:,7)-driftData(1,7),'g');
legend('X','Y','Z','fontsize',25,'location','northwest');
xlabel('Time (s)','fontsize',25);
ylabel('Piezo Volts','fontsize',25);
set(gca,'fontsize',20);
print('-djpeg',fullfile([dirpath,'Volts']));



%% Plot only raw sine wave (useful because of frequency info)

results = ParseDriftManual(dirpath);
results = [posStart posFinish amplitude frequency timeStart timeFinish];

% load and parse data
[piezoPos qpdVolts fname numData dirpath filename] = LoadParseData(dirpath);

% load file index
[freq sampling_f freqName] = LoadFileIndex(dirpath);

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
PlotLegend(freqName,'southwest');
saveIndex = FindNextFileIndex(dirpath,'Raw_Oscillations_Comparison_','jpg');
print('-djpeg',fullfile(dirpath,['Raw_Oscillations_Comparison_' num2str(saveIndex)]));
% saveas(h,fullfile(dirpath,['Raw_Oscillations_Comparison_' num2str(i) '.fig']));
        

%% Plot raw force clamps

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


%% Combine any kind combination of data

[fpiezoPos fqpdVolts name xoffset yoffset] = PlotMultipleRawData(dirpath);

close all;
linewidth = 1;
h = PlotRawData(fpiezoPos,fqpdVolts,linewidth);
PlotLegend(name,'southwest');
saveIndex = FindNextFileIndex(dirpath,'Raw_Comparison_','jpg');
print('-djpeg',fullfile(dirpath,['Raw_Comparison_' num2str(saveIndex)]));
% saveas(h,fullfile(dirpath,['Raw_Comparison_' num2str(i) '.fig']));
 



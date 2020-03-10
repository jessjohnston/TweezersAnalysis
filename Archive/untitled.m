  
%%
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
print('-djpeg',fullfile(dirpath,'Manual_Pulls'));



% [driftname,driftpath] = uigetfile(fullfile(dirpath,'*.txt'),'Select Drift file');

% load drift data
[t piezo driftname driftData] = LoadDriftData(dirpath);

time = driftData(:,1);
x = driftData(:,2);
y = driftData(:,3);
z = driftData(:,4);
figure; box on; hold on;
plot(time,z,'g');
plot(time,y,'c');
plot(time,x);
h = legend('z','y','x','location','northwest');
set(h,'fontsize',20);
xlabel('time (s)','fontsize',25);
ylabel('Equilibrium Position (nm)','fontsize',25);
set(gca,'fontsize',20);
print('-djpeg',fullfile(dirpath,'Drift_allAxis'));


% load frequency data
[freq sampling_f freqName] = LoadFileIndex(dirpath);


results = ParseDriftManual(dirpath);


%%


posStart = results(:,1); 
posFinish = results(:,2); 
amplitude = results(:,3); 
frequency = results(:,4); 
timeStart = results(:,5); 
timeFinish = results(:,6);

% load and parse data
[piezoPos qpdVolts fname numData dirpath filename] = LoadParseData(dirpath);

% adjust to equilibrium offset
[xoffset yoffset] = GetEquilibriumOffset(dirpath);
[piezoPos2 qpdVolts2] = AdjustEquilibriumPosition(piezoPos,qpdVolts,xoffset,yoffset);
SaveData(piezoPos2,qpdVolts2,dirpath,filename,'Adjusted');

% load file index
[freq sampling_f freqName] = LoadFileIndex(dirpath);


showplot = 1;
f = fittype('A*sin(2*pi*f*x+phi)+C');
adjustPos = cell(numData,1); A= [];
for i = 1:numData
    
    N = length(piezoPos2{i});
    t = (0:N-1)'/freq(i);
    pos = piezoPos2{i};

   
    figure(1); clf; hold on;
    plot(t,pos);
    
    if posStart(i) == 0 & posFinish(i) == 0
        drift = 0;
    else
        A0 = (max(pos)-min(pos));
        f0 = freq(i);
        C0 = mean(pos);
        phi0 = -pi;
        [c gof] = fit(t,pos,f,'startpoint',[A0 C0 f0 phi0]);
        A = [A; c.A];
        scale = amplitude(i)/c.A
        plot(t,c(t),'r');
        
        drift = posStart(i):(posFinish(i)-posStart(i))/(N-1):posFinish(i);
    end
    
    adjustPos{i} = pos - drift';
    plot(t,adjustPos{i},'g');
end

adjustPos2 = {};
for i = 1:numData
    posOffset = adjustPos{i}(1) - adjustPos{1}(1);
    adjustPos2{i} = adjustPos{i} - posOffset;
end

% scale may be off by 1.5: A*1.5 = amplitude

for i = 1:length(adjustPos2)
    figure(10); clf; 
    subplot(2,1,1); plot(adjustPos2{i});
    axis tight;
    title('Adjusted Positions','fontsize',25);
    subplot(2,1,2); plot(qpdVolts2{i});
    title('QPD','fontsize',25);
    axis tight;
    print('-djpeg',fullfile(dirpath,[fname{i} '_Raw_timeseries']));
end

%%

% low pass filter data
fNorm = .05;
forder = 5;
[fpiezoPos fqpdVolts] = LowPassFilter(adjustPos2,qpdVolts2,fNorm,forder);
SaveData(fpiezoPos,fqpdVolts,dirpath,filename,'Filtered2');

% plot all adjusted data
linewidth = 2;
h = PlotRawData(fpiezoPos,fqpdVolts,linewidth);
PlotLegend(freqName,'southwest');
saveIndex = FindNextFileIndex(dirpath,'Raw_Oscillations_Corrected_','jpg');
print('-djpeg',fullfile(dirpath,['Raw_Oscillations_Corrected_' num2str(saveIndex)]));
       

% low pass filter data
fNorm = .05;
forder = 5;
[fpiezoPos fqpdVolts] = LowPassFilter(piezoPos2,qpdVolts2,fNorm,forder);
SaveData(fpiezoPos,fqpdVolts,dirpath,filename,'Filtered');

% plot all adjusted data
linewidth = 2;
h = PlotRawData(fpiezoPos,fqpdVolts,linewidth);
PlotLegend(freqName,'southwest');
saveIndex = FindNextFileIndex(dirpath,'Raw_Oscillations_Comparison_','jpg');
print('-djpeg',fullfile(dirpath,['Raw_Oscillations_Comparison_' num2str(saveIndex)]));
% saveas(h,fullfile(dirpath,['Raw_Oscillations_Comparison_' num2str(i) '.fig']));


%% Combine any kind combination of data

[fpiezoPos fqpdVolts name xoffset yoffset] = PlotMultipleRawData(dirpath);

close all;
linewidth = 1;
h = PlotRawData(fpiezoPos,fqpdVolts,linewidth);
PlotLegend(name,'southwest');
saveIndex = FindNextFileIndex(dirpath,'Raw_Comparison_','jpg');
print('-djpeg',fullfile(dirpath,['Raw_Comparison_' num2str(saveIndex)]));
% saveas(h,fullfile(dirpath,['Raw_Comparison_' num2str(i) '.fig']));
 

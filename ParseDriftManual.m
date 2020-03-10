function results = ParseDriftManual(dirpath)

% load drift data
[t piezo driftname driftData] = LoadDriftData(dirpath);

% load frequency data
[freq sampling_f freqName] = LoadFileIndex(dirpath);


figure; box on; hold on;
plot(t,driftData(:,2),'b');
plot(t,driftData(:,3),'r');
plot(t,driftData(:,4),'g');
xlabel('Time (s)','fontsize',25);
ylabel('Positions (nm)','fontsize',25);
legend('X','Y','Z','fontsize',18);
set(gca,'fontsize',18);
axis tight
print('-djpeg',fullfile(dirpath,'Drift_Positions'));

figure; box on; hold on;
plot(t,driftData(:,5)-driftData(1,5),'b');
plot(t,driftData(:,6)-driftData(1,6),'r');
plot(t,driftData(:,7)-driftData(1,7),'g');
xlabel('Time (s)','fontsize',25);
ylabel('Piezo Voltage','fontsize',25);
legend('X','Y','Z','fontsize',18);
set(gca,'fontsize',18);
axis tight
print('-djpeg',fullfile(dirpath,'Drift_Volts'));


% select range for oscillations
figure; 
plot(t,piezo);
title('Select range for all oscillations','fontsize',20);
[tselect pselect] = ginput(2);
xrange = find(t > min(tselect) & t < max(tselect));
t = t(xrange);
piezo = piezo(xrange);
startIndex = find(t > min(tselect),1,'first');

close all;
clc;
numData = length(freq);
for i = 1:numData
    disp([num2str(i) '. ' num2str(freq(i)) ' Hz']);
end

% manually select individual oscillations
figure('position',[0 0 1000 350]); hold on;
plot(t,piezo);
time = cell(numData,1);
piezoPos = cell(numData,1); 
for k = 1:numData
    prompt = ['Please select oscillation ' num2str(k) ' out of ' num2str(numData)];
    disp(prompt);    
    title(prompt,'fontsize',20);
    
    [tselect pselect button] = ginput(2);
    [MIN index1] = min((t - min(tselect)).^2);
    [MIN index2] = min((t - max(tselect)).^2);
    xrange = index1:index2;
    time{k} = t(xrange);
    piezoPos{k} = piezo(xrange); 
    plot(time{k},piezoPos{k},'r');
end
print('-djpeg',fullfile(dirpath,'DriftSelection'));
  
% fit all regions
timeStart = [];
timeFinish = [];
posStart = [];
posFinish = [];
for k = 1:numData
    t = time{k};
    pos = piezoPos{k};
    posStart = [posStart; pos(1)];
    posFinish = [posFinish; pos(end)];
    timeStart = [timeStart; t(1)];
    timeFinish = [timeFinish; t(end)];
end

results = [posStart posFinish timeStart timeFinish];


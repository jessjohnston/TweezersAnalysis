function dispslope = FitDisplacementSlope(dirpath)


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
plot(x,qpd); 
[x2 y2] = ginput(2);

range = find(x > min(x2) & x < max(x2)); 

x = x(range);
qpd = qpd(range);

f = fittype('a*x+b');
[c gof] = fit(x,qpd,f,'startpoint',[-1 0]);

plot(x,c(x),'r');
title(['Displacement Slope = ' num2str(abs(c.a))]);
xlabel('strain position');
ylabel('qpd');
print('-djpeg',fullfile(dirpath,strcat(fname,'_Fit')));

dispslope = abs(c.a);
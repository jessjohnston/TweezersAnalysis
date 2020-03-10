function  [x2 y2] = LowPassFilter(x,y,freq)   

% setup filter 
fNorm = .05;
order = 5;
[b,a] = butter(order, fNorm, 'low');                                                           

 numData = length(x);
x2 = cell(numData,1);
y2 = cell(numData,1);
for i = 1:numData
    if freq < .1
        x2{i} = filtfilt(b, a, x{i});                                                           
        y2{i} = filtfilt(b, a, y{i});  
    else
        x2{i} = x{i};
        y2{i} = y{i};
    end
end


function  [x2 y2] = AAFilter(x,y)   

% setup filter 
fNorm = 0.99;
order = 2;
[b,a] = butter(order, fNorm, 'low');                                                           
% fvtool(b,a)
% x2 = filter(b,a,x);
% y2 = filter(b,a,y);
 numData = length(x);
x2 = cell(numData,1);
y2 = cell(numData,1);
for i = 1:numData
%     if freq < .1
        x2{i} = filtfilt(b, a, x{i});                                                           
        y2{i} = filtfilt(b, a, y{i});  
%     else
%         x2{i} = x{i};
%         y2{i} = y{i};
%     end
end


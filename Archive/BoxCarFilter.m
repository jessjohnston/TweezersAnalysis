function  [x2 y2] = BoxCarFilter(x,y)   

maxData = 2000;
numReps = length(x);

x2 = cell(numReps,1);
y2 = cell(numReps,1);
for i = 1:numReps
    numData = length(x{i});
    if numData > maxData
        stepsize = floor(numData/maxData);
        tmpx = []; tmpy = [];
        for j = 1:maxData
            range = j*stepsize-stepsize+1:j*stepsize;
            tmpx = [tmpx; mean(x{i}(range))];                                                           
            tmpy = [tmpy; mean(y{i}(range))];  
        end
        x2{i} = tmpx;
        y2{i} = tmpy;
    else
        x2{i} = x{i};
        y2{i} = y{i};
    end
end



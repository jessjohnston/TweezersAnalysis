function  [piezoPos2 qpdVolts2 xoffset yoffset] = AdjustEquilibriumPosition(piezoPos,qpdVolts,xoffset,yoffset)

% save offset and ask user if they want to use old value or make new value

if nargin == 2
    % find offset
    linewidth = 1;
    PlotRawData(piezoPos,qpdVolts,linewidth);
    [xoffset yoffset] = ginput(1);
end
 
piezoPos2 = {}; qpdVolts2 = {};
numData = length(piezoPos);
for i = 1:numData
    piezoPos2{i} = piezoPos{i} - xoffset;
    qpdVolts2{i} = qpdVolts{i} - yoffset;
end
    



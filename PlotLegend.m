function  PlotLegend(fname,location)
    
if nargin < 1
    fname = {};
    location = 'Northeast';
end
    
numData = length(fname);
legendname = 'legend(';
for i = 1:numData
    if isempty(fname)
        legendname = [legendname '''' num2str(i) ''','];
    else        
        legendname = [legendname '''' fname{i} ''','];
    end
end
legendname = [legendname(1:end-1) ',''Location'',''' location ''');'];
eval(legendname);
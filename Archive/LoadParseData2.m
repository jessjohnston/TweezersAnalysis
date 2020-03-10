function [piezoPos qpdVolts fname numData dirpath filename] = LoadParseData2(dirpath)
 
if nargin ~= 2
    [filename dirpath] = uigetfile(fullfile(dirpath,'*.txt'),'Select a file','MultiSelect','on');
    if ~iscell(filename)
        tmp = filename; clear filename;
        filename{1} = tmp;
    end
end
numData = length(filename);

fname = {};
piezoPos = {}; 
qpdVolts = {};
for i = 1:numData
    [tmp fname{i}] = fileparts(filename{i});
    fname{i}(find(fname{i}=='_'))=' ';
    data = dlmread(fullfile(dirpath,filename{i}));
    piezoPos{i} = data(:,1);
    qpdVolts{i} = data(:,2);
end
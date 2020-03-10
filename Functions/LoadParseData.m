function [piezoPos qpdVolts fname numData dirpath filename] = LoadParseData(dirpath,filename)
 
strain2nm = 1415;

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
    
    if size(data,2) == 5  % oscillation data
        % piezo Position = 1, qpd_z = 2, qpd_x = 3, qpd_y = 4, straingauge = 5
        piezoPos{i} = data(:,5)*strain2nm;
        qpdVolts{i} = data(:,3);
        
    else   % Manual pull or force clamp data
        % strain gauge = 1, qpd = 2
        piezoPos{i} = data(:,1)*strain2nm;
        qpdVolts{i} = data(:,2);
    end
end

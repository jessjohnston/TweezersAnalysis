function [t piezo driftname driftData] = LoadDriftData(dirpath)

% get folder name
tmp = dirpath;
fname = [];
while isempty(fname)
    [tmp fname] = fileparts(tmp);
end
driftpath = fullfile(tmp,'Drift');

% get drift file that corresponds to folder name
dirlist = dir(driftpath);
for i = 3:length(dirlist)
    name = dirlist(i).name;
    if length(name) > length(fname)
        if strcmp(fname,name(1:length(fname)))
            driftname = dirlist(i).name;
            break;
        end
    end
end


% load drift data
if length(driftname) > 1
    driftData = dlmread(fullfile(driftpath,driftname));
    t = driftData(:,1);
    piezo = driftData(:,2);
else
    disp([ fname ' drift file does not exist']);
    driftname = [];
    t = [];
    piezo = [];
    driftData = [];
end
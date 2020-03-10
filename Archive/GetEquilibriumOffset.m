function [xoffset yoffset] = GetEquilibriumOffset(dirpath)

if ~exist(fullfile(dirpath,'EquilibriumOffset.txt'),'file')
    xoffset = 0;
    yoffset = 0;
else
    data = dlmread(fullfile(dirpath,'EquilibriumOffset.txt'));
    xoffset = data(1);
    yoffset = data(2);
end
function [f sampling_f freqName] = LoadFileIndex(dirpath)

if nargin < 1
    [filename dirpath] = uigetfile(fullfile(dirpath,'*.txt'),'Select position file');
else
    filename = 'FileIndex.txt';
end


fid = fopen(fullfile(dirpath,filename));
data = textscan(fid,'%s %f %f');
fclose(fid);

freqName = data{1};
f = data{2};
sampling_f = data{3};
% 
% data = importdata(fullfile(dirpath,filename));
% f = data.data(:,1);
% sampling_f = data.data(:,2);
% 
% freqName = {};
% for i = 1:length(f)
%     freqName{i} = num2str(f(i));
% end
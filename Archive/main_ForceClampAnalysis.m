clear all;
close all;
clc;

dirpath = fileparts(pwd);

%% Analyze Force Clamp

% select file and load data
[filename dirpath] = uigetfile(fullfile(dirpath,'*.txt'),'Please select a file');
data = dlmread(fullfile(dirpath,filename));

extension = data(:,1);
force = data(:,2);

% plot time series

% select interesting region

% fit decay 

% 



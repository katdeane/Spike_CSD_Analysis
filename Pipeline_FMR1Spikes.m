%% Pipeline for spike analysis
% The intention here is to get very basic spike visualization and to run
% Spike LFP coherence analysis. Short and simple

clear; clc;

if exist(fullfile('D:', 'Spike_CSD_Analysis'),'dir')
    home_dir = 'D:\Spike_CSD_Analysis';
elseif exist(fullfile('/', 'Users', 'carolinejia', 'Documents', 'GitHub', 'CSHL_GroupProject2'), 'dir')
    home_dir = fullfile('/Users', 'carolinejia', 'Documents', 'CSHL_GroupProject2');
else
    error('Add your directory to this list (or rewrite this if there is a better way) - Kat')
end

addpath(genpath(home_dir));

% basic variables
Group = {'MKO'};
Condition = {'NoiseBurst','ClickTrain'};

%% Single animal data sorting 

% data comes from get_spikes_script.py which uses the .spikes datatype from
% Videre "offline spike sorting" after filtering in Curate with bandpass =
% 300 - 5000 Hz 
DynamicSpikes(home_dir, Group, Condition)

%% Spike-LFP Coherence

% I am basing the following analysis on this resource:
% https://mark-kramer.github.io/Case-Studies-Python/11.html






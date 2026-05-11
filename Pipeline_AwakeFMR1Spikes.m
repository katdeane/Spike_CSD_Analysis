%% Pipeline for spike analysis
% The intention here is to get very basic spike visualization and to run
% Spike LFP coherence analysis. Short and simple

clear; clc;

if exist(fullfile('D:', 'Spike_CSD_Analysis'),'dir')
    homedir = 'D:\Spike_CSD_Analysis';
elseif exist(fullfile('/', 'Users', 'carolinejia', 'Documents', 'GitHub', 'CSHL_GroupProject2'), 'dir')
    homedir = fullfile('/Users', 'carolinejia', 'Documents', 'CSHL_GroupProject2');
else
    error('Add your directory to this list (or rewrite this if there is a better way) - Kat')
end

addpath(genpath(homedir));
set(0, 'DefaultFigureRenderer', 'painters');
cd(homedir)

% basic variables
Group = {'AWT','AKO'};
% Condition = {'ClickTrain','gapASSR'};
Condition = {'NoiseBurst','ClickTrain','Spontaneous','gapASSR','Chirp'};

%% Single animal data sorting 

% data comes from get_spikes_script.py which uses the .spikes datatype from
% Videre "offline spike sorting" after filtering in Curate with bandpass =
% 300 - 5000 Hz 
DynamicSpikes(homedir, Group, Condition,'Awake')

%% single subject visualization

% Group_single_raster(homedir, 'MWT', 'NoiseBurst', '70 dB', 'IV', 4)
% Group_single_raster(homedir, 'MWT', 'ClickTrain', '5Hz', 'IV', 4)
% Group_single_raster(homedir, 'MKO', 'NoiseBurst', '70 dB', 'IV', 4)
% Group_single_raster(homedir, 'MKO', 'ClickTrain', '5Hz', 'IV', 4)

%% Group PSTH
% yes you do have to run this, it normalizes the data to channel number per
% layer
Group_Avg_raster(homedir, Group, Condition, 'Awake')

%% Detect up-states in spontaneous data 
% the dream

%% Get spike data for comparison
% spike mean firing rate, fano factor, spike count/rate after stim onset.
% Subject data was already pulled from Group_Avg_raster 
SpikeStats(homedir,'AWT','AKO')
SpikeFigsCut(homedir,'AWT','AKO')

%% The dream... Spike-LFP Coherence

% I am basing the following analysis on this resource:
% https://mark-kramer.github.io/Case-Studies-Python/11.html






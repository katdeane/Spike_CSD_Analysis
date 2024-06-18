%% Pipeline for spike analysis
% The intention here is to get very basic spike visualization and to run
% Spike LFP coherence analysis. Short and simple

clear; clc;

% set working directory; change for your station
if exist('D:\Spike_CSD_Analysis','dir')
    cd('D:\Spike_CSD_Analysis');
else
    error('add your local repository as shown above')
end
homedir = pwd;
addpath(genpath(homedir));

% basic variables
Group = {'MWT','MKO'};
Condition = {'NoiseBurst','ClickTrain'};

%% Single animal data sorting 

% data comes from get_spikes_script.py which uses the .spikes datatype from
% Videre "offline spike sorting" after filtering in Curate with bandpass =
% 300 - 5000 Hz 
DynamicSpikes(homedir, Group, Condition)

%% Spike-LFP Coherence

% I am basing the following analysis on this resource:
% https://mark-kramer.github.io/Case-Studies-Python/11.html






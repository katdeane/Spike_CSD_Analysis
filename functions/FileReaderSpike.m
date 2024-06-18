function [timerange,stimIn] = FileReaderSpike(file)
% This converts the data from allego/curate and downsamples it to fs = 1000

% initalized NeuroNexus conversion function
reader = allegoXDatFileReaderR2019b;

timerange = reader.getAllegoXDatTimeRange(file);
signalStruct = reader.getAllegoXDatAllSigs(file, timerange);
% stimulus timing data
stimIn = downsample(signalStruct.signals(33,:),30); % microvolts



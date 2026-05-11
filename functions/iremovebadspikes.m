function iremovebadspikes(homedir,ntvIdxs)

% spikes that were noted to have a consistent firing rate but a bad shape
% according to the researcher who ran files through Videre. This is a list
% of spike locations to remove from each individual measurement according
% to spike sorting.

% Katrina's note: the ntvIdxs don't provide the second column of
% information right now (spikes are sometimes seperated into 1 or 2 per
% channel) so we can't be exact. This is likely fixable through the python
% script... maybe one day....

% MKO
badspk.MKO02 = [06 20 1; 07 23 1];

badspk.MKO02 = [8  1];
badspk.MKO02_11 = [6  1];
badspk.MKO02_12 = [5  1];
badspk.MKO03_06 = [9  1; 4  1];
badspk.MKO03_08 = [3  1; 16 1; 17 1; 18 1; 15 1];
badspk.MKO03_09 = [3  1; 16 1; 17 1; 18 1; 15 1];
badspk.MKO03_10 = [3  1; 16 1; 17 1; 18 1; 15 1];


% MWT
badspk.MWT02_11 = [12 1];


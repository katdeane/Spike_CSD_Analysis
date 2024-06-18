function [correctedSpike] = threeSPround(thisSpike)
% rounding to 3 sp/ms

% reduce noise
floorSpike = floor(thisSpike);
workingSpike = thisSpike - floorSpike;

% 3 sampling points in 1 ms means 1, 1.33.., 1.66.., 2, etc. 
roundthreshold = 0.33333333 / 2; 

if workingSpike < roundthreshold 
    workingSpike = 0;
elseif workingSpike > roundthreshold && workingSpike < (roundthreshold*2)
    workingSpike = 0.3333333333;
elseif workingSpike > (roundthreshold*2)
    workingSpike = 0.66666667;
else
    workingSpike = 1;
end

correctedSpike = workingSpike + floorSpike;
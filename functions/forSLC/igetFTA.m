function [FTA, phi_axis] = igetFTA(LFPchan,SPKchan,timeaxis,Wn)

ntrials = size(LFPchan,2); % number of trials

ord = 100;    % filter order
NQ = fs/2;    % NyQuist frequency
Wn = Wn/NQ;   % NyQuist normalized frequency cutoffs

% create a bandpassed filter with a hamming window
[bpfilt, bpvec] = fir1(ord,Wn,'bandpass');

% create container
FTA = zeros(ntrials,timeaxis);
% fill container
for itri = 1:ntrials
    Vlo = filtfilt(bpfilt,bpvec,LFPchan(:,itri)); % apply filter
    phi = angle(hilbert(Vlo));                    % compute phase
    [~,indices] = sort(phi);                      % get inices of sorted phase
    FTA(itri,:) = SPKchan(indices,itri);          % store sorted spikes
end

phi_axis = linspace(-pi,pi,timeaxis);
FTA = mean(FTA,1);

%Plot the average FTA versus phase.
plot(FTA)
xticks([1 500 1000 1500])
xticklabels([phi_axis(1) phi_axis(500) phi_axis(1000) phi_axis(1500)])
title('Field Triggered Average')
ylabel('Average spikes')
xlabel(['Phase of LFP ' num2str(Wn)])

% save fig for review
cd(homedir); cd figures; cd Spikes_LFP_visualization
h = gcf;
savefig(h,[subname ' ' Condition ' Field Triggered Average ' Lay],'compact')
close (h)
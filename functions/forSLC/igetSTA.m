function STA = igetSTA(win,LFPchan,SPKchan,subname,Condition,Lay)

ntrials = size(LFPchan,2); % number of trials
npoints = size(LFPchan,1); % number of data points in each trial

% container for STA
STA = zeros((2*win)+1,ntrials); % window before and after spike plus time point of spike

% fill the container
for itri = 1:ntrials
    
    % find the spike times per trial
    spiketimes = find(SPKchan(:,itri)>0);

    if isempty(spiketimes)
        continue % no spikes to see here, keep it moving
    end
   
    counter = 0;
    for ispi = 1:length(spiketimes)
        if win < spiketimes(ispi) && spiketimes(ispi) < npoints-win-1
            STA(:,itri) = STA(:,itri) + ...
                LFPchan(spiketimes(ispi)-win:spiketimes(ispi)+win,itri);
            counter = counter + 1;
        end
    end

    % averaging the LFP around spikes across whole channel
    STA(:,itri) = STA(:,itri) / counter; 

end

figure;
plot(STA)
xlim([0 (2*win)+1])
xticklabels([-100 -80 -60 -40 -20 0 20 40 60 80 100])
title('Spike Triggered Average')
ylabel('LFP [mV]')
xlabel('Time [ms] - Spike at 0')

% save fig for review
cd(homedir); cd figures; cd Spikes_LFP_visualization
h = gcf;
savefig(h,[subname ' ' Condition ' Spike Triggered Average ' Lay],'compact')
close (h)

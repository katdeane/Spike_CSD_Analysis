function Group_Avg_raster(homedir, Group, Condition,type)

layers = {'II' 'IV' 'Va' 'Vb' 'VI'};

for iGro = 1:length(Group)

    spikeT = struct;
    count  = 1; 

    run([Group{iGro} '.m']) % brings in Layer channels animals Cond
    clear channels

    for iCond = 1:length(Condition)

        [stimList, thisUnit, stimDur, stimITI, ~] = ...
            StimVariable(Condition{iCond},1,type);
        
        if matches(Condition{iCond},'Spontaneous')
            timeaxis = stimDur + stimITI;
        else
            timeaxis = 400 + stimDur + stimITI;
        end

        for iLay = 1:length(layers)+1

            if iLay == length(layers)+1
                layname = 'All';
            else
                layname = layers{iLay};
            end

            PSTHfig = tiledlayout('flow');
                title(PSTHfig,[Group{iGro} ' ' Condition{iCond} ' PSTH Layer ' layname])

            xlabel(PSTHfig, 'time [ms]')
            ylabel(PSTHfig, 'average normalized spike count')

            for istim = 1:length(stimList)

                groupsum    = zeros(1,timeaxis);
                numsubjects = length(animals);

                for iSub = 1:length(animals)
                    disp(['For ' Condition{iCond} ' ' layname ' ' num2str(stimList(istim)) ' ' animals{iSub}])
                    % subject data
                    load([animals{iSub} '_SpikeData.mat'],'SpikeData')
                    % subject data index
                    index = StimIndex({SpikeData.Condition},Cond,iSub,Condition{iCond});
                    if isempty(index)
                        numsubjects = numsubjects - 1;
                        continue
                    end
                    % pull appropriate data
                    thisdat = SpikeData(index).SortedSpikes{istim};

                    % get subject average spike data
                    trlsum = sum(thisdat,3);
                    if iLay == length(layers)+1 % all channels
                        thislay = 1:size(trlsum,1);
                    else % layer channels
                        thislay = str2num(Layer.(layname){iSub});
                    end
                    layersum  = sum(trlsum(thislay,:),1); 
                    % normalize by number of channels
                    layersum  = layersum / length(thislay);

                    % add to group sum for later averaging of group
                    groupsum = groupsum + layersum;

                    % fill a struct for now (table later)
                    spikeT(count).group      = Group{iGro};
                    spikeT(count).condition  = Condition{iCond};
                    spikeT(count).layer      = layname;
                    spikeT(count).stimulus   = stimList(istim);
                    spikeT(count).subject    = animals{iSub};

                    % now get some variables while we're here
                    % get spiking rate per second
                    [spikeT(count).trlspikerate,spikeT(count).avgspikerate,...
                        spikeT(count).trlspikecount, spikeT(count).avgspikecount,...
                        spikeT(count).trlPREcount,spikeT(count).trlONSETcount,...
                        spikeT(count).trlPOSTcount,spikeT(count).avgPREcount,...
                        spikeT(count).avgONSETcount,spikeT(count).avgPOSTcount,...
                        spikeT(count).Fanofactor,spikeT(count).FanoPRE,...
                        spikeT(count).FanoONSET,spikeT(count).FanoPOST] = ...
                        spikeDetection(thisdat(thislay,:,:),Condition{iCond});
                    count = count + 1;
                end % subject

                groupsum = groupsum ./ numsubjects;

                % now add the tile
                nexttile
                bar(groupsum,2,'histc')
                title([num2str(stimList(istim)) thisUnit])
                xlim([0 length(layersum)])
                xticks(0:200:length(layersum))
                labellist = xticks;
                xticklabels(labellist)


            end % stim

            cd(homedir); cd figures
            if ~exist('GroupPSTH','dir')
                mkdir('GroupPSTH')
            end
            cd GroupPSTH

            h = gcf;
            if iLay == length(layers)+1
                savefig(h,[Group{iGro} '_' Condition{iCond} '_NormPSTH_AllChan'],'compact')
            else
                savefig(h,[Group{iGro} '_' Condition{iCond}  '_NormPSTH_Lay' layname],'compact')
            end
            close (h)
        end % layer
    end % condition

    cd(homedir); cd output
    if ~exist('SpikeDetection','dir')
        mkdir('SpikeDetection')
    end
    cd SpikeDetection
    save([Group{iGro} '_Normspikedetection'],'spikeT')
end % group
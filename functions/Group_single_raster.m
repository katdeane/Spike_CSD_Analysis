function Group_single_raster(homedir, Group, Condition, whichstim, Lay,ncolumn)

% figure order matters here
close all

run([Group '.m'])
subjects = length(animals);
nrows = ceil(subjects/ncolumn); % four columns
if matches(Condition,'NoiseBurst')
    thisstim = 90 - str2num(whichstim(1:2));
    thisstim = (thisstim/10) + 1;
elseif matches(Condition,'ClickTrain')
    if matches(whichstim,'5Hz')
        thisstim = 7;
    end
end

cd(homedir); cd figures; cd(['Single_' Group])

figure(1)
targetfig = tiledlayout(nrows,ncolumn);
title(targetfig,['Individual ' Group ' ' Condition ' ' whichstim])
xlabel(targetfig, 'time [ms]')
ylabel(targetfig, 'depth [channels]')
colormap jet

for iA = 1:subjects

    name = animals{iA}; %#ok<*IDISVAR>
    % this will ALWAYS take just the first measurment for the subject if
    % there are multiple
    measurement = Cond.(Condition){iA}{1};
    if isempty(measurement)
        continue
    end

    % open the figure and scoop the contents
    openfig([name '_' Condition '_PSTH_Lay' Lay '.fig']);
    pause(1)
    h = gca;
    handles = h.Parent.Children(thisstim).Children;
    data_y = handles.YData(2,:);
    data_x = handles.XData(1,:);

    figure(1); nexttile(iA)
    bar(data_x,data_y,30,'histc')
    title(name)
    xticks(     [400 600 800 1000 1200 1400 2400])
    xticklabels([0   200 400 600  800  1000 2000])
    ylim([0 0.03])
     
    figure(2)
    close
    clear handles data_y data_x
end

% final asthetics
axes(targetfig,'visible','off');
set(gcf,'Position',[100 100 850 550])

savefig(gcf,['Single_' Group '_' Condition '_' Lay])
exportgraphics(targetfig,['Single_' Group '_' Condition '_' Lay '.png'])
close; cd(homedir)
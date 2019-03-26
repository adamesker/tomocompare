clear;clc;close all;

%interactively compares thresholds in tomocompare

%sign for velocity model? pos=1 neg=0
sign = 1;
%percentile
perc=30;
%latcurve
latCurve=35;
load('dataP.mat');

while(1)
    k=0;
    [selCord,files] = tomocomparef(data,sign,perc,latCurve);
    numfiles = size(selCord,2)-6;
    
    
%     %plots data extent and cross section on map of murica
%     figure;
%     ax = usamap('conus');
%     set(ax, 'Visible', 'off');
%     states = shaperead('usastatelo','UseGeoCoords',true);
%     geoshow(ax, states, 'DisplayType', 'polygon');
%     %plotm(cord(:,3),cord(:,4),'b.');
%     hold on;
%     plotm(selCord(:,3),selCord(:,4),'r.');
%     
    figure;
    colormap('jet');
    %combined plot
    subplot(numfiles+1,1,1);
    scatter(selCord(:,4),selCord(:,5),[],selCord(:,6),'filled');
    set(gca, 'YDir', 'reverse','Color','k');
    axis tight;
    title('combined plot');
    
    
    %plots each model
    for i=2:numfiles+1
        subplot(numfiles+1,1,i);
        scatter(selCord(:,4),selCord(:,5),[],selCord(:,i+5),'filled');
        set(gca, 'YDir', 'reverse','Color','k');
        axis tight;
        title(files(i-1).name);
    end

    %get(gcf);
    set(gcf,'Position',[-1196 -717 1195 1822]);
    
    while(~k)
        k = waitforbuttonpress;
    end
    
    %28 left 29 right 30 up 31 down
    val = double(get(gcf,'CurrentCharacter'));
    if val == 28 & perc ~= 0 %up
        perc = perc - 10;
    elseif val == 29 & perc ~= 100 %down
        perc = perc + 10;
    elseif val == 30 & latCurve ~= 0 %left
        latCurve = latCurve + 5;
    elseif val == 31 & latCurve ~= 80 %right
        latCurve = latCurve - 5;
    end
    fprintf('perc = %f latCurve = %f \n',perc,latCurve);
    %close all;
end

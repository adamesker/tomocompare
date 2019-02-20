clear;clc;close all;

%plots different thresholds on one figure

%sign for velocity model? pos=1 neg=0
sign = 1;
%percentile
perc=0;
%latcurve
latCurve=35;
load('dataP.mat');

%plots data extent and cross section on map of murica
% figure;
% ax = usamap('conus');
% set(ax, 'Visible', 'off');
% states = shaperead('usastatelo','UseGeoCoords',true);
% geoshow(ax, states, 'DisplayType', 'polygon');
% %plotm(cord(:,3),cord(:,4),'b.');
% hold on;
% plotm(selCord(:,3),selCord(:,4),'r.');

figure;
colormap('jet');
%combined plot
for i=1:10
    perc = (i-1)*10;
    [selCord,files] = tomocompare(data,sign,perc,latCurve);
    subplot(10,1,i);
    scatter(selCord(:,4),selCord(:,5),[],selCord(:,6),'filled');
    set(gca, 'YDir', 'reverse','Color','k');
    axis tight;
    title(['Percentile = ' num2str(perc)]);
end


%get(gcf);
set(gcf,'Position',[-1196 -717 1195 1822]);


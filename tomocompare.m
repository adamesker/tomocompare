tic;

close all; clear;
n1=80; %long 
n2=80; %lat 
n3=32; %depth

%flag determine which "latitude curve" to use. pick 1-50
latCurve = 35;
%pick waveform (P or S)
wave = 'P';
filelist = strcat('*',wave,'west.txt');
%pick percentile
perc = 30;
%flag to see pos or neg velocity comparison pos=1 neg=0
sign = 1;
%flag if you want to plot the figures
figs = 1;

%loads data
files = dir(filelist);
data = zeros(n1*n2*n3,8,length(files)); %preallocats
for i=1:length(files)
    data(:,:,i) = load (files(i).name);
end
%load('dataP.mat');

numfiles = length(files);

%putting x y index for easier cross section
xy = zeros(n1*n2*n3,2);
cnt = 1;
for i=1:n1
    for j=1:n2
        for k=1:n3
            xy(cnt,1) = j;
            xy(cnt,2) = i;
            cnt = cnt + 1;
        end
    end
end

cord = [xy(:,1),xy(:,2),data(:,4,1),data(:,5,1),round(data(:,7,1))];

%determines the percentile for each data set, at each depth
for i=1:length(files) %loops through each data set
    for j=1:n3 %loops through each depth point
        tmpvalues = data(j:n3:end,8,i);
        %gets only the positive and non null values
        if sign==1
            posvalues = tmpvalues(tmpvalues > 0 & tmpvalues ~= 1e7 & tmpvalues ~= -1e7);
            depthPerc(j,i) = prctile(posvalues,perc);
            posValsData{i,j} = posvalues;
        else
            negvalues = tmpvalues(tmpvalues < 0 & tmpvalues ~= 1e7 & tmpvalues ~= -1e7);
            depthPerc(j,i) = prctile(negvalues,perc);
            negValsData{i,j} = negvalues;
        end
    end
end

%repeats depth values like in imported data. easier to process
depthPercCat = repmat(depthPerc,n1*n2,1);
posData = zeros(n1*n2*n3,length(files));
negData = zeros(n1*n2*n3,length(files));
%0 or 1 in a new matrix if meets pos matrix
for i=1:length(files)
    tmp = data(:,8,i);
    if sign==1
        posData(:,i) = tmp>=depthPercCat(:,i) & tmp ~= 1e7;
    else
        negData(:,i) = tmp<=depthPercCat(:,i) & tmp ~= 1e7;
    end
end

%cord by column: x y lat long depth comb and then each data set pos
if sign==1
    cord = horzcat(cord,sum(posData,2),posData);
else
    cord = horzcat(cord,sum(negData,2),negData);
end
%gets selected "latitude curve"
selCord = cord(cord(:,1) == latCurve,:);

if figs == 1
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
    %set(gcf,'Position',[-1196 -717 1195 1822]);

    %plots data extent and cross section on map of murica
    figure;
    ax = usamap('conus');
    set(ax, 'Visible', 'off');
    states = shaperead('usastatelo','UseGeoCoords',true);
    geoshow(ax, states, 'DisplayType', 'polygon');
    %plotm(cord(:,3),cord(:,4),'b.');
    hold on;
    plotm(selCord(:,3),selCord(:,4),'r.');

end
toc;


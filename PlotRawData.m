function  h = PlotRawData(piezoPos,qpdVolts,linewidth)

if nargin == 2
    linewidth = 1;
end

numData = length(piezoPos);
colorSet = varycolor(numData);
h = figure('position',[0 0 1000 600]); hold on; box on;
for i = 1:numData
    plot(piezoPos{i},qpdVolts{i},'color',colorSet(i,:),'linewidth',linewidth);
end

xlabel('Piezo Position (nm)','fontsize',16);
ylabel('QPD Volts','fontsize',16);
set(gca,'fontsize',14);
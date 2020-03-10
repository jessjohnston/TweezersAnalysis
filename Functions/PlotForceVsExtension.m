function  h = PlotForceVsExtension(extension,force,linewidth)

if nargin == 2
    linewidth = 1;
end

numData = length(force);
colorSet = varycolor(numData);
h = figure; hold on; box on;
for i = 1:numData
    plot(extension{i},force{i},'color',colorSet(i,:),'linewidth',linewidth);
end

xlabel('Extension (nm)','fontsize',16);
ylabel('Force (pN)','fontsize',16);
set(gca,'fontsize',14);
function PlotIndividualData(x,y,dirpath,fname,xname,yname,type,linewidth)

if nargin < 8
    linewidth = 1;
end

numData = length(x);
for i = 1:numData
    figure(10); cla; hold on; box on;
    plot(x{i},y{i},'linewidth',linewidth);
    xlabel(xname,'fontsize',16);
    ylabel(yname,'fontsize',16);
    title(fname{i},'fontsize',16);
    set(gca,'fontsize',14);
    print('-djpeg',fullfile(dirpath,[type '_' fname{i}]));
    % saveas(h,fullfile(dirpath,['FvsX_' fname{i} '.fig']));
    
    figure(11); cla; hold on; box on;
    subplot(2,1,1); plot(x{i});
    xlabel('time','fontsize',16);
    ylabel(xname,'fontsize',16);
    subplot(2,1,2); plot(y{i});
    xlabel('time','fontsize',16);
    ylabel(yname,'fontsize',16);
    set(gca,'fontsize',14);
    print('-djpeg',fullfile(dirpath,['Raw_' type '_' fname{i}]));
    % saveas(h,fullfile(dirpath,['FvsX_' fname{i} '.fig']));
    
end


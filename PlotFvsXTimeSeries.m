function PlotFvsXTimeSeries(extension,force,samplingf,dirpath,fname,linewidth)

numData = length(extension);
for i = 1:numData
    t = 0:length(extension{i})-1; 
    t = t'/samplingf;
    
    figure; hold on; box on; 
    subplot(2,1,1); hold on; plot(t,-extension{i},'b','linewidth',linewidth); 
    xlabel('Time (s) ','fontsize',16); 
    ylabel('Extension (nm)','fontsize',16);
    set(gca,'fontsize',14);
    subplot(2,1,2); hold on; plot(t,force{i},'r','linewidth',linewidth); 
    xlabel('Time (s) ','fontsize',16); 
    ylabel('Force (pN)','fontsize',16);
    set(gca,'fontsize',14);
    print('-djpeg',fullfile(dirpath,['FvsX_' fname{i}]));


    figure; clf; hold on; box on;
    [AX,H1,H2] = plotyy(t,force{i},t,-extension{i});
    set(H2,'color','b');
    set(H1,'color','r');
    legend('Force (pN)','Extension (nm)','location','northwest')
    set(get(AX(2),'Ylabel'),'String','Extension (nm)','fontsize',16,'color','k')
    set(get(AX(1),'Ylabel'),'String','Force (pN)','fontsize',16,'color','k')
    set(get(AX(1),'Xlabel'),'String','Time (s)','fontsize',16,'color','k')
    % set(AX(2),'YTickLabel',{'-50','-40','-30','-20','-10','0','10',},...
    %     'YTick',[-50 -40 -30 -20 -10 0 10],'fontsize',14,'YColor','k');
    % set(AX(1),'YTickLabel',{'-10','-8','-6','-4','-2','0','2'},...
    %     'YTick',[-10 -8 -6 -4 -2 0 2],'fontsize',14,'YColor','k');
    % ylim(AX(2),[-37 10]);
    
    xlabel('Time (s)','FontSize',16);
    print('-djpeg',fullfile(dirpath,['FvsX_' fname{i} '_2']));

end
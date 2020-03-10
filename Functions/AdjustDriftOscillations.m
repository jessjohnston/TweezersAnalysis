function adjustPos = AdjustDriftOscillations(piezoPos2,qpdVolts2,...
    driftInfo,fname,dirpath,dirpath_fig)
close all;
% load drift data
[t piezo driftname driftData] = LoadDriftData(dirpath);

% load frequency data
[freq sampling_f freqName] = LoadFileIndex(dirpath);

posStart = driftInfo(:,1); 
posFinish = driftInfo(:,2); 
timeStart = driftInfo(:,3);
timeFinish = driftInfo(:,4);
numData = length(piezoPos2);

% adjust drift
offset = 50;
adjustPos = cell(numData,1); 
for i = 1:numData
    pos = piezoPos2{i};
    qpd = qpdVolts2{i};
    
    status = 1;
    while status == 1
        N = length(pos);
        if posStart(i) == 0 & posFinish(i) == 0
            drift = 0;
        else        
            drift = posStart(i):(posFinish(i)-posStart(i))/(N-1):posFinish(i);
        end
        adjustPos{i} = pos - pos(1) + posStart(i) - drift';    

        [a b rsqr resid] = OLS(pos-pos(1)+posStart(i),qpd);
        [a2 b2 rsqr2 resid2] = OLS(adjustPos{i},qpd);
        [a a2];

        figure('Position',[0 0 1000 600]);
        clf; 
        subplot(1,2,1); hold on; box on;
        plot(pos-pos(1)+posStart(i),qpd);
        plot(adjustPos{i},qpd,'r');
        xlabel('Piezo position (nm)','fontsize',20);
        ylabel('QPD voltage (V)','fontsize',20);
        title(['R1 = ' num2str(rsqr) '; R2 = ' num2str(rsqr2)],'fontsize',16)
        set(gca,'fontsize',16);
        
        subplot(1,2,2); hold on; box on;
        start = find(t > timeStart(i),1,'first')+1;
        finish = find(t > timeFinish(i),1,'first')-1;
        if finish+offset <= length(t)
            plot(t(start-offset:finish+offset),...
                piezo(start-offset:finish+offset));
            plot([t(start) t(start)],[min(piezo(start:finish))-10 ...
                max(piezo(start:finish))+10],'--k');
            plot([t(finish) t(finish)],[min(piezo(start:finish))-10 ...
                max(piezo(start:finish))+10],'--k');
            plot(t(start-offset:finish+offset),zeros(length(t(start-...
                offset:finish+offset)),1),'--r');
        elseif finish+offset > length(t)
            plot(t(start-offset:finish),...
                piezo(start-offset:finish));
            plot([t(start) t(start)],[min(piezo(start:finish))-10 ...
                max(piezo(start:finish))+10],'--k');
            plot([t(finish) t(finish)],[min(piezo(start:finish))-10 ...
                max(piezo(start:finish))+10],'--k');
            plot(t(start-offset:finish),zeros(length(t(start-...
                offset:finish)),1),'--r');
        end
        axis tight;
        xlabel('Time (s)','fontsize',20);
        ylabel('Drift position (nm)','fontsize',20);
        set(gca,'fontsize',16);
        title(['f = ' num2str(freq(i)) ' Hz']);
        
        suptitle('Use cursor on right plot to adjust oscillation span to maximally overlap plots on left; hit Enter when satisfied')
        
        [x1 y1 mouse] = ginput(1);
        if mouse == 1
            [x2 y2 mouse] = ginput(1);
            start = find(t > min(x1,x2),1,'first')-1;
            finish = find(t > max(x1,x2),1,'first');
            posStart(i) = piezo(start);
            posFinish(i) = piezo(finish);
            timeStart(i) = t(start);
            timeFinish(i) = t(finish);
        else
            status = 0;
        end
    end
    
    fname_s = strrep(fname,'.txt','');
    print('-dpng',fullfile(dirpath_fig,['DriftAdjusted_' fname_s{i}]));

end

results = [posStart posFinish timeStart timeFinish];
dlmwrite(fullfile(dirpath,'DriftStatistics.txt'),results,'delimiter','\t','newline','pc');


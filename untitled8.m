
[t piezo driftname driftData] = LoadDriftData(dirpath);

% load frequency data
[freq sampling_f freqName] = LoadFileIndex(dirpath);

% parse drift data
results = ParseDriftManual(dirpath);
posStart = results(:,1); 
posFinish = results(:,2); 
timeStart = results(:,3);
timeFinish = results(:,4);


%%

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
        [a a2]

        figure(1); clf; 
        subplot(2,1,1); hold on; box on;
        plot(pos-pos(1)+posStart(i),qpd);
%         if rsqr2 > rsqr
        plot(adjustPos{i},qpd,'r');
%         end
        subplot(2,1,2); hold on; box on;
        start = find(t > timeStart(i),1,'first')+1;
        finish = find(t > timeFinish(i),1,'first')-1;
        plot(t(start-offset:finish+offset),piezo(start-offset:finish+offset));
        plot([t(start) t(start)],[min(piezo(start:finish))-10 max(piezo(start:finish))+10],'--k');
        plot([t(finish) t(finish)],[min(piezo(start:finish))-10 max(piezo(start:finish))+10],'--k');
        plot(t(start-offset:finish+offset),zeros(length(t(start-offset:finish+offset)),1),'--r');
        axis tight;
        
        [x1 y1 mouse] = ginput(1);
        if mouse == 1
            [x2 y2 mouse] = ginput(1);
            start = find(t > x1,1,'first');
            finish = find(t > x2,1,'first');
            posStart(i) = piezo(start);
            posFinish(i) = piezo(finish);
            timeStart(i) = t(start);
            timeFinish(i) = t(finish);
        else
            status = 0;
        end
    end
end


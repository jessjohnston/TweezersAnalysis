

% load and parse data
[piezoPos qpdVolts fname numData dirpath filename] = LoadParseData(dirpath);
[freq sampling_f freqName] = LoadFileIndex(dirpath);

fid = fopen(fullfile(dirpath,'Fit.txt'),'a');
for i = 1:numData
    piezo = piezoPos{i}/1000;
    qpd = qpdVolts{i};

    figure(1); clf; hold on; box on;
    plot(piezo,qpd);
    title(fname{i},'fontsize',20);
    
    [x1 y1 button] = ginput(1);
    if button == 1
        [x2 y2 button] = ginput(1);
        xrange = find(piezo > min(x1,x2) & piezo < max(x1,x2));
        piezo = piezo(xrange);
        qpd = qpd(xrange);
    end
    
    [c gof] = fit(piezo,qpd,'a*x+b','startpoint',[-1 0]);
    figure(2); clf; hold on; box on;
    plot(piezo,qpd);
    plot(piezo,c(piezo),'r','linewidth',2);
    xlabel('Piezo Position','fontsize',25);
    ylabel('QPD Volts','fontsize',25);
    title(['slope = ' num2str(abs(c.a))],'fontsize',25);
    set(gca,'fontsize',20);
    print('-djpeg',fullfile(dirpath,['Fit_' fname{i}]));
   
    fprintf(fid,'%s\t%f\t%f\n',fname{i},abs(c.a),freq(i));
end
fclose(fid);

    

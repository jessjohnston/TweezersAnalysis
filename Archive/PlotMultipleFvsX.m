
function [ext F name] = PlotMultipleFvsX(dirpath)
close all;
clc;

if nargin ~= 1 
    tmp = pwd;
    dirpath = tmp(1:find(pwd == filesep,1,'last'));
end

k = 1;
status = 1;
numplots = 0;
while status == 1
    disp('');
    disp('------------------------------------------------------');
    disp('');
    reply = input(' 1. Select another file \n 2. Adjust existing plots \n 3. Remove a plot \n 4. Change names of plots \n 5. Done \n Please Select from above: ');
    if isnumeric(reply) && reply > 0 && reply < 6
        switch reply
            case 1
                filename = {};
                % load data
                [files dirpath] = uigetfile(fullfile(dirpath,'*.txt'),'Please select FvsX files','MultiSelect','On');
                if ~iscell(files)
                    filename{1} = files;
                else
                    filename = files;
                end
                
                for i = 1:length(filename)
                    numplots = numplots + 1;
                    disp(filename{i});
                    data = dlmread(fullfile(dirpath,filename{i}));
                    [pth name{numplots}] = fileparts(filename{i});
                    
                    name{numplots}(find(name{numplots}=='_'))=' ';

                    % parse data
                    ext{numplots} = data(:,1);
                    F{numplots} = data(:,2);

                end
                % plot force vs extension
                close all; figure(1); 
                FvsXPlotMultiple(ext,F,numplots,name);    
            case 2
                clc;

                legendname = '';
                for i = 1:numplots
                    legendname = strcat(legendname,int2str(i),'. ', name{i},'\n');
                end
                plotindex = input(strcat(legendname,'Please select which one you would like to adjust: '));

                if isnumeric(plotindex) && plotindex > 0 && plotindex < numplots+1
                    
                    close all; figure(1); 
                    FvsXPlotMultiple(ext,F,numplots,name);

                    % get user to select plotting range
                    STR = {'Use mouse to click on the start and end position of desired shift'};
                    hcap = axes('Position',[0 0 1 1],'Visible','off');
                    set(gcf,'CurrentAxes',hcap);
                    text(.15,0.2,STR,'FontUnits','normalized','FontSize',0.035);
                    [x y] = ginput(2);
                    ext{plotindex} = ext{plotindex} + x(2)- x(1);
                    F{plotindex} = F{plotindex} + y(2) - y(1);

                    % plot force vs extension
                    close all; figure(1); 
                    FvsXPlotMultiple(ext,F,numplots,name);
                else
                    disp('Invalid input idiot!');
                end
            case 3
                clc;
                if numplots > 1

                    legendname = '';
                    for i = 1:numplots
                        legendname = strcat(legendname,int2str(i),'. ', name{i},'\n');
                    end
                    plotindex = input(strcat(legendname,'Please select which one you would like to remove: '));

                    
                    if isnumeric(plotindex) && plotindex > 0 && plotindex < numplots+1
                        
                        index = 1;
                        for i = 1:numplots
                            if i ~= plotindex
                                tmpext{index} = ext{i};
                                tmpF{index} = F{i};
                                tmpname{index} = name{i};
                                index = index + 1;
                            end
                        end
                        ext = tmpext;
                        F = tmpF;
                        name = tmpname;
                        numplots = numplots - 1;
                        
                        % plot force vs extension
                        close all; figure(1); 
                        FvsXPlotMultiple(ext,F,numplots,name);
                    end
                else
                    disp('There are no plots, idiot!');
                end
                
            case 4
                name = ChangeNames(name);
                close all; figure(1); 
                FvsXPlotMultiple(ext,F,numplots,name);
            case 5
                status = 0;
            otherwise 
                display('invalid input, idiot');
        end
        
    else
        disp('Invalid input idiot!');
    end
    k = k + 1;
end
    

end % end of function


function legendname = FvsXPlotMultiple(ext,F,numplots,name)

colorSet = varycolor(numplots);
legendname = '';
hold on;
for i = 1:numplots
    plot(ext{i},F{i},'color',colorSet(i,:)); 
    legendname = strcat(legendname,'''',name{i},'''',',');
end
xlabel('Extension (nm)','fontsize',16);
ylabel('Force (pN)','fontsize',16);
title('Force vs Extension','fontsize',16);
set(gca,'fontsize',14);
eval(strcat('legend(',legendname(1:end-1),');'));
legend('location','northwest');
end


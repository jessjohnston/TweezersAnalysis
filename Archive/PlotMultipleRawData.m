
function [piezoPos qpdVolts name xoffset yoffset] = PlotMultipleRawData(dirpath)
close all;
clc;

if nargin < 1
    tmp = pwd;
    dirpath = tmp(1:find(pwd == filesep,1,'last'));
end

if exist(fullfile(dirpath,'EquilibriumOffset.txt'),'file')
    [xoffset yoffset] = GetEquilibriumOffset(dirpath);
else
    xoffset = 0;
    yoffset = 0;
end

k = 1;
status = 1;
numplots = 0;
piezoPos = {}; qpdVolts = {}; name = {};
while status == 1
    clc;
    disp('');
    disp('------------------------------------------------------');
    disp('');
    reply = input(' 1. Select Manual file \n 2. Select Oscillations \n 3. Remove a plot \n 4. Select a new offset \n 5. Change names of plots \n 6. Done \n Please Select from above: ');
    if isnumeric(reply) && reply > 0 && reply < 7
        switch reply
            case 1

                % load and parse data
                [newpiezoPos newqpdVolts newfname numNew] = LoadParseData2(dirpath);
                
                for i = 1:numNew
                    numplots = numplots + 1;
                    name{numplots} = newfname{i};
                    piezoPos{numplots} = newpiezoPos{i};
                    qpdVolts{numplots} = newqpdVolts{i};
                end
                

                % plot data
                close all; figure; hold on; box on;
                h = PlotRawData(piezoPos,qpdVolts,1);
                PlotLegend(name,'southwest');   
                
            case 2

                % load and parse data
                [newpiezoPos newqpdVolts newfname numNew] = LoadParseData2(dirpath);
                
%                 % low pass filter data
%                 forder = 5;
%                 fNorm = .05;
%                 [newpiezoPos newqpdVolts] = LowPassFilter(newpiezoPos,newqpdVolts,fNorm,forder);

                
                for i = 1:numNew
                    numplots = numplots + 1;
                    name{numplots} = newfname{i};
                    piezoPos{numplots} = newpiezoPos{i};
                    qpdVolts{numplots} = newqpdVolts{i};
                end
                

                % plot data
                close all; figure; hold on; box on;
                h = PlotRawData(piezoPos,qpdVolts,1);
                PlotLegend(name,'southwest');   
                
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
                                tmppiezoPos{index} = piezoPos{i};
                                tmpqpdVolts{index} = qpdVolts{i};
                                tmpname{index} = name{i};
                                index = index + 1;
                            end
                        end
                        piezoPos = tmppiezoPos;
                        qpdVolts = tmpqpdVolts;
                        name = tmpname;
                        numplots = numplots - 1;
                        
                        % plot force vs extension
                        close all; 
                        linewidth = 2;
                        h = PlotRawData(piezoPos,qpdVolts,1);
                        PlotLegend(name,'southwest');
                    end
                else
                    disp('There are no plots, idiot!');
                end
                
            case 4
               
                close all;
                [piezoPos qpdVolts] = AdjustEquilibriumPosition(piezoPos,qpdVolts);

            case 5
                
                name = ChangeNames(name);
                close all; 
                h = PlotRawData(piezoPos,qpdVolts,1);
                PlotLegend(name,'southwest');
                
            case 6
                status = 0;
            otherwise 
                display('invalid input, idiot');
        end
        
    else
        disp('Invalid input idiot!');
    end
    k = k + 1;
end
    
